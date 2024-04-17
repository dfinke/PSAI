Describe 'Import-OAIAssistant' -Tag Import-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Import-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}
