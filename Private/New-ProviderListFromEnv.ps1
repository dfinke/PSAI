function New-ProviderListFromEnv
{
    if ($null -ne $env:OpenAIKey) {
        $params = @{
            Provider = 'OpenAI'
            ApiKey   = $env:OpenAIKey | ConvertTo-SecureString -AsPlainText -Force
        }
        if ($Body.Keys -contains 'model') {
            $params['ModelNames'] = $Body['model']
        }
        Import-AIProvider @params
    }
    if ($null -ne $script:AzOAISecrets['apiKEY']) {
        $params = @{
            Provider   = 'AzureOpenAI'
            ApiKey     = $script:AzOAISecrets.apiKEY | ConvertTo-SecureString -AsPlainText -Force
            ModelNames = $script:AzOAISecrets.deploymentName
            BaseUri    = $script:AzOAISecrets.apiURI
        }
        Import-AIProvider @params

    }
    if (-Not (Get-AIProviderList)) {
        throw "No provider has been set up yet. Please read the instructions for the module to set up a provider."
    }
    
}