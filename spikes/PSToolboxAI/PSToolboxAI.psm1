<#
.SYNOPSIS
PSToolboxAI - Sourcegraph Toolbox integration for PSAI

.DESCRIPTION
This module provides integration with Sourcegraph-style toolboxes for PSAI.
Toolboxes are collections of tools that can be discovered and loaded dynamically
for use with AI agents.

.NOTES
This is a spike implementation demonstrating the Sourcegraph Toolbox pattern in PowerShell.
#>

# Import PSAI if not already loaded
if (-not (Get-Module PSAI)) {
    $psaiPath = Join-Path $PSScriptRoot ".." ".." "PSAI.psd1"
    if (Test-Path $psaiPath) {
        Import-Module $psaiPath -Force
    }
}

# Import public functions
. $PSScriptRoot/Public/PSToolboxAI.ps1

# Set module-level variables if needed
$script:ToolboxCache = @{}
