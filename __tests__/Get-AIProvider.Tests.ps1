Describe "Get-AIProvider" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        Import-AIProvider -Provider OpenAI, AzureOpenAI
    }


    It "should retrieve the default provider when no parameters are specified" {
        $result = Get-AIProvider
        $result.Name | Should -Be "OpenAI"
    }

    It "should retrieve a specific provider by name" {
        $result = Get-AIProvider -Name "AzureOpenAI"
        $result.Name | Should -Be "AzureOpenAI"
    }

    It "should retrieve all providers when -All is specified" {
        $result = Get-AIProvider -All
        $result.Keys | Should -Contain "OpenAI"
        $result.Keys | Should -Contain "AzureOpenAI"
    }
}