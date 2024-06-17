<#
.SYNOPSIS
Creates a new message in a specified thread.

.DESCRIPTION
The New-OAIMessage function is used to create a new message in a specified thread. It requires the thread ID, role, content, and optional file IDs as parameters.

.PARAMETER threadId
The ID of the thread where the message will be created.

.PARAMETER Role
The role of the message sender. Only 'user' is currently supported.

.PARAMETER Content
The content of the message.

.PARAMETER FileIds
An optional array of file IDs to attach to the message.

.PARAMETER Metadata
Optional metadata to include with the message.

.EXAMPLE
New-OAIMessage -ThreadId 12345 -Role 'user' -Content 'Hello, world!' -FileIds 'file1', 'file2'

This example creates a new message in the thread with ID 12345, sent by a user with the content "Hello, world!" and attaches two files with IDs 'file1' and 'file2'.

.LINK
https://platform.openai.com/docs/api-reference/messages/createMessage
#>
function New-OAIMessage {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        $ThreadId,
        [Parameter(Mandatory)]
        [ValidateSet('user')]
        $Role,
        [Parameter(Mandatory)]
        $Content,
        $FileIds,
        $Metadata        
    )

    Process {
        $url = Get-OAIEndpoint -Url "threads/$ThreadId/messages"

        $Method = 'Post'

        $body = @{
            role    = $Role
            content = $Content
        }
    
        if ($FileIds) {
            $body['file_ids'] = @($FileIds)
        }

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body
    }
}
