Describe 'Clear-OAIAllItems' -Tag Clear-OAIAllItems {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Clear-OAIAllItems -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}