<#
.SYNOPSIS
Retrieves an item from an OpenAPI thread.

.DESCRIPTION
The Get-OAIThreadItem function retrieves an item from an OpenAPI thread based on the specified thread ID.

.PARAMETER ThreadId
The ID of the thread from which to retrieve the item.

.EXAMPLE
Get-OAIThreadItem -ThreadId 12345
Retrieves the item from the OpenAPI thread with the ID 12345.

.LINK
https://platform.openai.com/docs/api-reference/threads/getThread
#>
function Get-OAIThreadItem {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]
        $ThreadId
    )

    Process {
        $url = $baseUrl + "/threads/$ThreadId"
        $Method = 'Get'

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}