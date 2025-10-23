<#
.SYNOPSIS
File system toolbox for PSAI agents.

.DESCRIPTION
Provides file system operations as tools for AI agents.
Tools include: listing files, reading file content, checking file existence.

.NOTES
This toolbox is automatically discovered when $env:PSAI_TOOLBOX_PATH is set
or when using the default toolbox path.
#>

<#
.SYNOPSIS
Gets a listing of files and directories.

.DESCRIPTION
Lists files and directories in the specified path, similar to Get-ChildItem
but optimized for AI agent use with JSON output.

.PARAMETER Path
The path to list. Defaults to current directory.

.PARAMETER Filter
Optional filter pattern (e.g., "*.ps1").

.PARAMETER Recurse
If specified, recursively lists subdirectories.

.EXAMPLE
Get-DirectoryListing -Path "C:\Scripts" -Filter "*.ps1"
Lists all PowerShell scripts in C:\Scripts.
#>
function Global:Get-DirectoryListing {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Path = ".",
        
        [Parameter()]
        [string]$Filter = "*",
        
        [Parameter()]
        [switch]$Recurse
    )
    
    try {
        $params = @{
            Path = $Path
            Filter = $Filter
        }
        
        if ($Recurse) {
            $params['Recurse'] = $true
        }
        
        $items = Get-ChildItem @params | Select-Object -Property Name, FullName, Length, LastWriteTime, @{
            Name = 'Type'
            Expression = { if ($_.PSIsContainer) { 'Directory' } else { 'File' } }
        }
        
        $result = @{
            path = $Path
            filter = $Filter
            count = $items.Count
            items = $items
        }
        
        return ($result | ConvertTo-Json -Depth 5 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            path = $Path
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Reads the content of a file.

.DESCRIPTION
Reads and returns the content of the specified file as a string.

.PARAMETER Path
The path to the file to read.

.PARAMETER Encoding
The encoding to use (default: UTF8).

.EXAMPLE
Read-FileContent -Path "C:\Scripts\script.ps1"
Reads the content of script.ps1.
#>
function Global:Read-FileContent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        
        [Parameter()]
        [string]$Encoding = "UTF8"
    )
    
    try {
        if (Test-Path $Path -PathType Leaf) {
            $content = Get-Content -Path $Path -Raw -Encoding $Encoding
            $fileInfo = Get-Item $Path
            
            $result = @{
                path = $Path
                size = $fileInfo.Length
                lastModified = $fileInfo.LastWriteTime.ToString("o")
                content = $content
            }
            
            return ($result | ConvertTo-Json -Depth 3 -Compress)
        }
        else {
            return (@{
                error = "File not found or is not a file"
                path = $Path
            } | ConvertTo-Json -Compress)
        }
    }
    catch {
        return (@{
            error = $_.Exception.Message
            path = $Path
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Tests if a file or directory exists.

.DESCRIPTION
Checks whether the specified path exists and returns information about it.

.PARAMETER Path
The path to test.

.EXAMPLE
Test-FileExists -Path "C:\Scripts\script.ps1"
Checks if script.ps1 exists.
#>
function Global:Test-FileExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    try {
        $exists = Test-Path $Path
        
        $result = @{
            path = $Path
            exists = $exists
        }
        
        if ($exists) {
            $item = Get-Item $Path
            $result['type'] = if ($item.PSIsContainer) { 'Directory' } else { 'File' }
            $result['lastModified'] = $item.LastWriteTime.ToString("o")
            
            if (-not $item.PSIsContainer) {
                $result['size'] = $item.Length
            }
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            path = $Path
            exists = $false
        } | ConvertTo-Json -Compress)
    }
}

# Registration function - called by Get-PSAIToolbox
function FileSystemTools {
    [CmdletBinding()]
    param()
    
    # Check if we should register tools based on environment variable
    # This follows the Sourcegraph Toolbox pattern
    if ($env:PSAI_ENABLE_TOOLBOX -eq $false) {
        Write-Verbose "Toolbox registration skipped (PSAI_ENABLE_TOOLBOX is false)"
        return @()
    }
    
    Write-Verbose "Registering FileSystem toolbox tools"
    
    # Register the tools using PSAI's Register-Tool function
    $tools = @(
        Register-Tool -FunctionName Get-DirectoryListing
        Register-Tool -FunctionName Read-FileContent
        Register-Tool -FunctionName Test-FileExists
    )
    
    return $tools
}
