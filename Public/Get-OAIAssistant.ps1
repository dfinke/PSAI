<#
.SYNOPSIS
Retrieves OpenAI assistants based on specified criteria.

.DESCRIPTION
The Get-OAIAssistant function retrieves OpenAI assistants based on the specified criteria such as name, limit, order, after, before, and raw output.

.PARAMETER Name
Specifies the name of the OpenAI assistant to retrieve. If not specified, all assistants will be returned.

.PARAMETER Limit
Specifies the maximum number of assistants to retrieve.

.PARAMETER Order
Specifies the order in which the assistants should be sorted. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER After
Specifies the cursor for pagination. Only assistants created after this cursor will be returned.

.PARAMETER Before
Specifies the cursor for pagination. Only assistants created before this cursor will be returned.

.PARAMETER Raw
Switch parameter. If specified, the raw response from the API will be returned.

.OUTPUTS
The function returns a collection of OpenAI assistants based on the specified criteria.

.EXAMPLE
Get-OAIAssistant -Name "MyAssistant" -Limit 10 -Order 'asc'
Retrieves the first 10 OpenAI assistants with the name "MyAssistant" in ascending order.

.EXAMPLE
Get-OAIAssistant -Limit 5 -After "cursor123"
Retrieves the next 5 OpenAI assistants created after the cursor "cursor123".

.LINK
https://platform.openai.com/docs/api-reference/assistants/listAssistants

#>
function Get-OAIAssistant {
    [CmdletBinding()]
    param(
        $Name,
        $Limit,
        [ValidateSet('asc', 'desc')]
        $Order,
        $After,
        $Before,        
        [Switch]$Raw
    )

    $url = $baseUrl + "/assistants"
    $Method = 'Get'

    $urlParams = @()
    if ($limit) {
        $urlParams += "limit=$limit"
    }
    if ($order) {
        $urlParams += "order=$order"
    }
    if ($after) {
        $urlParams += "after=$after"
    }
    if ($before) {
        $urlParams += "before=$before"
    }

    if ($urlParams.Count -gt 0) {
        $urlParams = "?" + ($urlParams -join '&')
        $url = $url + $urlParams
    }

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
