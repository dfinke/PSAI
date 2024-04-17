<#
.SYNOPSIS
Submits an OpenAI message and run.

.DESCRIPTION
The Submit-OAIMessage function is used to submit an OpenAI message and run. It creates a new message using the New-OAIMessage cmdlet and a new run using the New-OAIRun cmdlet. The function takes three parameters: $Assistant, $Thread, and $UserInput.

.PARAMETER Assistant
The assistant object representing the OpenAI assistant.

.PARAMETER Thread
The thread object representing the conversation thread.

.PARAMETER UserInput
The user input to be submitted as a message.

.EXAMPLE
Submit-OAIMessage -Assistant $assistant -Thread $thread -UserInput "Hello, how can I help you?"

This example submits a user message to the OpenAI assistant and creates a new run.

.INPUTS
None.

.OUTPUTS
System.Object[]
The function returns an array containing the run and message objects.

#>
function Submit-OAIMessage {
    [CmdletBinding()]
    param(
        $Assistant,
        $Thread,
        $UserInput
    )

    $message = New-OAIMessage -ThreadId $Thread.id -Role user -Content $UserInput
   
    $run = New-OAIRun -ThreadId $Thread.Id -AssistantId $Assistant.Id

    [PSCustomObject]@{
        Run     = $run
        Message = $message
    }
}
