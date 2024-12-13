Describe "Test New-AIProviderListFromKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
   }

    It "Create a new ProviderList from environment variables" {
        New-AIProviderListFromKeyInfo
        Get-AIProvider -All | Should -Not -BeNullOrEmpty
    }
}