<#
.SYNOPSIS
Exports an OpenAI Assistant to a JSON file.

.DESCRIPTION
The Export-OAIAssistant function exports an OpenAI Assistant to a JSON file. It retrieves the assistant using the specified AssistantId and saves its properties to a JSON file at the specified Path.

.PARAMETER AssistantId
The ID of the OpenAI Assistant to export.

.PARAMETER Path
The path where the exported JSON file will be saved.

.EXAMPLE
Export-OAIAssistant -AssistantId "assistant-12345" -Path "C:\Exports\assistant-12345.json"
Exports the OpenAI Assistant with ID "assistant-12345" to a JSON file located at "C:\Exports\assistant-12345.json".

#>
function Export-OAIAssistant {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("id")]
        $AssistantId,
        $Path
    )

    Process {
        $assistant = Get-OAIAssistantItem -AssistantId $AssistantId

        $Path = $assistant.id + '-' + $assistant.name + ".json"
        Write-Host "Exporting to $Path"
        $assistantProperties = $assistant | ConvertTo-Json -Depth 10 | ConvertFrom-Json -Depth 10 -AsHashtable

        # remove these properties
        $assistantProperties.remove("id")
        $assistantProperties.remove("object")
        $assistantProperties.remove("created_at")
        
        $assistantProperties | ConvertTo-Json -Depth 10 | Out-File $Path
    }
}