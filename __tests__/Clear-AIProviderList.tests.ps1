Describe "Clear-AIProviderList" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    BeforeEach {
        Import-AIProvider -Provider "OpenAI" -ModelNames "gpt-4o-mini", "gpt-4o"
        Import-AIProvider -Provider "AzureOpenAI" -ModelNames "azure-gpt-3", "azure-gpt-4"
    }

    It "should clear all providers from the list" {
        Clear-AIProviderList
        $script:ProviderList | Should -Be $null
    }


    It "should allow adding new providers after clearing the list" {
        Clear-AIProviderList
        Import-AIProvider -Provider OpenAI -ModelNames "new-model-1"
        (Get-AIProviderList).Count | Should -Be 1
        (Get-AIProvider).Name | Should -Be "OpenAI"
    }
}