<#
.SYNOPSIS
    Imports AI providers from environment variables.

.DESCRIPTION
    This cmdlet arttempts to import AI providers from environment variables and adds them to the provider list.

    This function should only run if the user did not import AI Providers before running other commands.

    If no environment variables are found for AI providers, a warning is displayed.

    Get-AIProviderList should be run after this command to ensure that the providers are imported and handle further actions


.NOTES
    This is a Private function and should not be called directly by the user.

.LINK
    Provides links to related cmdlets or online documentation.
#>


function New-ProviderListFromEnv {
    if ($null -ne $env:OpenAIKey) {
        $params = @{
            Provider = 'OpenAI'
            ApiKey   = $env:OpenAIKey | ConvertTo-SecureString -AsPlainText -Force
        }
        if ($Body.Keys -contains 'model') {
            $params['ModelNames'] = $Body['model']
        }
        Import-AIProvider @params
        Write-verbose "Imported OpenAI provider"
    }
    if ($null -ne $script:AzOAISecrets['apiKEY']) {
        $params = @{
            Provider   = 'AzureOpenAI'
            ApiKey     = $script:AzOAISecrets.apiKEY | ConvertTo-SecureString -AsPlainText -Force
            ModelNames = $script:AzOAISecrets.deploymentName
            BaseUri    = $script:AzOAISecrets.apiURI
        }
        Import-AIProvider @params
        Write-Verbose "Imported AzureOpenAI provider"

    }
    if (-Not $script:ProviderList) {
        Write-Verbose "No environment variables found for AI Providers"
    }
    
}