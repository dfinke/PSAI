Describe "Test New-AIProviderListFromKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $backup = Get-AIKeyInfo -AsHashTable
        $path = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        Remove-Item $path -ErrorAction SilentlyContinue
    }

    It "Create a new ProviderList from environment variables" {
        $env:OpenAIKey = 'OpenAISuperKeyEnv'
        New-AIProviderListFromKeyInfo
        Get-AIProvider -All | Should -Not -BeNullOrEmpty
    }
    AfterAll {
        $backup | ConvertTo-Json | Out-File $path
     }
}