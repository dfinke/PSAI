<#
.SYNOPSIS
Converts the Assistant configuration to an OAIAssistant object.

.DESCRIPTION
The ConvertTo-OAIAssistant function takes an Assistant configuration as input and converts it to an OAIAssistant object. The Assistant configuration can be provided as a JSON file path or as a JSON string.

.PARAMETER AssistantConfig
The Assistant configuration. It can be provided as a file path to a JSON file or as a JSON string.

.EXAMPLE
ConvertTo-OAIAssistant -AssistantConfig "C:\AssistantConfig.json"

This example converts the Assistant configuration stored in the "C:\AssistantConfig.json" file to an OAIAssistant object.

.EXAMPLE
ConvertTo-OAIAssistant -AssistantConfig '{"name": "MyAssistant"}'

This example converts the Assistant configuration provided as a JSON string to an OAIAssistant object.

#>
function ConvertTo-OAIAssistant {
    [CmdletBinding()]
    param(
        $AssistantConfig
    )

    if (Test-JsonReplacement -Json $AssistantConfig) {
        $assistantParams = $AssistantConfig | ConvertFrom-Json -Depth 10 -AsHashtable        
    }
    else {
        if (Test-Path $AssistantConfig) {
            $assistantParams = Get-Content -Raw $AssistantConfig | ConvertFrom-Json -Depth 10 -AsHashtable        
        }
        else {
            Write-Error "$AssistantConfig not found"
            return
        }
    }
    
    New-OAIAssistant @assistantParams
}