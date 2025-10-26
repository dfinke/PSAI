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

function Invoke-PSSkills {
    [CmdletBinding()]
    param(
        [string]$Prompt,
        [string[]]$Tools,
        [string]$Model = "gpt-4.1",
        [switch]$ShowToolCalls
    )

    Write-Verbose "[Invoke-PSSkills] Called with Prompt: $Prompt, Model: $Model, Tools: $Tools, ShowToolCalls: $ShowToolCalls"
    $targetTools = @(
        'Read-PSSkill'
        'Invoke-Expression'
    )

    if ($tools.count -gt 0) {
        Write-Verbose "[Invoke-PSSkills] Adding user-specified tools: $Tools"
        $targetTools += $tools
    }

    Write-Verbose "[Invoke-PSSkills] Building instructions for agent"
    $instructions = @"
You are a PowerShell Skills AI Assistant. 

When a user provides a request, analyze the request to determine which skills are relevant.
If you 

**ONLY USE** Read-PSSKill to read the SKILL.md file. 
**DO NOT USE** Read-PSSKill to read any other type of file. 

Use and code blocks in the SKILL.md file as examples to form your response. 

Use Invoke-Expression to run PowerShell code found in the SKILL.md file.

Do one task at a time, then move on to the next, reading the SKILL.md files as needed.

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
        $agent | Start-Conversation
    }
}