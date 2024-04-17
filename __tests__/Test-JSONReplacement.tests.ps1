Describe "Test-JSONReplacement" -Tag Test-JSONReplacement {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Test-JSONReplacement -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "should return true for valid JSON" {
        $json = '{"name":"John","age":30,"city":"New York"}'
        $actual = Test-JSONReplacement -JSON $json

        $actual | Should -Be $true
    }

    It "should return false for invalid JSON" {
        $json = '{"name":"John","age":30,"city":"New York}'
        $actual = Test-JSONReplacement -JSON $json

        $actual | Should -Be $false
    }
}