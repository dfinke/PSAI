<#
.SYNOPSIS
Removes a thread from the OpenAI API.

.DESCRIPTION
The Remove-OAIThread function removes a thread from the OpenAI API by sending a DELETE request to the specified thread ID.

.PARAMETER threadId
The ID of the thread to be removed.

.EXAMPLE
Remove-OAIThread -threadId "123456789"

This example removes the thread with the ID "123456789" from the OpenAI API.

.LINK
https://platform.openai.com/docs/api-reference/threads/deleteThread
#>

function Remove-OAIThread {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $threadId
    )

    Process {
        $url = "threads/$threadId"
        $Method = 'Delete'

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}
