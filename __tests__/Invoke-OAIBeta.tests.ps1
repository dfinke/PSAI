
Describe 'Invoke-OAIBeta' -Tag Invoke-OAIBeta {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Invoke-OAIBeta -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Uri') | Should -Be $true

        $actual.Parameters.Keys.Contains('Method') | Should -Be $true

        $actual.Parameters.Keys.Contains('Body') | Should -Be $true

        $actual.Parameters.Keys.Contains('ContentType') | Should -Be $true

        $actual.Parameters.Keys.Contains('OutFile') | Should -Be $true

        $actual.Parameters.Keys.Contains('NotOpenAIBeta') | Should -Be $true
        $actual.Parameters['NotOpenAIBeta'].SwitchParameter | Should -Be $true
    }
}