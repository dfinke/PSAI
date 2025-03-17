function ConvertTo-AIPrompt {
    <#
    .SYNOPSIS
        Converts a GitHub repository into a single XML file optimized for AI tools.

    .DESCRIPTION
        This function downloads files from a GitHub repository and packages them into a single XML file
        that can be easily used with AI tools like ChatGPT, Claude, Gemini, etc.
        
        The repository content is organized into a structured format with each file's content 
        encapsulated in separate document sections with paths and other metadata.

    .PARAMETER RepoSlug
        The GitHub repository slug in format 'owner/repo'. Optional subfolder can be specified using 'owner/repo/subfolder'.

    .PARAMETER OutputPath
        Path to save the generated XML file. If not provided, the output is returned as a string.

    .PARAMETER Exclude
        Array of file patterns to exclude (wildcards supported, e.g., *.jpg, *.xlsx).
        By default, common binary and non-text formats are excluded (see Notes for the list).

    .PARAMETER Include
        Array of file patterns to include (wildcards supported, e.g., *.ps1, *.md). If not specified, all files are included.

    .PARAMETER Token
        GitHub API token for private repositories. Optional for public repos but recommended to avoid rate limiting.
        If not provided, the function will attempt to use $env:GITHUB_TOKEN.

    .PARAMETER IncludeBinary
        Switch to override the default binary file exclusions. When specified, only the files explicitly
        mentioned in the Exclude parameter will be excluded.

    .EXAMPLE
        ConvertTo-AIPrompt -RepoSlug "dfinke/ImportExcel" -OutputPath "D:\ImportExcel.xml" -Exclude "*.xlsx","*.jpg"
        
        Exports the entire dfinke/ImportExcel repository, excluding xlsx and jpg files and all default binary formats.

    .EXAMPLE
        ConvertTo-AIPrompt -RepoSlug "dfinke/ImportExcel/Examples" -Include "*.ps1","*.md" | Set-Content -Path "ExcelExamples.xml"
        
        Exports only PowerShell and Markdown files from the Examples folder of the ImportExcel repository.

    .EXAMPLE
        ConvertTo-AIPrompt -RepoSlug "owner/repo" -IncludeBinary
        
        Exports all files from the repository, including binary files that would normally be excluded.

    .NOTES
        Requires connectivity to api.github.com.
        Consider using a token to avoid GitHub API rate limits.
        You can set $env:GITHUB_TOKEN environment variable for authentication instead of passing the token parameter.
        
        Default excluded binary and non-text formats:
        - Images: *.jpg, *.jpeg, *.png, *.gif, *.bmp, *.ico, *.svg, *.webp
        - Documents: *.pdf, *.docx, *.xlsx, *.pptx, *.odt, *.ods, *.odp
        - Archives: *.zip, *.tar, *.gz, *.7z, *.rar
        - Executables: *.exe, *.dll, *.so, *.dylib, *.bin
        - Media: *.mp3, *.mp4, *.wav, *.avi, *.mov, *.flac, *.mkv
        - Others: *.dat, *.db, *.sqlite, *.pyc, *.class, *.jar, *.iso, *.pdb
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$RepoSlug,
        
        [Parameter(Mandatory = $false)]
        [string]$OutputPath,
        
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude,
        
        [Parameter(Mandatory = $false)]
        [string[]]$Include,
        
        [Parameter(Mandatory = $false)]
        [string]$Token,
        
        [Parameter(Mandatory = $false)]
        [switch]$IncludeBinary
    )

    # Define common binary file formats to exclude by default
    $defaultBinaryExclusions = @(
        # Images
        "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.ico", "*.svg", "*.webp",
        # Documents
        "*.pdf", "*.docx", "*.xlsx", "*.pptx", "*.odt", "*.ods", "*.odp",
        # Archives
        "*.zip", "*.tar", "*.gz", "*.7z", "*.rar",
        # Executables
        "*.exe", "*.dll", "*.so", "*.dylib", "*.bin",
        # Media
        "*.mp3", "*.mp4", "*.wav", "*.avi", "*.mov", "*.flac", "*.mkv",
        # Others
        "*.dat", "*.db", "*.sqlite", "*.pyc", "*.class", "*.jar", "*.iso", "*.pdb"
    )
    
    # Merge default exclusions with user-provided ones unless IncludeBinary is specified
    if (-not $IncludeBinary) {
        if ($Exclude) {
            $Exclude = $Exclude + $defaultBinaryExclusions | Select-Object -Unique
        }
        else {
            $Exclude = $defaultBinaryExclusions
        }
        Write-Verbose "Excluding binary files by default. Use -IncludeBinary to override."
    }

    # Parse repository information
    $repoInfo = $RepoSlug -split '/'
    if ($repoInfo.Count -lt 2) {
        throw "Invalid repository slug format. Expected 'owner/repo' or 'owner/repo/subfolder'."
    }

    $owner = $repoInfo[0]
    $repo = $repoInfo[1]
    
    # Check if a specific subfolder was requested
    $subfolder = ""
    $originalSubfolder = ""
    if ($repoInfo.Count -gt 2) {
        $originalSubfolder = [string]::Join('/', $repoInfo[2..$($repoInfo.Count - 1)])
        $subfolder = $originalSubfolder
    }

    Write-Verbose "Processing repository: $owner/$repo, subfolder: $($subfolder ? $subfolder : '(root)')"
    
    if ($Exclude -and $Exclude.Count -gt 0) {
        Write-Verbose "Excluding file patterns: $($Exclude -join ', ')"
    }
    
    if ($Include -and $Include.Count -gt 0) {
        Write-Verbose "Including only file patterns: $($Include -join ', ')"
    }

    # Setup API headers
    $headers = @{
        'Accept' = 'application/vnd.github.v3+json'
    }
    
    # Add token if provided, otherwise check for environment variable
    if ($Token) {
        Write-Verbose "Using provided token for authentication"
        $headers['Authorization'] = "token $Token"
    }
    elseif ($env:GITHUB_TOKEN) {
        Write-Verbose "Using GITHUB_TOKEN environment variable for authentication"
        $headers['Authorization'] = "token $env:GITHUB_TOKEN"
    }
    else {
        Write-Verbose "No authentication token provided. Accessing public repositories only."
    }

    # First check if the repository exists and get the correct case for the repo name
    try {
        Write-Progress -Activity "Verifying Repository" -Status "Checking $owner/$repo" -PercentComplete 0
        $repoUrl = "https://api.github.com/repos/$owner/$repo"
        Write-Verbose "Verifying repository: $repoUrl"
        $repoInfo = Invoke-RestMethod -Uri $repoUrl -Headers $headers -ErrorAction Stop
        
        # Use the correct case from the API response
        $owner = $repoInfo.owner.login
        $repo = $repoInfo.name
        
        Write-Verbose "Using repository with correct case: $owner/$repo"
    }
    catch {
        Write-Progress -Activity "Verifying Repository" -Status "Repository not found, trying case-insensitive search" -PercentComplete 50
        
        if ($_ -match "404") {
            Write-Verbose "Repository not found with exact case. Attempting case-insensitive search..."
            
            # Try to search for the repository using the GitHub search API
            try {
                # Use the search API to find repositories case-insensitively
                $searchUrl = "https://api.github.com/search/repositories?q=$repo+user:$owner"
                Write-Verbose "Searching for repository: $searchUrl"
                $searchResult = Invoke-RestMethod -Uri $searchUrl -Headers $headers -ErrorAction Stop
                
                # Check if any repositories were found
                if ($searchResult.total_count -gt 0) {
                    # Find the repository that matches case-insensitively
                    $matchedRepo = $searchResult.items | Where-Object { $_.name -ieq $repo -and $_.owner.login -ieq $owner } | Select-Object -First 1
                    
                    if ($matchedRepo) {
                        # Use the correct case from the search results
                        $owner = $matchedRepo.owner.login
                        $repo = $matchedRepo.name
                        
                        Write-Verbose "Found repository with correct case: $owner/$repo"
                        Write-Progress -Activity "Verifying Repository" -Completed
                    }
                    else {
                        Write-Progress -Activity "Verifying Repository" -Completed
                        throw "Repository not found: $owner/$repo. Please check that the repository exists and is spelled correctly."
                    }
                }
                else {
                    Write-Progress -Activity "Verifying Repository" -Completed
                    throw "Repository not found: $owner/$repo. Please check that the repository exists and is spelled correctly."
                }
            }
            catch {
                Write-Progress -Activity "Verifying Repository" -Completed
                throw "Repository not found: $owner/$repo. Please check that the repository exists and is spelled correctly. Error: $_"
            }
        }
        else {
            Write-Progress -Activity "Verifying Repository" -Completed
            throw "Error accessing repository information: $_"
        }
    }

    # Function to recursively get all files from a path in the repo
    function Get-RepoContents {
        param (
            [string]$Path,
            [hashtable]$Headers,
            [string]$Owner,
            [string]$Repo
        )

        # Correctly format the URL for the GitHub API
        # If the path is empty, don't include it in the URL
        $apiPath = if ([string]::IsNullOrEmpty($Path)) { "" } else { "/$Path" }
        $url = "https://api.github.com/repos/$Owner/$Repo/contents$apiPath"
        
        Write-Verbose "Fetching: $url"
        Write-Progress -Activity "Discovering Files" -Status "Scanning $Owner/$Repo/$Path" -PercentComplete -1
        
        try {
            $response = Invoke-RestMethod -Uri $url -Headers $Headers -ErrorAction Stop
            
            $files = @()
            
            # Handle case when response is a single item (not an array)
            if ($response -isnot [System.Array]) {
                $response = @($response)
            }
            
            foreach ($item in $response) {
                if ($item.type -eq "dir") {
                    # Show progress when navigating directories
                    Write-Progress -Activity "Discovering Files" -Status "Scanning directory: $($item.path)" -PercentComplete -1
                    
                    # Recursively get files from subdirectory
                    $subFiles = Get-RepoContents -Path $item.path -Headers $Headers -Owner $Owner -Repo $Repo
                    $files += $subFiles
                }
                elseif ($item.type -eq "file") {
                    # Check if file should be excluded
                    $shouldExclude = $false
                    if ($Exclude) {
                        foreach ($pattern in $Exclude) {
                            if ($item.name -like $pattern) {
                                $shouldExclude = $true
                                Write-Verbose "Excluding file (matched pattern '$pattern'): $($item.path)"
                                break
                            }
                        }
                    }
                    
                    # Check if file should be included
                    $shouldInclude = $true
                    if ($Include) {
                        $shouldInclude = $false
                        foreach ($pattern in $Include) {
                            if ($item.name -like $pattern) {
                                $shouldInclude = $true
                                break
                            }
                        }
                        
                        if (-not $shouldInclude) {
                            Write-Verbose "Skipping file (no match in Include patterns): $($item.path)"
                        }
                    }
                    
                    if (-not $shouldExclude -and $shouldInclude) {
                        Write-Verbose "Including file: $($item.path)"
                        $files += $item
                    }
                }
            }
            
            return $files
        }
        catch {
            # Make error message more helpful
            if ($_ -match "404") {
                # If the subfolder isn't found, we'll try different case variations
                if (-not [string]::IsNullOrEmpty($Path)) {
                    Write-Verbose "Path not found, checking parent directory for case-insensitive match"
                    
                    # Get the parent directory
                    $parentPath = Split-Path -Path $Path -Parent
                    $leafName = Split-Path -Path $Path -Leaf
                    
                    # If we're already at the root, there's no parent to check
                    if ([string]::IsNullOrEmpty($parentPath)) {
                        Write-Error "Path not found: $Path. Check that the path exists and is spelled correctly (GitHub is case-sensitive)."
                        throw
                    }
                    
                    try {
                        # Get the contents of the parent directory
                        $parentUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$parentPath"
                        $parentContents = Invoke-RestMethod -Uri $parentUrl -Headers $Headers
                        
                        # Handle case when response is a single item (not an array)
                        if ($parentContents -isnot [System.Array]) {
                            $parentContents = @($parentContents)
                        }
                        
                        # Look for a case-insensitive match for the directory
                        foreach ($item in $parentContents) {
                            if ($item.type -eq "dir" -and $item.name -ieq $leafName) {
                                Write-Verbose "Found case-insensitive match: $($item.name) instead of $leafName"
                                # Use the correct case from the API response
                                return Get-RepoContents -Path $item.path -Headers $Headers -Owner $Owner -Repo $Repo
                            }
                        }

                        # If we're looking for a file (not a directory), check for case-insensitive file matches
                        # This is needed for direct file access like owner/repo/path/to/file.ps1
                        foreach ($item in $parentContents) {
                            if ($item.type -eq "file" -and $item.name -ieq $leafName) {
                                Write-Verbose "Found case-insensitive file match: $($item.name) instead of $leafName"
                                # Return just this file as an array with one item
                                return @($item)
                            }
                        }
                    }
                    catch {
                        # If we can't check parent, just show the original error
                        Write-Error "Path not found: $Path. Check that the path exists and is spelled correctly (GitHub is case-sensitive)."
                        throw
                    }
                }
                
                Write-Error "Repository or path not found: $url. Make sure the repository and subfolder exist and are accessible."
            } 
            else {
                Write-Error "Failed to get repository contents: $_"
            }
            throw
        }
    }

    # Get all files from the repository
    $allFiles = @()
    try {
        Write-Progress -Activity "Discovering Files" -Status "Scanning repository structure" -PercentComplete 0
        
        # First try with the original subfolder case
        $errorActionPreference = $ErrorActionPreference
        try {
            # Temporarily suppress errors during the first attempt
            $ErrorActionPreference = 'SilentlyContinue'
            $firstAttemptError = $null
            
            # Capture any error that occurs
            try {
                $allFiles = Get-RepoContents -Path $subfolder -Headers $headers -Owner $owner -Repo $repo -ErrorVariable firstAttemptError -ErrorAction SilentlyContinue
            }
            catch {
                $firstAttemptError = $_
            }
            
            # If there was an error and it's a 404, try case-insensitive approach
            if ($firstAttemptError -and $firstAttemptError.ToString() -match "404" -and -not [string]::IsNullOrEmpty($originalSubfolder)) {
                Write-Verbose "Subfolder not found with provided case. Attempting case-insensitive subfolder search..."
                
                # Try to find the correct case for the subfolder by navigating case-insensitively
                $foundSubfolderPath = ""
                $pathParts = $originalSubfolder -split '/'
                $currentPath = ""
                
                # Iterate through each level of the path to find correct case
                foreach ($part in $pathParts) {
                    try {
                        # Get the current directory contents
                        $parentUrl = if ([string]::IsNullOrEmpty($currentPath)) {
                            "https://api.github.com/repos/$owner/$repo/contents"
                        }
                        else {
                            "https://api.github.com/repos/$owner/$repo/contents/$currentPath"
                        }
                        
                        Write-Verbose "Checking directory: $parentUrl"
                        $parentContents = Invoke-RestMethod -Uri $parentUrl -Headers $headers
                        
                        # Handle case when response is a single item (not an array)
                        if ($parentContents -isnot [System.Array]) {
                            $parentContents = @($parentContents)
                        }
                        
                        # Find a case-insensitive match for this directory part
                        $found = $false
                        foreach ($item in $parentContents) {
                            if ($item.type -eq "dir" -and $item.name -ieq $part) {
                                # Use the correct case from the response
                                if ([string]::IsNullOrEmpty($foundSubfolderPath)) {
                                    $foundSubfolderPath = $item.name
                                }
                                else {
                                    $foundSubfolderPath = "$foundSubfolderPath/$($item.name)"
                                }
                                
                                $currentPath = $foundSubfolderPath
                                $found = $true
                                Write-Verbose "Found case-insensitive match for '$part': $($item.name)"
                                break
                            }
                            # Check if this is the last part of the path and might be a file
                            elseif ($part -eq $pathParts[-1] -and $item.type -eq "file" -and $item.name -ieq $part) {
                                # This is a direct file reference, return just this file
                                Write-Verbose "Found direct file reference with case-insensitive match: $($item.name)"
                                # Set the correct path for display
                                if ([string]::IsNullOrEmpty($foundSubfolderPath)) {
                                    $foundSubfolderPath = $item.name
                                }
                                else {
                                    $foundSubfolderPath = "$foundSubfolderPath/$($item.name)"
                                }
                                
                                # Restore error action preference
                                $ErrorActionPreference = $errorActionPreference
                                
                                # Return just this file
                                $allFiles = @($item)
                                $found = $true
                                break
                            }
                        }
                        
                        if (-not $found) {
                            # If we can't find a match for this part, the subfolder doesn't exist
                            throw "Subfolder part '$part' not found in path '$currentPath'"
                        }
                        
                        # If we found a direct file match, break out of the loop
                        if ($found -and $allFiles.Count -gt 0) {
                            break
                        }
                    }
                    catch {
                        Write-Verbose "Error finding path: $_"
                        throw "Path not found: $originalSubfolder. Check that it exists and is spelled correctly."
                    }
                }
                
                # If we found a path but haven't already retrieved a direct file
                if ($foundSubfolderPath -and $allFiles.Count -eq 0) {
                    Write-Verbose "Using path with correct case: $foundSubfolderPath (original: $originalSubfolder)"
                    $subfolder = $foundSubfolderPath
                    # Try again with the correct case path
                    # Restore error action preference for the final attempt with correct case
                    $ErrorActionPreference = $errorActionPreference
                    $allFiles = Get-RepoContents -Path $subfolder -Headers $headers -Owner $owner -Repo $repo
                }
                else {
                    # Restore error action preference before throwing
                    $ErrorActionPreference = $errorActionPreference
                    throw "Path not found: $originalSubfolder. Check that it exists and is spelled correctly."
                }
            }
            elseif ($firstAttemptError) {
                # Restore error action preference before re-throwing
                $ErrorActionPreference = $errorActionPreference
                throw $firstAttemptError
            }
        }
        finally {
            # Ensure error action preference is restored
            $ErrorActionPreference = $errorActionPreference
        }
        
        Write-Progress -Activity "Discovering Files" -Completed
    }
    catch {
        Write-Progress -Activity "Discovering Files" -Completed
        throw "Failed to retrieve repository contents: $_"
    }

    # If no files were found, inform the user
    if ($allFiles.Count -eq 0) {
        Write-Warning "No files found in repository $owner/$repo$(if ($subfolder) { "/$subfolder" })"
    }
    else {
        Write-Verbose "Found $($allFiles.Count) files to process"
    }

    # Generate the XML document
    $xmlOutput = [System.Text.StringBuilder]::new()
    [void]$xmlOutput.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
    [void]$xmlOutput.AppendLine('<documents>')
    
    $fileIndex = 1
    $totalFiles = $allFiles.Count
    
    # Process each file
    foreach ($file in $allFiles) {
        try {
            $percentComplete = [Math]::Min(100, [Math]::Round(($fileIndex / $totalFiles) * 100))
            Write-Progress -Activity "Processing Files" -Status "Processing file $fileIndex of $totalFiles" -CurrentOperation "$($file.path)" -PercentComplete $percentComplete
            
            Write-Verbose "Processing file: $($file.path)"
            
            # Get file content via GitHub API
            $fileUrl = $file.download_url
            if (-not $fileUrl) {
                Write-Warning "No download URL for $($file.path), skipping"
                continue
            }
            
            $fileContent = Invoke-RestMethod -Uri $fileUrl -Headers $headers -ErrorAction Stop
            
            # HTML decode the file content
            Add-Type -AssemblyName System.Web
            $decodedContent = [System.Web.HttpUtility]::HtmlDecode($fileContent)
            
            # Add document entry to XML
            [void]$xmlOutput.AppendLine("    <document index='$fileIndex'>")
            [void]$xmlOutput.AppendLine("        <source>$($file.path)</source>")
            [void]$xmlOutput.AppendLine("        <document_content>")
            [void]$xmlOutput.AppendLine("            $([System.Security.SecurityElement]::Escape($decodedContent))")
            [void]$xmlOutput.AppendLine("        </document_content>")
            [void]$xmlOutput.AppendLine("    </document>")
            
            $fileIndex++
        }
        catch {
            Write-Error "Error processing file $($file.path): $_"
        }
    }
    
    # Complete the progress bar
    Write-Progress -Activity "Processing Files" -Completed
    
    [void]$xmlOutput.AppendLine('</documents>')
    
    $result = $xmlOutput.ToString()
    
    # Either save to file or return as string
    if ($OutputPath) {
        $result | Out-File -FilePath $OutputPath -Encoding UTF8
        Write-Verbose "Output saved to: $OutputPath"
        return $OutputPath
    }
    else {
        return $result
    }
}
