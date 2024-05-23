Describe "Invoke-OAIChatCompletion" -Tag Invoke-OAIChatCompletion {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Invoke-OAIChatCompletion -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Messages'
        $keyArray[1] | Should -BeExactly 'Model'
        $keyArray[2] | Should -BeExactly 'Seed'
        $keyArray[3] | Should -BeExactly 'Stop'
        $keyArray[4] | Should -BeExactly 'Stream'
        $keyArray[5] | Should -BeExactly 'Temperature'
        $keyArray[6] | Should -BeExactly 'TopP'
        $keyArray[7] | Should -BeExactly 'Tools'
        $keyArray[8] | Should -BeExactly 'ToolChoice'
        $keyArray[9] | Should -BeExactly 'User'
        
        $actual.Parameters.Messages.Attributes.Mandatory | Should -Be $true
    }
}