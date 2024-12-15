Describe "Set-AIDefault" -Tag "Set-AIDefault" -Skip {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Set-AIDefault -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Slug'

        $actual.Parameters.Slug.Attributes.Mandatory | Should -Be $true
    }
}