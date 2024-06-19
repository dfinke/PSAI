<#
.SYNOPSIS
    Retrieves the run steps for a specific thread and run ID.

.DESCRIPTION
    The Get-OAIRunStep function retrieves the run steps for a specific thread and run ID. It allows you to specify optional parameters such as the number of steps to retrieve, the order in which the steps should be sorted, and filters based on timestamps.

.PARAMETER threadId
    The ID of the thread for which to retrieve the run steps. This parameter is mandatory.

.PARAMETER runId
    The ID of the run for which to retrieve the steps. This parameter is mandatory.

.PARAMETER limit
    The maximum number of steps to retrieve. The default value is 20.

.PARAMETER order
    The order in which the steps should be sorted. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER after
    Retrieve steps that occurred after which is an object ID that defines your place in the list.

.PARAMETER before
    Retrieve steps that occurred before which is an object ID that defines your place in the list.

.EXAMPLE
    Get-OAIRunStep -threadId 123 -runId 456
    Retrieves the run steps for thread ID 123 and run ID 456.

.EXAMPLE
    Get-OAIRunStep -threadId 123 -runId 456 -limit 50 -order 'asc' -after '2022-01-01T00:00:00Z'
    Retrieves the first 50 run steps in ascending order that occurred after January 1, 2022.

.LINK
https://platform.openai.com/docs/api-reference/runs/listRunSteps
#>

function Get-OAIRunStep {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $ThreadId,
        [Parameter(Mandatory)]
        $RunId,
        $Limit,
        [ValidateSet('asc', 'desc')]
        $Order = 'desc',
        $After,
        $Before
    )

    $url = $baseUrl + "/threads/$ThreadId/runs/$RunId/steps"
    $Method = 'Get'

    $urlParams = @()
    if ($Limit) {
        $urlParams += "limit=$Limit"
    }
    if ($Order) {
        $urlParams += "order=$Order"
    }
    if ($After) {
        $urlParams += "after=$After"
    }
    if ($Before) {
        $urlParams += "before=$Before"
    }

    $urlParams = "?" + ($urlParams -join '&')
    Invoke-OAIBeta -Uri ($url + $urlParams) -Method $Method
}
