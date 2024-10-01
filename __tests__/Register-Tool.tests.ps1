Describe "Register-Tool" -Tag Register-Tool {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Register-Tool -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'FunctionName'
        $keyArray[1] | Should -BeExactly 'Strict'

        $actual.Parameters.Strict.SwitchParameter | Should -Be $true
    }
}