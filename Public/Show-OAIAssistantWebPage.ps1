<#
.SYNOPSIS
Opens the OpenAI Playground web page for the specified assistant ID or the default page.

.DESCRIPTION
The Show-OAIAssistantWebPage function opens the OpenAI Playground web page for the specified assistant ID or the default page if no ID is provided. The web page allows you to interact with the OpenAI assistant.

.PARAMETER assistantId
The ID of the OpenAI assistant. If provided, the function opens the web page for the specified assistant ID. If not provided, the function opens the default web page.

.EXAMPLE
Show-OAIAssistantWebPage -assistantId "assistant-12345"
Opens the OpenAI Playground web page for the assistant with ID "assistant-12345".

.EXAMPLE
Show-OAIAssistantWebPage
Opens the default OpenAI Playground web page.

#>

function Show-OAIAssistantWebPage {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("id")]
        $assistantId 
    )
    
    Process {

        if ($assistantId) {
            $uri = 'https://platform.openai.com/playground/assistants?assistant={0}' -f $assistantId
        }
        else {
            $uri = 'https://platform.openai.com/playground/assistants'            
        }

        Start-Process $uri
    }
}