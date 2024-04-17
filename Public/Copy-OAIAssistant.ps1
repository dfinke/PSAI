<#
.SYNOPSIS
Copies an OpenAI Assistant to create a new Assistant with optional name change.

.DESCRIPTION
The Copy-OAIAssistant function copies an OpenAI Assistant identified by AssistantId and creates a new Assistant with optional name change.

.PARAMETER AssistantId
Specifies the ID of the OpenAI Assistant to be copied.

.PARAMETER NewName
Specifies the new name for the copied Assistant. If not provided, the copied Assistant will retain the same name as the original Assistant.

.EXAMPLE
Copy-OAIAssistant -AssistantId "assistant-12345" -NewName "MyCopiedAssistant"
Copies the OpenAI Assistant with ID "assistant-12345" and creates a new Assistant with the name "MyCopiedAssistant".

.EXAMPLE
Copy-OAIAssistant -AssistantId "assistant-67890"
Copies the OpenAI Assistant with ID "assistant-67890" and creates a new Assistant with the same name as the original Assistant.

#>
function Copy-OAIAssistant {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("id")]
        $AssistantId,
        $NewName
    )

    Process {
        $srcAssistant = Get-OAIAssistantItem -AssistantId $AssistantId

        $params = ConvertTo-Json -Depth 10 $srcAssistant | ConvertFrom-Json -AsHashtable -Depth 10
                
        # remove these properties
        $params.remove("id")
        $params.remove("object")
        $params.remove("created_at") 

        $params["name"] = $params["name"] + " copy"
        if ($NewName) {
            $params["name"] = $NewName
        } 

        New-OAIAssistant @params
    }
}