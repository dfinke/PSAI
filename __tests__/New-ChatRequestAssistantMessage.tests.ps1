Describe "New-ChatRequestAssistantMessage" -Tag New-ChatRequestAssistantMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-ChatRequestAssistantMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        # $keyArray[0] | Should -BeExactly 'userRequest'

        # $actual.Parameters.assistantRequest.Attributes.Mandatory | Should -Be $true
    }
}