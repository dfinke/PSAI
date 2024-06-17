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