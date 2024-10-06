Describe "New-Agent" -Tag New-Agent {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-Agent -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Instructions'
        $keyArray[1] | Should -BeExactly 'Tools'
        $keyArray[2] | Should -BeExactly 'LLM'
        $keyArray[3] | Should -BeExactly 'Name'
        $keyArray[4] | Should -BeExactly 'Description'
        $keyArray[5] | Should -BeExactly 'ShowToolCalls'

        $actual.Parameters.ShowToolCalls.SwitchParameter | Should -Be $true
    }
}