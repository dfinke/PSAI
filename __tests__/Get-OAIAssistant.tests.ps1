Describe 'Get-OAIAssistant' -Tag Get-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('Name') | Should -Be $true
        $actual.Parameters.Keys.Contains('Raw') | Should -Be $true     
        
        $actual.Parameters['Raw'].SwitchParameter | Should -Be $true
    }
}