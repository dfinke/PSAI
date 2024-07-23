<#
.SYNOPSIS
Invokes an AI chat assistant to answer user questions.

.DESCRIPTION
The Invoke-OAIChat function is used to interact with an AI chat assistant. It takes user input as a parameter and returns the assistant's response.

.PARAMETER UserInput
Specifies the user input to be processed by the AI chat assistant.

.PARAMETER Model
Specifies the model to be used by the AI chat assistant. Valid values are 'gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-1106-preview', 'gpt-4-turbo-preview', and 'gpt-3.5-turbo-1106'. The default value is 'gpt-3.5-turbo'.

.EXAMPLE
Invoke-OAIChat -UserInput "What is the weather today?"
Invokes the AI chat assistant with the specified user input and returns the assistant's response.

.EXAMPLE
'show even numbers' | ai -Instructions 'use powershell, just code, no explanation'

.EXAMPLE
git status | ai 'write a detailed commit message'

.INPUTS
System.String

.OUTPUTS
System.String

.NOTES
This function requires the New-OAIAssistant, New-OAIThreadQuery, Wait-OAIOnRun, and Get-OAIMessage functions to be available in the current session.
#>
function Invoke-OAIChat {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $UserInput,
        $Instructions,
        $model = 'gpt-4o-omni'
    )

    Begin {
        $assistantParams = @{}

        $ts = Get-Date -Format "yyyyMMddHHmmss"

        $assistantParams["name"] = "PSAI-$ts"

        if (!$Instructions) {
            $Instructions = 'You are a helpful assistant. Please answer questions concisely.'
        }
        $assistantParams["instructions"] = $Instructions
        $assistantParams["model"] = $model

        $assistant = New-OAIAssistant @assistantParams

        [System.Collections.ArrayList]$lines = @()
    }

    Process {
        $lines += $UserInput                
    }
    
    End {
        $prompt = ($lines | Out-String).Trim()

        $queryResult = New-OAIThreadQuery -UserInput $prompt -Assistant $assistant 
        $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
        $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
        $messages.data[0].content.text.value
        $null = Remove-OAIAssistant -Id $assistant.Id
    }
}