<#
.SYNOPSIS
Resets the OpenAI provider.

.DESCRIPTION
The Reset-OAIProvider function is used to reset the OpenAI provider.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Reset-OAIProvider
Resets the OpenAI provider.

#>
function Reset-OAIProvider {
    [CmdletBinding()]
    param ()
    
    Set-OAIProvider OpenAI
}