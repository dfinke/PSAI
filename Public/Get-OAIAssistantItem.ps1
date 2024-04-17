<#
.SYNOPSIS
Retrieves an item from the OpenAI Assistant.

.DESCRIPTION
The Get-OAIAssistantItem function retrieves an item from the OpenAI Assistant based on the specified AssistantId.

.PARAMETER AssistantId
The ID of the OpenAI Assistant.

.INPUTS
None.

.OUTPUTS
System.Object.

.EXAMPLE
Get-OAIAssistantItem -AssistantId "12345678"

This example retrieves an item from the OpenAI Assistant with the ID "12345678".

.LINK
https://platform.openai.com/docs/api-reference/assistants/getAssistant

#>
function Get-OAIAssistantItem {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('assistant_id')]
        $AssistantId
    )

    Process {

        if($null -eq $AssistantId) {
            return
        }

        $url = $baseUrl + "/assistants/$AssistantId"
        $Method = 'Get'

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}
