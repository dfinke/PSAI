<#
.SYNOPSIS
Creates a new message for a specified thread in the OpenAI API.

.DESCRIPTION
The New-OAIMessage function creates a new message for a specified thread in the OpenAI API. It allows you to specify the thread ID, role, content, attachments, and metadata for the message.

.PARAMETER ThreadId
The ID of the thread to which the message belongs.

.PARAMETER Role
The role of the message. Valid values are 'user' and 'assistant'.

.PARAMETER Content
The content of the message.

.PARAMETER Attachments
Optional. Any attachments to include with the message.

.PARAMETER Metadata
Optional. Any metadata to include with the message.

.EXAMPLE
New-OAIMessage -ThreadId "12345" -Role "user" -Content "Hello, how can I help you?"

This example creates a new user message with the content "Hello, how can I help you?" for the thread with ID "12345".

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
        [ValidateSet('user', 'assistant')]
        $Role,
        [Parameter(Mandatory)]
        $Content,
        $Attachments,
        $Metadata
    )

    Process {
        $url = Get-OAIEndpoint -Url "threads/$ThreadId/messages"

        $Method = 'Post'

        $body = @{
            role    = $Role
            content = $Content
        }

        if ($Attachments) {
            $body.attachments = $Attachments
        }

        if ($Metadata) {
            $body.metadata = $Metadata
        }

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body
    }
}
