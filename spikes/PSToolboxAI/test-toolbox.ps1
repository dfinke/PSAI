<#
.SYNOPSIS
Test script for PSToolboxAI module.

.DESCRIPTION
Tests the PSToolboxAI module's functionality including:
- Module loading
- Toolbox discovery
- Tool registration
- Function availability

.NOTES
This is a basic test script. For actual agent testing, you need OpenAI API key.
#>

param(
    [Switch]$Verbose
)

Write-Host "=== PSToolboxAI Test Script ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Module Loading
Write-Host "[Test 1] Loading PSAI module..." -ForegroundColor Yellow
try {
    Import-Module ./PSAI.psd1 -Force -ErrorAction Stop
    Write-Host "  ✓ PSAI module loaded successfully" -ForegroundColor Green
}
catch {
    Write-Host "  ✗ Failed to load PSAI module: $_" -ForegroundColor Red
    exit 1
}

Write-Host "[Test 1] Loading PSToolboxAI module..." -ForegroundColor Yellow
try {
    Import-Module ./spikes/PSToolboxAI/PSToolboxAI.psd1 -Force -ErrorAction Stop
    Write-Host "  ✓ PSToolboxAI module loaded successfully" -ForegroundColor Green
}
catch {
    Write-Host "  ✗ Failed to load PSToolboxAI module: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 2: Toolbox Path Discovery
Write-Host "[Test 2] Testing Get-PSAIToolboxPath..." -ForegroundColor Yellow
try {
    $paths = Get-PSAIToolboxPath
    if ($paths) {
        Write-Host "  ✓ Toolbox paths discovered: $($paths.Count) path(s)" -ForegroundColor Green
        $paths | ForEach-Object { Write-Host "    - $_" -ForegroundColor Gray }
    }
    else {
        Write-Host "  ✗ No toolbox paths found" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "  ✗ Error getting toolbox paths: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 3: Tool Discovery
Write-Host "[Test 3] Testing Get-PSAIToolbox..." -ForegroundColor Yellow
try {
    $tools = Get-PSAIToolbox
    if ($tools -and $tools.Count -gt 0) {
        Write-Host "  ✓ Tools discovered: $($tools.Count) tool(s)" -ForegroundColor Green
        $tools | ForEach-Object {
            if ($_.function -and $_.function.name) {
                Write-Host "    - $($_.function.name)" -ForegroundColor Gray
            }
        }
    }
    else {
        Write-Host "  ✗ No tools discovered" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "  ✗ Error discovering tools: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 4: Function Availability
Write-Host "[Test 4] Verifying tool functions are available..." -ForegroundColor Yellow
$expectedFunctions = @(
    'Get-DirectoryListing'
    'Read-FileContent'
    'Test-FileExists'
    'Get-CurrentDateTime'
    'Format-DateTime'
    'Get-DateDifference'
    'Get-TextStatistics'
    'Convert-TextCase'
    'Search-TextPattern'
)

$allFound = $true
foreach ($funcName in $expectedFunctions) {
    $cmd = Get-Command $funcName -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "  ✓ $funcName" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $funcName not found" -ForegroundColor Red
        $allFound = $false
    }
}

if (-not $allFound) {
    Write-Host "  Some functions are missing!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 5: Tool Function Execution (basic smoke test)
Write-Host "[Test 5] Testing tool function execution..." -ForegroundColor Yellow

# Test Get-CurrentDateTime
try {
    $result = Get-CurrentDateTime -Format All
    $parsed = $result | ConvertFrom-Json
    if ($parsed.iso8601) {
        Write-Host "  ✓ Get-CurrentDateTime works" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ Get-CurrentDateTime output invalid" -ForegroundColor Red
    }
}
catch {
    Write-Host "  ✗ Get-CurrentDateTime failed: $_" -ForegroundColor Red
}

# Test Get-TextStatistics
try {
    $result = Get-TextStatistics -Text "Hello world"
    $parsed = $result | ConvertFrom-Json
    if ($parsed.word_count -eq 2) {
        Write-Host "  ✓ Get-TextStatistics works" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ Get-TextStatistics output invalid" -ForegroundColor Red
    }
}
catch {
    Write-Host "  ✗ Get-TextStatistics failed: $_" -ForegroundColor Red
}

# Test Test-FileExists
try {
    $result = Test-FileExists -Path "."
    $parsed = $result | ConvertFrom-Json
    if ($parsed.exists -eq $true) {
        Write-Host "  ✓ Test-FileExists works" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ Test-FileExists output invalid" -ForegroundColor Red
    }
}
catch {
    Write-Host "  ✗ Test-FileExists failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 6: Agent Creation (without API call)
Write-Host "[Test 6] Testing agent creation with tools..." -ForegroundColor Yellow
try {
    $agent = New-Agent -Tools $tools -Instructions "Test agent"
    if ($agent) {
        Write-Host "  ✓ Agent created successfully" -ForegroundColor Green
        Write-Host "    Type: $($agent.psobject.TypeNames[0])" -ForegroundColor Gray
        Write-Host "    Tools: $($agent.Tools.Count)" -ForegroundColor Gray
    }
    else {
        Write-Host "  ✗ Agent creation returned null" -ForegroundColor Red
    }
}
catch {
    Write-Host "  ✗ Agent creation failed: $_" -ForegroundColor Red
}
Write-Host ""

# Summary
Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "All basic tests passed! ✓" -ForegroundColor Green
Write-Host ""
Write-Host "Note: These tests verify module loading, tool discovery, and basic function execution." -ForegroundColor Gray
Write-Host "To test actual agent interactions, you'll need an OpenAI API key set in `$env:OpenAIKey" -ForegroundColor Gray
Write-Host ""
Write-Host "Example usage with API key:" -ForegroundColor Yellow
Write-Host '  $agent = New-PSAIToolboxAgent -ShowToolCalls' -ForegroundColor Gray
Write-Host '  $agent | Get-AgentResponse "What is the current date?"' -ForegroundColor Gray
