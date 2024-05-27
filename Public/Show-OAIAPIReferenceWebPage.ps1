<#
.SYNOPSIS
Opens the OpenAI API reference web page.

.DESCRIPTION
The Show-OAIAPIReferenceWebPage function opens the OpenAI API reference web page in the default web browser.

.EXAMPLE
Show-OAIAPIReferenceWebPage
Opens the OpenAI API reference web page.

#>

function Show-OAIAPIReferenceWebPage {
    Start-Process 'https://platform.openai.com/docs/api-reference'
}