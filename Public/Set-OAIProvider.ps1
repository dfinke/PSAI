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
        [ValidateSet('AzureOpenAI', 'OpenAI', 'xAI', 'Anthropic', 'DeepSeek', 'Gemini')]
        $Provider = 'OpenAI'
    )

    $script:OAIProvider = $Provider
}