<#
.SYNOPSIS
    Retrieves the runs associated with a specific thread ID.

.DESCRIPTION
    The Get-OAIRun function retrieves the runs associated with a specific thread ID from a specified base URL. It allows you to specify various parameters such as the number of runs to retrieve, the order in which they should be sorted, and the time range for the runs.

.PARAMETER threadId
    Specifies the ID of the thread for which to retrieve the runs. This parameter is mandatory.

.PARAMETER limit
    Specifies the maximum number of runs to retrieve. The default value is 20.

.PARAMETER order
    Specifies the order in which the runs should be sorted. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER after
    Specifies the timestamp after which the runs should be retrieved.

.PARAMETER before
    Specifies the timestamp before which the runs should be retrieved.

.EXAMPLE
    Get-OAIRun -threadId 12345 -limit 10 -order 'asc' -after '2022-01-01T00:00:00Z'
    Retrieves the 10 oldest runs associated with thread ID 12345, sorted in ascending order, and after the specified timestamp.

.LINK
    https://platform.openai.com/docs/api-reference/runs/listRuns
#>
function Get-OAIRun {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]
        $threadId,
        $limit = 20,
        [ValidateSet('asc', 'desc')]
        $order = 'desc',
        $after,
        $before        
    )

    Process {
        $url = $baseUrl + "/threads/$threadId/runs"
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

        $urlParams = "?" + ($urlParams -join '&')
        Invoke-OAIBeta -Uri ($url + $urlParams) -Method $Method
    }
}