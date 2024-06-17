<#
.SYNOPSIS
Retrieves messages from a specific thread in the OAIBeta API.

.DESCRIPTION
The Get-OAIMessage function retrieves messages from a specific thread in the OAIBeta API. It allows you to specify various parameters such as thread ID, limit, order, after, and before to filter the messages.

.PARAMETER ThreadId
The ID of the thread from which to retrieve messages.

.PARAMETER Limit
The maximum number of messages to retrieve. The default value is 20.

.PARAMETER Order
The order in which the messages should be retrieved. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER After
Retrieve messages after the specified date/time.

.PARAMETER Before
Retrieve messages before the specified date/time.

.EXAMPLE
Get-OAIMessage -ThreadId 12345 -Limit 10 -Order 'asc' -After $Message1.id -Before $Message5.id
Retrieves the 10 oldest messages from the thread with ID 12345, in ascending order, between messages 1 and 5.
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
        $Before
    )

    Process {

        if($null -eq $ThreadId) {
            return
        }

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

        $url = Get-OAIEndpoint -Url "threads/$ThreadId/messages" -Parameters $urlParams
        Invoke-OAIBeta -Uri $url -Method $Method
    }
}