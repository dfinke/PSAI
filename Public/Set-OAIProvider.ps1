<#
.SYNOPSIS
Sets the provider for OpenAI.

.DESCRIPTION
The Set-OAIProvider function is used to set the provider for OpenAI. By default, the provider is set to 'OpenAI'.

.PARAMETER Provider
Specifies the provider for OpenAI. The available options are 'AzureOpenAI' and 'OpenAI'.

.EXAMPLE
Set-OAIProvider -Provider 'AzureOpenAI'
This example sets the provider for OpenAI to 'AzureOpenAI'.

.EXAMPLE
Set-OAIProvider -Provider 'OpenAI'
This example sets the provider for OpenAI to 'OpenAI'.
#>

function Set-OAIProvider {
    [CmdletBinding()]
    param(
        [ValidateSet('AzureOpenAI', 'OpenAI')]
        $Provider = 'OpenAI'
    )

    $script:OAIProvider = $Provider

    if ($Provider -eq 'AzureOpenAI') {
        $AzOAISecrets = Get-AzOAISecrets
        if ($AzOAISecrets.Values.length.Contains(0))
        {
            Write-Error "Azure OpenAI secrets are not set. Please run Set-AzOAISecrets to set the secrets."
            return
        }
        $script:baseUrl = '{0}/openai' -f $AzOAISecrets.apiURI.TrimEnd('/')
    }
    else {
        $script:baseUrl = 'https://api.openai.com/v1'
    }
}