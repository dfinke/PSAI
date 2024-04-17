<#
.SYNOPSIS
Tests whether an OpenAI Assistant ID exists.

.DESCRIPTION
The Test-OAIAssistantId function checks whether an OpenAI Assistant ID exists by querying the Get-OAIAssistantItem cmdlet.

.PARAMETER AssistantId
The Assistant ID to be tested.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Boolean
Returns $true if the Assistant ID exists, otherwise returns $false.

.EXAMPLE
Test-OAIAssistantId -AssistantId "12345678"
Checks whether the Assistant ID "12345678" exists.

#>
function Test-OAIAssistantId {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("id")]
        $AssistantId
    )

    Process {

        $result = Get-OAIAssistantItem -AssistantId $AssistantId -ErrorAction SilentlyContinue
        if ($null -eq $result) {
            return $false                
        }

        return $true
    }
}