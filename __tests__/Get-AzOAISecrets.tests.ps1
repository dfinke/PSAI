Describe "Get-AzOAISecrets" -Tag Get-AzOAISecrets {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-AzOAISecrets -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys | Should -BeNullOrEmpty
    }
}