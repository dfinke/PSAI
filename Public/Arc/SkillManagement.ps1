function Find-Skill {
    [CmdletBinding()]
    param(
        [string[]]$Repository,
        [string]$Name = "*"
    )

    if (-not $Repository) {
        if ($env:PSSkillRepository) {
            $Repository = $env:PSSkillRepository -split ',' | Where-Object { $_ }
        }
    }

    if (-not $Repository) {
        throw "No repository specified. Use -Repository or set `$env:PSSkillRepository`."
    }

    $headers = @{}
    if ($env:GITHUB_TOKEN) {
        $headers.Authorization = "Bearer $env:GITHUB_TOKEN"
    }

    $skills = @()
    foreach ($repo in $Repository) {
        Write-Host -ForegroundColor "Green" "Searching repository: $repo"

        # Parse repository input
        $owner = $null
        $repoName = $null
        $branch = $null
        $subPath = $null
        if ($repo -match '^https://github\.com/(.+)$') {
            # Full URL
            $pathParts = $matches[1] -split '/'
            if ($pathParts.Length -ge 2) {
                $owner = $pathParts[0]
                $repoName = $pathParts[1]
                if ($pathParts.Length -ge 4 -and $pathParts[2] -eq 'tree') {
                    $branch = $pathParts[3]
                    if ($pathParts.Length -gt 4) {
                        $subPath = $pathParts[4..($pathParts.Length - 1)] -join '/'
                    }
                }
                else {
                    Write-Warning "Invalid GitHub URL format: $repo. Expected https://github.com/owner/repo/tree/branch[/path]"
                    continue
                }
            }
            else {
                Write-Warning "Invalid GitHub URL: $repo"
                continue
            }
        }
        else {
            # Shorthand: owner/repo[/path]
            $parts = $repo -split '/'
            if ($parts.Length -ge 2) {
                $owner = $parts[0]
                $repoName = $parts[1]
                if ($parts.Length -gt 2) {
                    $subPath = $parts[2..($parts.Length - 1)] -join '/'
                }
            }
            else {
                Write-Warning "Invalid repository format: $repo. Expected owner/repo[/path] or full URL."
                continue
            }
        }
        # Get default branch if not specified
        if (-not $branch) {
            try {
                $repoInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repoName" -Headers $headers
                $branch = $repoInfo.default_branch
            }
            catch {
                Write-Warning "Failed to get default branch for $owner/$repoName : $_. Using 'main' as fallback."
                $branch = 'main'
            }
        }
        $url = "https://api.github.com/repos/$owner/$repoName/contents"
        if ($subPath) {
            $url += "/$subPath"
        }
        $url += "?ref=$branch"
        try {
            $contents = Invoke-RestMethod -Uri $url -Headers $headers
            $dirs = $contents | Where-Object { $_.type -eq 'dir' -and $_.name -like $Name }
            foreach ($dir in $dirs) {
                # Get description from SKILL.md
                $description = $null
                $dirUrl = "https://api.github.com/repos/$owner/$repoName/contents"
                if ($subPath) { $dirUrl += "/$subPath" }
                $dirUrl += "/$($dir.name)?ref=$branch"
                try {
                    $dirContents = Invoke-RestMethod -Uri $dirUrl -Headers $headers
                    $skillMd = $dirContents | Where-Object { $_.name -eq 'SKILL.md' -and $_.type -eq 'file' }
                    if ($skillMd) {
                        $rawUrl = $skillMd.download_url
                        $content = Invoke-WebRequest -Uri $rawUrl -Headers $headers | Select-Object -ExpandProperty Content
                        $lines = $content -split '\r?\n'
                        $start = $lines.IndexOf('---')
                        if ($start -ge 0) {
                            $end = -1
                            for ($i = $start + 1; $i -lt $lines.Count; $i++) {
                                if ($lines[$i] -eq '---') {
                                    $end = $i
                                    break
                                }
                            }
                            if ($end -eq -1) { $end = $lines.Count - 1 }
                            if ($end -gt $start) {
                                $frontmatter = $lines[$start..$end]
                                foreach ($line in $frontmatter) {
                                    if ($line -match '(?i)^description:\s*(.+)$') {
                                        $description = $matches[1]
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                catch {
                    # Ignore errors, description remains null
                }
                $skills += [pscustomobject][ordered]@{
                    Name        = $dir.name
                    Repository  = $repo
                    Description = $description
                }
            }
        }
        catch {
            Write-Warning "Failed to get contents from $repo : $_"
        }
    }
    $skills | Sort-Object Name
}

function Install-Skill {
    <#
        CurrentUser: Installs to $HOME/.powershell/skills/ (user-specific)
        Workspace: Installs to ./.github/powershell/skills/ (workspace-specific)
        Local: Installs to ./.powershell/skills/ (local project directory)
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Name,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Repository,
        [ValidateSet('CurrentUser', 'Workspace', 'Local')]
        [string]$Scope = 'CurrentUser'
    )

    begin {
        $headers = @{}
        if ($env:GITHUB_TOKEN) {
            $headers.Authorization = "Bearer $env:GITHUB_TOKEN"
        }
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid())
        New-Item -ItemType Directory -Path $tempDir | Out-Null
    }

    process {
        if (-not $Name -or -not $Repository) { return }

        # Parse repository input
        $owner = $null
        $repoName = $null
        $subPath = $null
        if ($Repository -match '^https://github\.com/(.+)$') {
            # Full URL
            $pathParts = $matches[1] -split '/'
            if ($pathParts.Length -ge 2) {
                $owner = $pathParts[0]
                $repoName = $pathParts[1]
                if ($pathParts.Length -ge 4 -and $pathParts[2] -eq 'tree') {
                    if ($pathParts.Length -gt 4) {
                        $subPath = $pathParts[4..($pathParts.Length - 1)] -join '/'
                    }
                }
                else {
                    Write-Warning "Invalid GitHub URL format: $Repository. Expected https://github.com/owner/repo/tree/branch[/path]"
                    return
                }
            }
            else {
                Write-Warning "Invalid GitHub URL: $Repository"
                return
            }
        }
        else {
            # Shorthand: owner/repo[/path]
            $parts = $Repository -split '/'
            if ($parts.Length -ge 2) {
                $owner = $parts[0]
                $repoName = $parts[1]
                if ($parts.Length -gt 2) {
                    $subPath = $parts[2..($parts.Length - 1)] -join '/'
                }
            }
            else {
                Write-Warning "Invalid repository format: $Repository. Expected owner/repo[/path] or full URL."
                return
            }
        }

        $repoUrl = "https://github.com/$owner/$repoName.git"

        # Clone to temp
        & git clone --depth 1 $repoUrl $tempDir 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to clone $repoUrl"
            return
        }

        $skillDir = Join-Path $tempDir $Name
        if ($subPath) {
            $skillDir = Join-Path $tempDir $subPath $Name
        }
        if (-not (Test-Path $skillDir)) {
            Write-Error "Skill $Name not found in $Repository"
            Remove-Item -Recurse -Force $tempDir
            return
        }

        # Determine install path
        switch ($Scope) {
            'CurrentUser' { $installPath = "$HOME/.powershell/skills/" }
            'Workspace' { $installPath = "./.github/powershell/skills/" }
            'Local' { $installPath = "./.powershell/skills/" }
        }

        if (-not (Test-Path $installPath)) {
            New-Item -ItemType Directory -Path $installPath | Out-Null
        }

        $dest = Join-Path $installPath $Name
        if (Test-Path $dest) {
            Remove-Item -Recurse -Force $dest
        }

        Copy-Item -Recurse $skillDir $dest
        Write-Host "Installed skill $Name to $dest"
    }

    end {
        if (Test-Path $tempDir) {
            Remove-Item -Recurse -Force $tempDir
        }
    }
}

function Get-Skill {
    [CmdletBinding()]
    param(
        [string]$Name = "*"
    )

    $skills = Get-SkillFrontmatter -AsPSCustomObject
    $skills | Where-Object { $_.Name -like $Name } | Select-Object @{Name = 'Name'; Expression = { $_.name } }, @{Name = 'Description'; Expression = { $_.description } }, @{Name = 'Fullname'; Expression = { $_.fullname } }
}