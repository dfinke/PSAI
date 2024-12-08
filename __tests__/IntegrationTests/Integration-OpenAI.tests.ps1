BeforeDiscovery {
    if ($env:GITHUB_ACTIONS -eq 'true') {
        $info = $null
    } else{
        $info = Get-SecretInfo -Name OpenAI
        $env:TempOpenAIKey = $env:OpenAIKey
        $env:OpenAIKey = Get-Secret OpenAI -asPlainText # replace with clear text password if Get-Secret is not setup on your system    
    }
}

Describe "Test chat endpoints with Secret" -Skip:($null -eq $info) {

    BeforeAll {
        Import-Module "$(Split-Path $(Split-Path $PSScriptRoot))/PSAI.psd1" -Force
        $params = @{
                Provider = 'OpenAI'
                ApiKey = Get-Secret OpenAI
            }
        Import-AIProvider @params
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
            $Model = Get-AIModel -ProviderName OpenAI
            $Prompt = "What is the capitol of Italy"
            $Answer = $Model.Chat($Prompt)
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Rome"
        }
    }
}

Describe "Test chat endpoints with Environment Variable" -Skip:($null -eq $env:OpenAIKey) {

    BeforeEach {
        Import-Module "$(Split-Path $(Split-Path $PSScriptRoot))/PSAI.psd1" -Force
    }

    Context "Invoke-OAIChatCompletion with Environment Variable" {
        It "Invoke-OAIChatCompletion generates an answer" -Skip:($null -eq $env:OpenAIKey) {
            $Prompt = "What is the capitol of France"
            $Message = New-OAIChatMessage -Role user -Content $Prompt
            $Answer = Invoke-OAIChatCompletion -Message $Message
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Paris"
        }
        
    }
}

AfterAll {
    $env:OpenAIKey = $env:TempOpenAIKey
    Clear-AIProviderList
}