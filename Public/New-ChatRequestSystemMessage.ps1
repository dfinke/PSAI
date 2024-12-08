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
        $userRequest,
        $model
    )
    if ($model) {
        $Message = try { 
            $model.NewMessage('system', $userRequest)
        }
        catch {
            Write-Warning "The $($model.Name) Model from the $($model.Provider.Name) Provider does not support system messages. Adding an assistant message instead."
            try {
                $model.NewMessage('assistant', $userRequest)
            }
            catch { 
                Write-Warning "That didn't work either. Adding a model message instead."
                $model.NewMessage('model', $userRequest)
            }
        }
    }
    else {
        $Message = [ordered]@{
            'role'    = 'system'
            'content' = $userRequest
        }
    }
    $message
}
