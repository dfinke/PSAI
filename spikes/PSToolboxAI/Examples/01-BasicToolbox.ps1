<#
.SYNOPSIS
Basic example of using PSToolboxAI with PSAI agents.

.DESCRIPTION
This example demonstrates how to:
1. Load the PSToolboxAI module
2. Discover toolbox tools
3. Create an agent with those tools
4. Use the agent to perform tasks

.EXAMPLE
.\01-BasicToolbox.ps1

.EXAMPLE
.\01-BasicToolbox.ps1 -Interactive
Runs in interactive mode.
#>

param(
    [Switch]$Interactive,
    [Switch]$ShowToolCalls
)

# Import PSAI module
$psaiPath = Join-Path $PSScriptRoot ".." ".." ".." "PSAI.psd1"
Import-Module $psaiPath -Force

# Import PSToolboxAI module
$toolboxPath = Join-Path $PSScriptRoot ".." "PSToolboxAI.psd1"
Import-Module $toolboxPath -Force

Write-Host "=== PSToolboxAI Example ===" -ForegroundColor Cyan
Write-Host ""

# Discover available toolbox tools
Write-Host "Discovering toolbox tools..." -ForegroundColor Yellow
$tools = Get-PSAIToolbox -Verbose
Write-Host "Found $($tools.Count) tools" -ForegroundColor Green
Write-Host ""

# Create an agent with the toolbox tools
$agent = New-Agent `
    -Tools $tools `
    -Instructions "You are a helpful assistant with access to file system, date/time, and text processing tools." `
    -Name "ToolboxAgent" `
    -Description "An agent with toolbox capabilities" `
    -ShowToolCalls:$ShowToolCalls

if ($Interactive) {
    Write-Host "Starting interactive session..." -ForegroundColor Cyan
    Write-Host "Try commands like:" -ForegroundColor Yellow
    Write-Host "  - What files are in the current directory?" -ForegroundColor Gray
    Write-Host "  - What is the current date and time?" -ForegroundColor Gray
    Write-Host "  - Count the words in 'Hello world from PowerShell'" -ForegroundColor Gray
    Write-Host "  - Press Enter (empty) to copy last response and exit" -ForegroundColor Gray
    Write-Host ""
    
    $agent | Invoke-InteractiveCLI
}
else {
    Write-Host "Running example queries..." -ForegroundColor Cyan
    Write-Host ""
    
    # Example 1: File system operations
    Write-Host "Example 1: File System Operations" -ForegroundColor Yellow
    Write-Host "Query: What files are in the current directory?" -ForegroundColor Gray
    $response = $agent | Get-AgentResponse "List the files in the current directory"
    Write-Host "Response:" -ForegroundColor Green
    Write-Host $response
    Write-Host ""
    
    # Example 2: Date/time operations
    Write-Host "Example 2: Date/Time Operations" -ForegroundColor Yellow
    Write-Host "Query: What is the current date and time?" -ForegroundColor Gray
    $response = $agent | Get-AgentResponse "What is the current date and time in ISO8601 format?"
    Write-Host "Response:" -ForegroundColor Green
    Write-Host $response
    Write-Host ""
    
    # Example 3: Text operations
    Write-Host "Example 3: Text Operations" -ForegroundColor Yellow
    Write-Host "Query: Analyze text statistics" -ForegroundColor Gray
    $response = $agent | Get-AgentResponse "Count the words in this text: 'The quick brown fox jumps over the lazy dog.'"
    Write-Host "Response:" -ForegroundColor Green
    Write-Host $response
    Write-Host ""
    
    Write-Host "Examples completed!" -ForegroundColor Cyan
    Write-Host "Run with -Interactive flag for interactive mode." -ForegroundColor Gray
}
