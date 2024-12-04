<#
.SYNOPSIS
Creates a new user message for a chat request.

.DESCRIPTION
The New-ChatRequestUserMessage function creates a new user message for a chat request. It takes a user request as input and returns a hashtable containing the role and content of the message.

.PARAMETER userRequest
The user request to be included in the message.

.EXAMPLE
$userRequest = "Hello, I need assistance with my account."
New-ChatRequestUserMessage -userRequest $userRequest
# Returns:
# @{
#     'role'    = 'user'
#     'content' = 'Hello, I need assistance with my account.'
# }

.INPUTS
None.

.OUTPUTS
System.Collections.Hashtable

#>
function New-ChatRequestUserMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory )]
        $userRequest,
        [PSCustomObject]
        $Model
    )
    if ($Model){
        return $Model.NewMessage('user', $userRequest)
    }
    @{
        'role'    = 'user'
        'content' = $userRequest
    }
}