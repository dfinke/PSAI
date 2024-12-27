

Describe "Test New-AIProviderListFromKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $backup = Get-AIKeyInfo -AsHashTable
        $path = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        Remove-Item $path -ErrorAction SilentlyContinue
        $env:OpenAIKey = $null
    
    }

    BeforeEach {
        $path = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        Remove-Item $path -ErrorAction SilentlyContinue
        $env:OpenAIKey = $null
        Clear-AIProviderList
    }
    
    It "Create a new ProviderList from environment variables" {
        $env:OpenAIKey = 'OpenAISuperKeyEnv'
        New-AIProviderListFromKeyInfo
        $AllProviders = Get-AIProvider -All
        $AllProviders | Should -Not -BeNullOrEmpty
        $AllProviders.Count | Should -Be 1
        (Get-AIProvider).GetApiKey() | Should -Be 'OpenAISuperKeyEnv'
    }

    it "Create a new ProviderList with multiple providers keeps order" {
        $env:OpenAIKey = 'OpenAISuperKeyEnv'
        $env:xAIKey = 'xAISuperKeyEnv'
        $env:GeminiKey = 'GeminiSuperKeyEnv'
        $env:AnthropicKey = 'AnthropicSuperKeyEnv'

        New-AIProviderListFromKeyInfo
        $provider = Get-AIProvider
        $provider | Should -Not -BeNullOrEmpty
        $provider.Name |Should -Be 'OpenAI'
    }
    AfterAll {
        $backup | ConvertTo-Json | Out-File $path
     }
}

