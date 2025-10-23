<#
.SYNOPSIS
Retrieves skill metadata (name and description) from SKILL.md files in a skills directory.

.DESCRIPTION
The Get-PSAISkillFrontmatter function scans a directory for SKILL.md files and extracts
their YAML frontmatter metadata. This implements the Anthropic Claude Skills pattern where
skills are discovered via their metadata (Level 1 loading).

Each SKILL.md file should have YAML frontmatter with 'name' and 'description' fields:
---
name: Skill Name
description: What this skill does and when to use it
---

.PARAMETER SkillsRoot
The root directory containing skill subdirectories. Defaults to "./skills".

.PARAMETER AsPSCustomObject
Returns results as PowerShell custom objects instead of JSON.

.PARAMETER Compress
When returning JSON, compress the output to a single line.

.EXAMPLE
PS> Get-PSAISkillFrontmatter
Returns JSON array of all skills found in ./skills directory.

.EXAMPLE
PS> Get-PSAISkillFrontmatter -SkillsRoot "C:\MySkills" -AsPSCustomObject
Returns PowerShell objects for all skills in the specified directory.

.NOTES
This function implements the Anthropic Claude Skills architecture pattern for PowerShell,
enabling progressive disclosure where skill metadata is loaded first, and full skill
content is loaded on-demand using Read-PSAISkill.
#>
function Get-PSAISkillFrontmatter {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$SkillsRoot = "./skills",
        
        [Parameter()]
        [switch]$AsPSCustomObject,
        
        [Parameter()]
        [switch]$Compress
    )

    $skillFiles = Get-ChildItem -Path $SkillsRoot -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue
    $results = @()

    foreach ($file in $skillFiles) {
        $lines = Get-Content $file.FullName
        $start = $lines.IndexOf('---')
        
        if ($start -ge 0) {
            # Find the closing '---' after $start
            $end = -1
            for ($i = $start + 1; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -eq '---') {
                    $end = $i
                    break
                }
            }
            
            if ($end -gt $start) {
                $frontmatter = $lines[$start..$end]
                $name = $null
                $description = $null
                
                foreach ($line in $frontmatter) {
                    if ($line -match '^name:\s*(.+)$') {
                        $name = $matches[1].Trim()
                    }
                    if ($line -match '^description:\s*(.+)$') {
                        $description = $matches[1].Trim()
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
        return $results
    }
    
    return $results | ConvertTo-Json -Depth 3 -Compress:$Compress
}
