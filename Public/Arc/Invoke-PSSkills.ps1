function Get-SkillFrontmatter {
    [CmdletBinding()]
    param(
        [string]$SkillsRoot = "./skills",
        [switch]$AsPSCustomObject,
        [switch]$Compress
    )

    Write-Verbose "[Get-SkillFrontmatter] Searching for SKILL.md files in $SkillsRoot"
    $skillFiles = Get-ChildItem -Path $SkillsRoot -Recurse -Filter "SKILL.md"
    $results = @()

    foreach ($file in $skillFiles) {
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
                    foreach ($line in $frontmatter) {
                        if ($line -match '^name:\s*(.+)$') {
                            $name = $matches[1]
                            Write-Verbose "[Get-SkillFrontmatter] Found name: $name"
                        }
                        if ($line -match '^description:\s*(.+)$') {
                            $description = $matches[1]
                            Write-Verbose "[Get-SkillFrontmatter] Found description: $description"
                        }
                    }
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
    Get-Content -Path $Fullname -Raw
}

function Invoke-PSSkillCode {
    <#
        .SYNOPSIS
        Executes PowerShell code or invokes a script from a SKILL.md file.

        .DESCRIPTION
        The Invoke-PSSkillCode function executes the provided code. If the code is a single line ending with .ps1, it treats it as a script path and invokes it, resolving relative paths relative to the SKILL.md file's directory. Otherwise, it runs the code using Invoke-Expression.

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
    if ($trimmedCode -match '\.ps1$' -and $trimmedCode -notmatch '\n') {
        # Treat as script path
        Write-Verbose "[Invoke-PSSkillCode] Treating as script path: $trimmedCode"
        $path = $trimmedCode
        if ($path -notmatch '^[A-Za-z]:' -and $path -notmatch '^/') {
            # Relative path, resolve relative to skill directory
            $skillDir = Split-Path $SkillFullname
            $fullPath = Join-Path $skillDir $path
            $resolvedPath = Resolve-Path $fullPath
            Write-Verbose "[Invoke-PSSkillCode] Resolved path: $resolvedPath"
            & $resolvedPath
        }
        else {
            # Absolute path
            Write-Verbose "[Invoke-PSSkillCode] Invoking absolute path: $path"
            & $path
        }
    }
    else {
        
        # Check Allowed Tools

        # Treat as code
        Write-Verbose "[Invoke-PSSkillCode] Executing as code"
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

    Write-Host "Model: $Model`nCalled with Prompt:`n$Prompt`n" -ForegroundColor Cyan
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

When a user provides a request, analyze the request to determine which skills are relevant.

If you need to read a skill, **ONLY USE** Read-PSSkill to read the SKILL.md file. 
**DO NOT USE** Read-PSSkill to read any other type of file. 

Use code blocks and examples in the SKILL.md file as examples to form your response. 

Extract and run all PowerShell code inside fenced code blocks (enclosed in ``````powershell ... ``````, which can be multi-line) from the SKILL.md file using Invoke-PSSkillCode with the fullname of the SKILL.md and the code content. Run the code blocks sequentially if there are multiple. 

Run the prompt request, do not ask for permission before running code blocks from the SKILL.md file.

Do one task at a time, then move on to the next, reading the SKILL.md files as needed.

If something is cancelled or fails report back the error message. Do not reflect the Skill instructions in your response.

You have access to the skills:
**Skills**

$(Get-SkillFrontmatter -Compress)

"@

    Write-Verbose "[Invoke-PSSkills] Creating agent"
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