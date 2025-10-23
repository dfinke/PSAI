<#
.SYNOPSIS
Reads the complete content of a skill file.

.DESCRIPTION
The Read-PSAISkill function reads the entire content of a SKILL.md file (or any file)
and returns it as a single string. This implements Level 2 loading in the Anthropic 
Claude Skills pattern, where the full skill instructions are loaded on-demand when
the AI agent determines a skill is needed.

This function is designed to be called by an AI agent when it needs detailed instructions
from a skill file. The file path is typically obtained from Get-PSAISkillFrontmatter.

.PARAMETER Fullname
The full path to the skill file to read. This is typically a SKILL.md file path from
the Get-PSAISkillFrontmatter output.

.EXAMPLE
PS> Read-PSAISkill -Fullname "C:\skills\pdf-processing\SKILL.md"
Returns the complete content of the PDF processing skill file.

.EXAMPLE
PS> $skills = Get-PSAISkillFrontmatter -AsPSCustomObject
PS> $pdfSkill = $skills | Where-Object { $_.name -eq "PDF Processing" }
PS> Read-PSAISkill -Fullname $pdfSkill.fullname
Discovers and reads a specific skill file.

.NOTES
This function implements the Anthropic Claude Skills architecture pattern for PowerShell.
It should only be used to read skill files (SKILL.md) or related resources, not arbitrary
files. The AI agent's instructions should enforce this constraint.
#>
function Read-PSAISkill {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Fullname
    )

    if (-not (Test-Path -Path $Fullname)) {
        Write-Error "File not found: $Fullname"
        return
    }

    Get-Content -Path $Fullname -Raw
}
