<#
.SYNOPSIS
Creates a new thread query.

.DESCRIPTION
The New-OAIThreadQuery function creates a new thread query by invoking the New-OAIThread cmdlet and submitting a message using the Submit-OAIMessage cmdlet.

.PARAMETER UserInput
The user input to be included in the query.

.PARAMETER Assistant
The assistant to be used for the query.

.EXAMPLE
New-OAIThreadQuery -UserInput "Hello" -Assistant $assistant

This example creates a new thread query with the user input "Hello" and the specified assistant.

.OUTPUTS
System.Object[]
The output consists of an array containing the created thread, the run status, and the message.

#>
function New-OAIThreadQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $UserInput,
        [Parameter(Mandatory)]
        $Assistant
    )

    $thread = New-OAIThread
    
    $submitResult = Submit-OAIMessage -Assistant $assistant -Thread $thread -UserInput $UserInput

    [PSCustomobject]@{
        Thread  = $thread
        Run     = $submitResult.run
        Message = $submitResult.message
    }
}