<#
.SYNOPSIS
Retrieves messages for a specific thread ID.

.DESCRIPTION
The Get-OAIMessage function retrieves messages for a specific thread ID. It allows you to specify various parameters such as the number of messages to retrieve, the order in which they should be sorted, and filters based on timestamps and run IDs.

.PARAMETER ThreadId
The ID of the thread for which messages should be retrieved.

.PARAMETER Limit
The maximum number of messages to retrieve. The default value is 20.

.PARAMETER Order
The order in which the messages should be sorted. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER After
Retrieve messages after the specified timestamp.

.PARAMETER Before
Retrieve messages before the specified timestamp.

.PARAMETER RunId
Retrieve messages for a specific run ID.

.EXAMPLE
Get-OAIMessage -ThreadId 12345 -Limit 10 -Order 'asc' -After '2022-01-01' -RunId 'abc123'
Retrieves the 10 oldest messages for the thread with ID 12345, sorted in ascending order, after the specified timestamp, and for the specified run ID.

.LINK
https://beta.openai.com/docs/api-reference/messages/list
#>

function Get-OAIMessage {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]
        [Alias('id')]
        $ThreadId,
        $Limit = 20,
        [ValidateSet('asc', 'desc')]
        $Order = 'desc',
        $After,
        $Before,
        $RunId
    )

    Process {

        if ($null -eq $ThreadId) {
            return
        }

        $Method = 'Get'
        $url = $baseUrl + "/threads/$ThreadId/messages"

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
        if ($runId) {
            $urlParams += "run_id=$runId"
        }

        $urlParams = "?" + ($urlParams -join '&')

        Invoke-OAIBeta -Uri ($url + $urlParams) -Method $Method
    }
}