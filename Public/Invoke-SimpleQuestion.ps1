<#
.SYNOPSIS
    Invokes a simple question to an AI assistant.

.DESCRIPTION
    The Invoke-SimpleQuestion function is used to ask a simple question to an AI assistant. It requires the AssistantId parameter to specify the ID of the assistant to interact with. The function sends the question to the assistant, waits for the response, and returns the assistant's answer.

.PARAMETER Question
    The question to ask the AI assistant.

.PARAMETER AssistantId
    The ID of the AI assistant to interact with.

.EXAMPLE
    $assistant = New-OAIAssistant
    Invoke-SimpleQuestion -Question "What is the meaning of life?" -AssistantId $assistant.Id
    Remove-OAIAssistant -Id $assistant.Id
#>
function Invoke-SimpleQuestion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Question,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $AssistantId
    )

    Begin {
        $assistant = @()
    }

    Process {
        if($null -eq $AssistantId) {
            Write-Error "AssistantId is required"
            return
        }

        if (!(Test-OAIAssistantId $AssistantId)) {
            Write-Error "Assistant with Id $AssistantId not found"
            return
        }

        $assistant += Get-OAIAssistantItem -AssistantId $AssistantId
    }

    End {
        if($null -eq $assistant) {
            return
        }

        foreach ($assistantItem in $assistant) {
            $assistantName = $assistantItem.Name
            if ($null -eq $assistantName) {
                $assistantName = 'Assistant'
            }

            Write-Host "Asking the question: " -NoNewline
            Write-Host -ForegroundColor Yellow $Question

            $queryResult = New-OAIThreadQuery -UserInput $Question -Assistant $assistantItem
            $null = Wait-OAIOnRun -Run $queryResult.Run -Thread $queryResult.Thread
            $messages = Get-OAIMessage -ThreadId $queryResult.Thread.Id
            $messages.data[0].content.text.value
        }
    }
}