Describe 'Get-OAIThread' -Tag 'Get-OAIThread' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('threadId') | Should -Be $true

        $actual.Parameters.threadId.Attributes.Mandatory | Should -Be $true
    }
}