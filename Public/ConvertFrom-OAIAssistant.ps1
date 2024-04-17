<#
.SYNOPSIS
Converts an AI assistant object to Json.

.DESCRIPTION
The ConvertFrom-OAIAssistant function takes an AI assistant object as input and converts it to Json. It removes certain properties from the object. This allows you to save and resotre the assisant correctly

.PARAMETER Assistant
The AI assistant object to be converted.

.EXAMPLE
$assistant = New-OAIAssistant 
ConvertFrom-OAIAssistant -Assistant $assistant
#>

function ConvertFrom-OAIAssistant {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Assistant
    )

    $assistantProperties = $assistant | ConvertTo-Json -Depth 10 | ConvertFrom-Json -Depth 10 -AsHashtable

    # remove these properties
    $assistantProperties.remove("id")
    $assistantProperties.remove("object")
    $assistantProperties.remove("created_at")

    $assistantProperties | ConvertTo-Json -Depth 10 
}