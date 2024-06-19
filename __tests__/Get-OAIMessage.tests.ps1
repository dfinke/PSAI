Describe 'Get-OAIMessage' -Tag Get-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -Be 'ThreadId'
        $keyArray[1] | Should -Be 'Limit'
        $keyArray[2] | Should -Be 'Order'
        $keyArray[3] | Should -Be 'After'
        $keyArray[4] | Should -Be 'Before'
        $keyArray[5] | Should -Be 'RunId'

        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 2
        $actual.Parameters.ThreadId.Aliases.Contains('thread_id') | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Contains('id') | Should -Be $true
 
        $validateset = $actual.Parameters.Order.Attributes[1]

        $validateset | Should -Not -BeNullOrEmpty
        $validateset.ValidValues | Should -Be @('asc', 'desc')
    }
}