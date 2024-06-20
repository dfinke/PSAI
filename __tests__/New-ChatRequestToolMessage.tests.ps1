Describe "New-ChatRequestToolMessage" -Tag New-ChatRequestToolMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-ChatRequestToolMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'toolCallId'
        $keyArray[1] | Should -BeExactly 'toolFunctionName'
        $keyArray[2] | Should -BeExactly 'content'

        $actual.Parameters.toolCallId.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.toolFunctionName.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.content.Attributes.Mandatory | Should -Be $true
   }
}