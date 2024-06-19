<#
.SYNOPSIS
Creates a new system message for a chat request.

.DESCRIPTION
The New-ChatRequestSystemMessage function creates a new system message for a chat request. It takes the user request as input and returns a hashtable containing the role and content of the system message.

.PARAMETER userRequest
The user request for the chat.

.EXAMPLE
$userRequest = "Please wait while we connect you to an agent."
New-ChatRequestSystemMessage -userRequest $userRequest

This example creates a new system message with the specified user request.

.OUTPUTS
System.Collections.Hashtable
A hashtable containing the role and content of the system message.

#>

function New-ChatRequestSystemMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $userRequest
    )

    @{
        'role'    = 'system'
        'content' = $userRequest
    }
}
