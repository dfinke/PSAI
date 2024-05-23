<#
.SYNOPSIS
    Invokes a quick chat session with an AI assistant.

.DESCRIPTION
    This function allows you to interact with an AI assistant by asking questions and receiving responses in a chat-like manner.

.PARAMETER AssistantId
    Specifies the ID of the assistant to interact with.

.EXAMPLE
    $assistant = New-OAIAssistant -Name 'Math Tutor'
    Invoke-QuickChat $assistant.id

#>
function Invoke-QuickChat {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $AssistantId
    )

    End {
        if (!(Test-OAIAssistantId $AssistantId)) {
            Write-Error "Assistant with Id $AssistantId not found"
            return
        }

        $assistant = Get-OAIAssistantItem -AssistantId $AssistantId
        $assistantName = $assistant.Name
        if ($null -eq $assistantName) {
            $assistantName = 'Assistant'
        }

        "Hello, I am an $($assistantName). Type 'Exit' to exit."

        while ($true) {
            #$userInput = Read-Host "Ask $($assistantName) a question"
            $userInput = Read-Host "Question"
    
            if ($userInput -eq 'Exit') {
                break
            }

            if (!$threadQuery) {
                $threadQuery = New-OAIThreadQuery -Assistant $assistant -UserInput $userInput
            }
            else {
                $submitResponse = Submit-OAIMessage -Assistant $assistant -Thread $threadQuery.Thread -UserInput $userInput

                $threadQuery.Run = $submitResponse.Run
                $threadQuery.Message = $submitResponse.Message
            }

            $null = Wait-OAIOnRun -Thread $threadQuery.Thread -Run $threadQuery.Run

            $message = Get-OAIMessage -ThreadId $threadQuery.Thread.Id -Order asc
            $message.data[-1].content.text.value
        }
    }
}