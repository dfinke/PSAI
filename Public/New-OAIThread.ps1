<#
.SYNOPSIS
Creates a new thread in the OpenAI API.

.DESCRIPTION
The New-OAIThread function sends a POST request to the OpenAI API to create a new thread. It takes in the following parameters:
- messages: An array of messages to be included in the thread.
- tool_resources: (Optional) Additional tool resources to be used in the thread.
- metadata: (Optional) Additional metadata to be associated with the thread.

.PARAMETER messages
Specifies an array of messages to be included in the thread.

.PARAMETER tool_resources
Specifies additional tool resources to be used in the thread. This parameter is optional.

.PARAMETER metadata
Specifies additional metadata to be associated with the thread. This parameter is optional.

.EXAMPLE
$messages = @(
    @{
        role = 'user'
        content = 'You are a helpful AI assistant.'
    },
    @{
        role = 'user'
        content = 'How can I create a new thread?'
    }
)

New-OAIThread -messages $messages

.NOTES
This function requires the Invoke-OAIBeta function to be available in the current session.

.LINK
https://platform.openai.com/docs/api-reference/threads/createThread
#>

function New-OAIThread {
    [CmdletBinding()]
    param(
        [Object[]]$Messages,
        $ToolResources,
        $Metadata
    )

    $url = Get-OAIEndpoint -Url 'threads'
    $Method = 'Post'

    # Azure OpenAI threads are created without anything
    # Tools must be added to the assistant
    $body = $OAIProvider -eq 'OpenAI' ? @{
        messages       = $Messages
        tool_resources = $ToolResources
        metadata       = $Metadata
    } : ''
    Write-Debug "Calling $url from New-OAIThread"
    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}
