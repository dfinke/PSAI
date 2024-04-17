
Describe 'Remove-OAIAssistant' -Tag Remove-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Remove-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Id') | Should -Be $true
        $actual.Parameters['Id'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
    }
}