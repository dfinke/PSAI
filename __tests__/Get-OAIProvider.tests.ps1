Describe "Get-OAIProvider" -Tag Get-OAIProvider {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIProvider -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys | Should -BeNullOrEmpty
    }
}