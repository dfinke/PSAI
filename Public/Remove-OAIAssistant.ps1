<#
.SYNOPSIS
Removes an OAI Assistant.

.DESCRIPTION
The Remove-OAIAssistant function is used to remove an OAI Assistant by its ID.

.PARAMETER Id
The ID of the OAI Assistant to be removed.

.EXAMPLE
Remove-OAIAssistant -Id "assistant123"
Removes the OAI Assistant with the ID "assistant123".

.LINK 
https://platform.openai.com/docs/api-reference/assistants/deleteAssistant

#>
function Remove-OAIAssistant {
    [CmdletBinding()]
    param(
        [Parameter(ValuefromPipelinebyPropertyName)]
        $Id
    )
  
    # Needs a confirmation and whatif etc
    Process {
        $url = "assistants/$Id"
        $Method = 'Delete'
        Invoke-OAIBeta -Uri $url -Method $Method |Select-Object -ExpandProperty ResponseObject
    }
}