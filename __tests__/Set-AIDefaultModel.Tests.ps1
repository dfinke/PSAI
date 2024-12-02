Describe "Set-AIDefaultModel" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    BeforeEach {
        New-AIProviderList -Force
    }


    It "should set the default model for a provider using Provider object" {
        Import-AIProvider -Provider "OpenAI" -ModelNames "gpt-4o-mini", "gpt-4o"
        (Get-AIModel -ProviderName "OpenAI").Name | Should -Be "gpt-4o-mini"
        Set-AIDefaultModel -Provider "OpenAI" -ModelName "gpt-4o"
        (Get-AIModel -ProviderName "OpenAI").Name | Should -Be "gpt-4o"
    }

    It "should throw an error if the provider does not exist" {
        { Set-AIDefaultModel -ProviderName "NonExistentProvider" -ModelName "GPT-3" } | Should -Throw
    }
}