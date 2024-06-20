<#
.SYNOPSIS
    Creates a new chat request assistant message.

.DESCRIPTION
    The New-ChatRequestAssistantMessage function creates a new chat request assistant message with the specified user request.

.PARAMETER userRequest
    The user request to be included in the assistant message.

.OUTPUTS
    Hashtable
        Returns a hashtable representing the assistant message with the role set to 'assistant' and the content set to the user request.

.EXAMPLE
    $message = New-ChatRequestAssistantMessage -userRequest "Hello, I need assistance with my account."
    $message
    # Output: @{role='assistant'; content='Hello, I need assistance with my account.'}
#>
function New-ChatRequestAssistantMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $userRequest
    )

    @{
        'role'    = 'assistant'
        'content' = $userRequest
    }
}