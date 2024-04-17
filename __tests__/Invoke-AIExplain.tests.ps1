Describe "Invoke-AIExplain" -Tag Invoke-AIExplain {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Invoke-AIExplain -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('Text') | Should -Be $true
        $actual.Parameters.Keys.Contains('AsBulletList') | Should -Be $true
        $actual.Parameters['AsBulletList'].SwitchParameter | Should -Be $true
    }

    It 'shoule have alias "explain"' {
        $actual = Get-Alias explain -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }
}