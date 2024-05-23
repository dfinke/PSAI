Describe "Get-OAIRunStepItem" -Tag Get-OAIRunStepItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Get-OAIRunStepItem -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly "ThreadId"
        $keyArray[1] | Should -BeExactly "RunId"
        $keyArray[2] | Should -BeExactly "StepId"

        $actual.Parameters.ThreadId.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.RunId.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.StepId.Attributes.Mandatory | Should -Be $true
    }
}