function Set-OAIProvider {
    [CmdletBinding()]
    param(
        [ValidateSet('AzureOpenAI', 'OpenAI')]
        $Provider = 'OpenAI'
    )

    $script:OAIProvider = $Provider
}