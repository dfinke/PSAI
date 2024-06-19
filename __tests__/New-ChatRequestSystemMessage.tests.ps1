Describe "New-ChatRequestSystemMessage" -Tag New-ChatRequestSystemMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-ChatRequestSystemMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'userRequest'

        $actual.Parameters.userRequest.Attributes.Mandatory | Should -Be $true
    }
}