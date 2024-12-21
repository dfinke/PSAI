Describe 'Test Invoke-QuickPrompt' -Tag Invoke-QuickPrompt {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if it Invoke-QuickPrompt exists" {
        $actual = Get-Command Invoke-QuickPrompt -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test if it q alias exists" {
        $actual = Get-Command q -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }
}