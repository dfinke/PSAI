Describe "Set-AIDefaultProvider" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    BeforeEach {
        New-AIProviderList -Force
    }

    It "should set the default provider when the provider exists" {
        Import-AIProvider -Provider "OpenAI", "AzureOpenAI"
        (Get-AIProvider).Name | Should -Be "OpenAI"
        Set-AIDefaultProvider -ProviderName "AzureOpenAI"
        (Get-AIProvider).Name | Should -Be "AzureOpenAI"
    }

    It "should throw an error if the provider list is empty" {
        $providerName = "OpenAI"
        { Set-AIDefaultProvider -ProviderName $providerName } | Should -Throw "Provider $providerName not found in the list. Please add a provider first."
    }

    It "should throw an error if the provider does not exist" {
        Import-AIProvider -Provider "OpenAI"
        { Set-AIDefaultProvider -ProviderName "NonExistentProvider" } | Should -Throw "Provider NonExistentProvider not found in the list. Please add a provider first."
    }
}