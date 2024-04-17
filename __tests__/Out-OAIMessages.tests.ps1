Describe 'Out-OAIMessages' -Tag Out-OAIMessages {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Out-OAIMessages -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Messages') | Should -Be $true

        $actual.Parameters.Keys.Contains('NoHeader') | Should -Be $true

        $actual.Parameters.NoHeader.SwitchParameter | Should -Be $true        
    }
}