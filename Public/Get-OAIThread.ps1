<#
.SYNOPSIS
Retrieves information about a specific thread.

.DESCRIPTION
The Get-OAIThread function retrieves information about a specific thread identified by its thread ID.

.PARAMETER threadId
The ID of the thread to retrieve information for.

.EXAMPLE
Get-OAIThread -threadId 12345
Retrieves information about the thread with ID 12345.

.LINK
https://platform.openai.com/docs/api-reference/threads/getThread
#>

function Get-OAIThread {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $threadId
    )

    $url = $baseUrl + "/threads/$threadId"
    $Method = 'Get'

    Invoke-OAIBeta -Uri $url -Method $Method
}