Describe 'Test aliases exist' -Tag AliasesExist {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these aliases' {
        Get-Alias goaia -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        Get-Alias roaia -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        Get-Alias noaia -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        Get-Alias noait -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        Get-Alias uoaia -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        Get-Alias ai -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
    }
}