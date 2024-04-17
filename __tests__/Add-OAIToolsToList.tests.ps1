Describe 'Add-OAIToolsToList' -Tag Add-OAIToolsToList {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Add-OAIToolsToList -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('Tools') | Should -Be $true
        $actual.Parameters.Keys.Contains('FunctionJson') | Should -Be $true     
        $actual.Parameters.Keys.Contains('Body') | Should -Be $true

        $actual.Parameters['Body'].ParameterType.FullName | Should -Be 'System.Collections.Hashtable'
        $actual.Parameters['Body'].Attributes.Mandatory | Should -Be $true
    }
}