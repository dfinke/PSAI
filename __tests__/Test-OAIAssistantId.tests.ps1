Describe 'Test-OAIAssistantId' -Tag Test-OAIAssistantId {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Test-OAIAssistantId -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}