Describe 'Get-OAIAssistant' -Tag Get-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Name'
        $keyArray[1] | Should -BeExactly 'Limit'
        $keyArray[2] | Should -BeExactly 'Order'  
        $keyArray[3] | Should -BeExactly 'After'
        $keyArray[4] | Should -BeExactly 'Before'
        $keyArray[5] | Should -BeExactly 'Raw'        

        $validateset = $actual.Parameters['Order'].Attributes.ValidValues
        $validateset | Should -Be @('asc', 'desc')

        $actual.Parameters['Raw'].SwitchParameter | Should -Be $true
    }
}