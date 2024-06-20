Describe 'Get-OAIRunStep' -Tag Get-OAIRunStep {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIRunStep -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'ThreadId'
        $keyArray[1] | Should -BeExactly 'RunId'
        $keyArray[2] | Should -BeExactly 'Limit'
        $keyArray[3] | Should -BeExactly 'Order'
        $keyArray[4] | Should -BeExactly 'After'
        $keyArray[5] | Should -BeExactly 'Before'

        $actual.Parameters.threadId.Attributes.Mandatory | Should -Be $true

        $actual.Parameters.runId.Attributes.Mandatory | Should -Be $true

        # $actual.Parameters.Order.Attributes.ValidateSet | Should -Be @('asc', 'desc')

        $validateSet = $actual.Parameters.Order.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        
        $validateSet | Should -Not -BeNullOrEmpty
       
        $validateSet[0].ValidValues | Should -Be @('asc', 'desc')
    }
}