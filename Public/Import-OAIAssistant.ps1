<#
.SYNOPSIS
Imports an OAI Assistant from a JSON file.

.DESCRIPTION
The Import-OAIAssistant function imports an OAI Assistant from a JSON file and creates a new OAI Assistant object.

.PARAMETER Path
The path to the JSON file containing the OAI Assistant properties.

.EXAMPLE
Import-OAIAssistant -Path "C:\OAIAssistant.json"

This example imports an OAI Assistant from the "C:\OAIAssistant.json" file.

#>
function Import-OAIAssistant {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "File not found at $Path"
    }

    $assistantProperties = Get-Content $Path -Raw | ConvertFrom-Json -Depth 10 -AsHashtable
    New-OAIAssistant @assistantProperties
}