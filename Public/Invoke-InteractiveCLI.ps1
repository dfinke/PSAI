<#
.SYNOPSIS
Invokes an interactive command-line interface (CLI) for a given PSAIAgent.

.DESCRIPTION
The Invoke-InteractiveCLI function initiates an interactive CLI session for a specified PSAIAgent object. 
It allows the user to send a message, specify a user, and optionally include an emoji and an exit condition.

.PARAMETER Agent
The PSAIAgent object that will be used to invoke the interactive CLI. This parameter accepts input from the pipeline.

.PARAMETER Message
The message to be displayed in the interactive CLI.

.PARAMETER User
The user associated with the interactive CLI session.

.PARAMETER Emoji
An optional emoji to be displayed in the interactive CLI. The default value is '😎'.

.PARAMETER ExitOn
An optional parameter that specifies the condition on which the interactive CLI should exit.

.EXAMPLE
PS C:\> $agent = Get-PSAIAgent
PS C:\> Invoke-InteractiveCLI -Agent $agent -Message "Hello, World!" -User "Admin"

This example invokes the interactive CLI for the specified PSAIAgent with the message "Hello, World!" and user "Admin".

.NOTES
The function checks if the provided Agent is a valid PSAIAgent object before invoking the interactive CLI.
If the Agent is not valid, an error is written and the function returns without further execution.
#>
function Invoke-InteractiveCLI {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $Agent,
        $Message,
        $User,
        $Emoji = '😎',
        $ExitOn
    )

    Process {
        if (!($agent.psobject.TypeNames -contains 'PSAIAgent')) {
            Write-Error "Agent is not a valid PSAIAgent"
            return
        }

        $agent.InteractiveCLI($Message, $User, $Emoji, $ExitOn)
    }
}