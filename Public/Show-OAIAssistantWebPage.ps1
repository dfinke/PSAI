<#
.SYNOPSIS
Opens the OpenAI Assistant web page.

.DESCRIPTION
This function opens the OpenAI Assistant web page in the default web browser.

.EXAMPLE
Show-OAIAssistantWebPage
#>

function Show-OAIAssistantWebPage {
    Start-Process 'https://platform.openai.com/assistants'
}