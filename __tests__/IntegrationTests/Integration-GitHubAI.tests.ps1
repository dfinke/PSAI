BeforeDiscovery {
    if ($env:GITHUB_ACTIONS -eq 'true') {
        $info = $null
    } else{
        $info = Get-SecretInfo -Name GitHubAI
    }
}

Describe "Test chat endpoints with Secret" -Skip:($null -eq $info) {

    BeforeAll {
        Import-Module "$(Split-Path $(Split-Path $PSScriptRoot))/PSAI.psd1" -Force
        $params = @{
                Provider = 'GitHubAI'
                ApiKey = Get-Secret GitHubAI
            }
        Import-AIProvider @params
        Set-AIDefaultModel -ProviderName GitHubAI -ModelName "gpt-4o-mini"
    }

    Context "Invoke-OAIChatCompletion with Secret" {
        It "Invoke-OAIChatCompletion generates an answer" -Skip:($null -eq $info) {
            $Prompt = "What is the capitol of France"
            $Message = New-OAIChatMessage -Role user -Content $Prompt
            $Answer = Invoke-OAIChatCompletion -Message $Message
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Paris"
        }
        It "Moniker syntax generates an answer" -Skip:($null -eq $info) {
            $Model = Get-AIModel -ProviderName GitHubAI
            $Prompt = "What is the capitol of Italy"
            $Answer = $Model.Chat($Prompt)
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Rome"
        }
    }
}

AfterAll {
    Clear-AIProviderList
}