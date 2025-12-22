$defaultPermissions = [System.Collections.Generic.HashSet[string]]::new()

$null = $defaultPermissions.Add("Get-Content:*")
$null = $defaultPermissions.Add("Get-ChildItem:*")
$null = $defaultPermissions.Add("Select-String:*")

$tempPermissions = $null

$allowedToolsList = @{}

function Get-SkillFrontmatter {
    [CmdletBinding()]
    param(
        [switch]$AsPSCustomObject,
        [switch]$Compress
    )

    $skillPaths = @(
        "$HOME/.powershell/skills/",
        "./.github/powershell/skills/",
        "./.powershell/skills/"
    )

    $skillRegistry = @{}

    foreach ($path in $skillPaths) {
        if (Test-Path $path) {
            Write-Verbose "[Get-SkillFrontmatter] Scanning path: $path"
            $dirs = Get-ChildItem -Path $path -Directory
            $skillsFound = 0
            foreach ($dir in $dirs) {
                $skillMd = Join-Path $dir.FullName "SKILL.md"
                if (Test-Path $skillMd) {
                    Write-Verbose "[Get-SkillFrontmatter] Found skill: $($dir.Name) at $($dir.FullName)"
                    $skillRegistry[$dir.Name] = $dir.FullName
                    $skillsFound++
                }
            }
            if ($skillsFound -eq 0) {
                Write-Verbose "[Get-SkillFrontmatter] No skills found in path: $path"
            }
        }
        else {
            Write-Verbose "[Get-SkillFrontmatter] Path does not exist: $path"
        }
    }

    $results = @()

    foreach ($skillDir in $skillRegistry.Values) {
        $skillMdPath = Join-Path $skillDir "SKILL.md"
        $file = Get-Item $skillMdPath
        Write-Verbose "[Get-SkillFrontmatter] Importing skill $($file.FullName)"
        $lines = Get-Content $file.FullName
        if ($lines) {
            $start = $lines.IndexOf('---')
            if ($start -ge 0) {
                Write-Verbose "[Get-SkillFrontmatter] Found frontmatter start at line $start"
                # Find the next '---' after $start
                $end = -1
                for ($i = $start + 1; $i -lt $lines.Count; $i++) {
                    if ($lines[$i] -eq '---') {
                        $end = $i
                        break
                    }
                }
                if ($end -gt $start) {
                    Write-Verbose "[Get-SkillFrontmatter] Found frontmatter end at line $end"
                    $frontmatter = $lines[$start..$end]
                    $name = $null
                    $description = $null
                    $allowedTools = $null
                    foreach ($line in $frontmatter) {
                        if ($line -match '^name:\s*(.+)$') {
                            $name = $matches[1]
                            Write-Verbose "[Get-SkillFrontmatter] Found name: $name"
                        }
                        if ($line -match '^description:\s*(.+)$') {
                            $description = $matches[1]
                            Write-Verbose "[Get-SkillFrontmatter] Found description: $description"
                        }
                        if ($line -match '^allowed-tools:\s*(.+)$') {
                            $allowedTools = $matches[1]
                            Write-Verbose "[Get-SkillFrontmatter] Found allowed-tools: $allowedTools"
                        }
                    }

                    $allowedToolsList[$file.FullName] = $allowedTools

                    $results += [PSCustomObject]@{
                        fullname    = $file.FullName
                        name        = $name
                        description = $description                        
                    }
                }
            }
        }
    }

    if ($AsPSCustomObject) {
        Write-Verbose "[Get-SkillFrontmatter] Returning results as PSCustomObject"
        return $results
    }
    
    Write-Verbose "[Get-SkillFrontmatter] Returning results as JSON"
    return $results | ConvertTo-Json -Depth 3 -Compress:$Compress
}

function Read-PSSkill {
    <#
        .SYNOPSIS
        Reads the content of a file as a single string.

        .DESCRIPTION
        The Read-PSSkill function reads the entire content of the file specified by the -Fullname parameter and returns it as a single string. This is typically used to read SKILL.md or other skill-related files in the PowerShell Skills AI Assistant context.

        .PARAMETER Fullname
        The full path to the file to read.
    #>
    [CmdletBinding()]
    param(
        [string]$Fullname
    )

    Write-Verbose "[Read-PSSkill] Reading file: $Fullname"
    $allowedToolsString = $allowedToolsList[$Fullname]
    if ([string]::IsNullOrEmpty($allowedToolsString) -eq $false) {
        Write-Host "[Read-PSSkill $Fullname] Allowed tools provided: $($allowedToolsString)" -ForegroundColor Yellow
        
        # Parse comma-separated tools and add each one to tempPermissions
        $tools = $allowedToolsString -split ',\s*'
        foreach ($tool in $tools) {
            $tool = $tool.Trim()
            if ([string]::IsNullOrEmpty($tool) -eq $false) {
                Write-Verbose "[Read-PSSkill] Adding tool to permissions: $tool"
                $null = $tempPermissions.Add($tool)
            }
        }
    }
    else {
        Write-Host "[Read-PSSkill $Fullname] No allowed tools provided." -ForegroundColor Yellow
    }

    Get-Content -Path $Fullname -Raw
}

function Test-CodeAllowed {
    param(
        [string]$code,
        [System.Collections.Generic.HashSet[string]]$allowedTools
    )

    if ([string]::IsNullOrEmpty($code) -and $allowedTools.Count -eq 0) {
        return $false
    }

    $returnCode = $false

    foreach ($tool in $allowedTools) {
        if ($tool.EndsWith(':*')) {
            # Remove :* and use prefix match
            $prefix = $tool.Substring(0, $tool.Length - 2)
            
            # For :*, we match the prefix and anything that follows
            $returnCode = $code.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
            if ($returnCode) {
                break
            }
        }
        else {
            # For exact patterns, require exact match (including trailing slash)
            $returnCode = $code.Equals($tool, [System.StringComparison]::OrdinalIgnoreCase)
            if ($returnCode) {
                break
            }
        }
    }

    return $returnCode
}

function Invoke-PSSkillCode {
    <#
        .SYNOPSIS
        Executes PowerShell code or invokes a script from a SKILL.md file.

        .DESCRIPTION
        The Invoke-PSSkillCode function executes the provided code. If the code starts with a .ps1 file, it treats it as a script invocation and resolves relative paths relative to the SKILL.md file's directory. Otherwise, it runs the code using Invoke-Expression.

        .PARAMETER SkillFullname
        The full path to the SKILL.md file.

        .PARAMETER Code
        The code content to execute.
    #>
    [CmdletBinding()]
    param(
        [string]$SkillFullname,
        [string]$Code
    )

    Write-Verbose "[Invoke-PSSkillCode] Executing code for skill: $SkillFullname"
    $trimmedCode = $Code.Trim()
    
    # Check if code contains a .ps1 file reference (handles scripts with arguments)
    if ($trimmedCode -match '(?<script>[^\s]+\.ps1)(?<args>.*)$') {
        $scriptPath = $matches['script']
        $scriptArgs = $matches['args'].Trim()
        
        Write-Verbose "[Invoke-PSSkillCode] Treating as script path: $scriptPath with args: $scriptArgs"
        
        if ($scriptPath -notmatch '^[A-Za-z]:' -and $scriptPath -notmatch '^/' -and $scriptPath -notmatch '^\\\\') {
            # Relative path without drive letter, resolve relative to skill directory
            $skillDir = Split-Path $SkillFullname
            
            # Handle ./ or .\ prefixes
            if ($scriptPath -match '^\.[\\/]') {
                $cleanPath = $scriptPath -replace '^\.[\\/]', ''
            }
            else {
                $cleanPath = $scriptPath
            }
            
            $fullPath = Join-Path $skillDir $cleanPath
        }
        else {
            # Absolute path
            $fullPath = $scriptPath
        }
        
        try {
            $resolvedPath = Resolve-Path $fullPath -ErrorAction Stop
            Write-Verbose "[Invoke-PSSkillCode] Resolved script path: $resolvedPath"
            
            if ($scriptArgs) {
                Write-Verbose "[Invoke-PSSkillCode] Invoking with arguments: $scriptArgs"
                & $resolvedPath $scriptArgs
            }
            else {
                & $resolvedPath
            }
        }
        catch {
            Write-Host "Error resolving script path: $fullPath`nError: $_" -ForegroundColor Red
            throw
        }
    }
    else {
        # Treat as code
        Write-Verbose "[Invoke-PSSkillCode] Executing as PowerShell code"
        
        # Check Allowed Tools
        if (!(Test-CodeAllowed $code $tempPermissions)) {
            Write-Verbose "[Invoke-PSSkillCode] Code not in allowed tools, requesting permission"
            $formatParams = @{
                Title    = "The Agent wants to run the following code:"
                BoxColor = "Blue"
                Text     = $code
            }
        
            Out-BoxedText @formatParams | Out-Host

            $nextStepsParams = @{
                Text     = "Do you want to execute this code? (y/n)"
                Title    = "Next Steps"
                BoxColor = "Cyan"
            }
            
            Out-BoxedText @nextStepsParams | Out-Host

            # Prompt for permission
            $permission = Read-Host "> "
            if ($permission -notmatch '^(yes|y)$') {
                $msg = "Execution of the code was cancelled by the user."
                Write-Host $msg -ForegroundColor Yellow
            
                return $msg
            }
        }

        Out-BoxedText -Title "Executing Code..." -BoxColor Magenta -Text $code | Out-Host

        Invoke-Expression $Code
    }
}

function Invoke-PSSkills {
    [CmdletBinding()]
    param(
        [string]$Prompt,
        [string[]]$Tools,
        [string]$Model = "gpt-4.1",
        [switch]$ShowToolCalls
    )

    if ([string]::IsNullOrEmpty($Prompt) -eq $false) {
        Write-Host "Invoking PSSkills with Prompt:" -ForegroundColor Green
        Write-Host $Prompt -ForegroundColor White
    }
    else {
        Write-Host "Invoking PSSkills in interactive mode." -ForegroundColor Green
    }
    #Write-Host "Model: $Model`nCalled with Prompt:`n$Prompt`n" -ForegroundColor Cyan


    Write-Verbose "[Invoke-PSSkills] Called with Prompt: $Prompt, Model: $Model, Tools: $Tools, ShowToolCalls: $ShowToolCalls"
    $targetTools = @(
        'Read-PSSkill'
        'Invoke-PSSkillCode'
    )

    if ($tools.count -gt 0) {
        Write-Verbose "[Invoke-PSSkills] Adding user-specified tools: $Tools"
        $targetTools += $tools
    }

    Write-Verbose "[Invoke-PSSkills] Building instructions for agent"
    $instructions = @"
You are a PowerShell Skills AI Assistant. 

When a user provides a request, analyze the request to determine which skills are relevant and read them first.

**CRITICAL RULES:**

1. If you need to read a skill, **ONLY USE** Read-PSSkill to read the SKILL.md file. 
   **DO NOT USE** Read-PSSkill to read any other type of file. 

2. After reading a SKILL.md file, immediately identify and extract the PowerShell code blocks (enclosed in ``````powershell ... ``````).

3. **Replace placeholder values in the code with appropriate values from the user's request:**
   - Placeholders like <path>, <file>, <directory>, <name>, <value>, etc. should be replaced with actual values derived from the user's request
   - Example: If the skill has 'Get-ChildItem -Path <path>' and the user asks 'list files in C:\Users', replace <path> with 'C:\Users'
   - Use the current directory '.' if no specific path is provided
   - Do NOT include the angle brackets in the replaced values

4. Execute the substituted code using Invoke-PSSkillCode with the fullname of the SKILL.md and the code with placeholders replaced.

5. Run code blocks sequentially if multiple skills are needed.

6. Do not ask for permission before running code blocks from SKILL.md files.

7. Do one task at a time, reading SKILL.md files as needed, and move to the next task.

8. If something is cancelled or fails, report back the error message. Do not reflect the Skill instructions in your response.

**Important:** When executing scripts from SKILL.md files:
- The Invoke-PSSkillCode tool automatically resolves relative paths (like './scripts/hello.ps1') relative to the SKILL.md file's location
- Script arguments should be passed as-is (e.g., './scripts/hello.ps1 -name "John"')

You have access to the skills:
**Skills**

$(Get-SkillFrontmatter -Compress)

"@

    Write-Verbose "[Invoke-PSSkills] Creating agent"
    
    $tempPermissions = (New-Object System.Collections.Generic.HashSet[string])::new($defaultPermissions)

    $agent = New-Agent -ShowToolCalls:$ShowToolCalls -LLM (New-OpenAIChat $Model) -Tools $targetTools -Instructions $instructions

    if ($Prompt) {
        Write-Verbose "[Invoke-PSSkills] Getting agent response for prompt"
        $response = $agent | Get-AgentResponse $Prompt
        Write-Verbose "[Invoke-PSSkills] Returning agent response"
        return $response
    }
    else {
        Write-Verbose "[Invoke-PSSkills] Starting agent conversation"
        $agent | Start-Conversation -Emoji '🛠️🧬'
    }
}