Describe "Get-AIProviderList" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        Import-AIProvider -Provider "OpenAI", "AzureOpenAI"
    }

    It "should retrieve the list of AI providers" {
        $result = Get-AIProviderList
        $result.Providers.Keys | Should -Contain "OpenAI"
        $result.Providers.Keys | Should -Contain "AzureOpenAI"
    }

    It "should return an array" {
        $result = Get-AIProviderList
        $result.PStypenames[0] | Should -Be 'AIProviderList'
    }

    It "should return the correct number of providers" {
        $result = Get-AIProviderList
        $result.Providers.Count | Should -Be 2
    }
}