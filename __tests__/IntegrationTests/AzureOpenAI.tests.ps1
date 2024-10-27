BeforeAll {
    Import-Module "$(Split-Path $(Split-Path $PSScriptRoot))/PSAI.psd1" -Force
    $AzOAISecrets = Get-Secret AzOAISecrets -Vault AxKeys -AsPlainText | ConvertFrom-Json -AsHashtable
    $params = @{
        Provider = 'AzureOpenAI'
        BaseUri = $AzOAISecrets.apiURI
        ApiKey = $AzOAISecrets.apiKEY | ConvertTo-SecureString -AsPlainText
    }
    Import-AIProvider @params
}

Describe "Test chat endpoints" {
    it "Invoke-OAIChatCompletion generates an answer" {
        $Prompt = "What is the capitol of France"
        $Message = New-OAIChatMessage -Role user -Content $Prompt
        $Answer = Invoke-OAIChatCompletion -Message $Message
        $Answer | Should -Not -BeNullOrEmpty
        $Answer | Should -BeOfType [String]
        $Answer | Should -Match "Paris"
    }
}