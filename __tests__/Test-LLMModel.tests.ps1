Describe "Test-LLMModel" -Tag Test-LLMModel {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Should exist" {
        $actual = Get-Command Test-LLMModel -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}
