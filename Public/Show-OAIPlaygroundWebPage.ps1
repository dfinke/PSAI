<#
.SYNOPSIS
Opens the OpenAI Playground Web Page.

.DESCRIPTION
This function opens the OpenAI Playground Web Page in the default web browser.

.EXAMPLE
Show-OAIPlaygroundWebPage
#>

function Show-OAIPlaygroundWebPage {
    Start-Process 'https://platform.openai.com/playground'
}