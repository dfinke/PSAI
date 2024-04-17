Describe 'Clear-OAIAssistants' -Tag Clear-OAIAssistants {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Clear-OAIAssistants -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}