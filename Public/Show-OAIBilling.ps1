<#
.SYNOPSIS
Opens the OpenAI platform billing overview page.

.DESCRIPTION
The Show-OAIBilling function opens the OpenAI platform billing overview page in the default web browser.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Show-OAIBilling
Opens the OpenAI platform billing overview page.

#>

function Show-OAIBilling {
    Start-Process 'https://platform.openai.com/settings/organization/billing/overview'
}