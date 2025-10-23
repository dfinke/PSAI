<#
.SYNOPSIS
Example using the New-PSAIToolboxAgent convenience function.

.DESCRIPTION
This example demonstrates the simplified approach using New-PSAIToolboxAgent
which combines tool discovery and agent creation in one step.

.EXAMPLE
.\02-ConvenienceFunction.ps1
#>

# Import PSAI module
$psaiPath = Join-Path $PSScriptRoot ".." ".." ".." "PSAI.psd1"
Import-Module $psaiPath -Force

# Import PSToolboxAI module
$toolboxPath = Join-Path $PSScriptRoot ".." "PSToolboxAI.psd1"
Import-Module $toolboxPath -Force

Write-Host "=== PSToolboxAI Convenience Function Example ===" -ForegroundColor Cyan
Write-Host ""

# Create an agent with auto-discovered toolbox tools in one step
Write-Host "Creating agent with auto-discovered tools..." -ForegroundColor Yellow
$agent = New-PSAIToolboxAgent `
    -Instructions "You are a helpful assistant." `
    -Name "QuickBot" `
    -ShowToolCalls

Write-Host "Agent created successfully!" -ForegroundColor Green
Write-Host ""

# Use the agent
Write-Host "Testing the agent..." -ForegroundColor Yellow
$response = $agent | Get-AgentResponse "What is today's date and the count of files in the current directory?"
Write-Host "Response:" -ForegroundColor Green
Write-Host $response
