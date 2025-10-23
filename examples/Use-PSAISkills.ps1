<#
.SYNOPSIS
Example script demonstrating how to use PSAI Skills with an AI agent.

.DESCRIPTION
This script shows how to create an AI agent that can discover and use PSAI Skills
to answer questions about PowerShell. It implements the Anthropic Claude Skills
pattern for progressive disclosure.

.PARAMETER Prompt
The initial prompt to send to the agent. If not provided, starts an interactive session.

.PARAMETER SkillsRoot
The root directory containing skills. Defaults to "../skills" relative to this script.

.PARAMETER ShowToolCalls
Display tool calls made by the agent for debugging.

.EXAMPLE
PS> .\Use-PSAISkills.ps1 -Prompt "How do I read a file in PowerShell?"

.EXAMPLE
PS> .\Use-PSAISkills.ps1
Starts an interactive conversation with the skills agent.
#>
param(
    [string]$Prompt,
    [string]$SkillsRoot = (Join-Path $PSScriptRoot "../skills"),
    [switch]$ShowToolCalls
)

# Ensure PSAI is loaded
Import-Module PSAI -ErrorAction Stop

# Build instructions for the agent
$instructions = @"
You are a PowerShell Skills AI Assistant. 

When a user provides a request, analyze the request to determine which skills are relevant.

**ONLY USE** Read-PSAISkill to read the SKILL.md file. 
**DO NOT USE** Read-PSAISkill to read any other type of file. 

Use code blocks in the SKILL.md file as examples to form your response. 

Use Invoke-Expression to run PowerShell code found in the SKILL.md file when appropriate.

Do one task at a time, then move on to the next, reading the SKILL.md files as needed.

You have access to the skills:
**Skills**

$(Get-PSAISkillFrontmatter -SkillsRoot $SkillsRoot -Compress)

"@

# Define tools available to the agent
$tools = @(
    'Invoke-Expression'
    'Read-PSAISkill'
)

# Create the agent
$agent = New-Agent `
    -LLM (New-OpenAIChat) `
    -Name 'PSSkillsAgent' `
    -ShowToolCalls:$ShowToolCalls `
    -Tools $tools `
    -Instructions $instructions

# Use the agent
if ($Prompt) {
    $agent | Get-AgentResponse $Prompt
}
else {
    Write-Host "Starting interactive conversation with PSAI Skills Agent..." -ForegroundColor Cyan
    Write-Host "Available commands:" -ForegroundColor Yellow
    Write-Host "  /clear - Clear the screen" -ForegroundColor Yellow
    Write-Host "  Enter  - Copy last response and quit" -ForegroundColor Yellow
    Write-Host ""
    
    $agent | Start-Conversation
}
