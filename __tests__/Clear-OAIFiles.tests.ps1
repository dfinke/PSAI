Describe 'Clear-OAIFiles' -Tag Clear-OAIFiles {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Clear-OAIFiles -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}