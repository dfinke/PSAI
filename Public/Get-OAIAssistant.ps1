<#
.SYNOPSIS
    Retrieves OpenAI assistants.

.DESCRIPTION
    The Get-OAIAssistant function retrieves OpenAI assistants based on the specified criteria.

.PARAMETER Name
    Specifies the name of the assistant to retrieve. If not provided, all assistants will be returned.

.PARAMETER Raw
    Indicates whether to return the raw response or the selected properties of the assistants.

.EXAMPLE
    Get-OAIAssistant -Name "Weather Assistant"
    Retrieves the assistant with the name "Weather Assistant".

.EXAMPLE
    Get-OAIAssistant -Raw
    Retrieves the raw response of all assistants.

.NOTES
    This function requires PowerShell version 7.4.0 or later. The Invoke-RestMethod switch -AllowInsecureRedirect is not available in earlier versions.

.LINK
https://platform.openai.com/docs/api-reference/assistants/listAssistants
#>
function Get-OAIAssistant {
    [CmdletBinding()]
    param(
        $Name,
        [Switch]$Raw
    )

    $url = $baseUrl + "/assistants"
    $Method = 'Get'

    $response = Invoke-OAIBeta -Uri $url -Method $Method
    
    if ($Raw) {
        return $response
    }
    else {

        if (!$Name) {
            $Name = '*'
        }

        $properties = @('Id', 'Name', 'Instructions', 'Model', 'Tools')
        $response.data | Where-Object { $_.name -like $Name } | Select-Object $properties
    }
}
