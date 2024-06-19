Describe 'Get-OAIRunItem' -Tag Get-OAIRunItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIRunItem -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'ThreadId'
        $keyArray[1] | Should -BeExactly 'RunId'

        $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
        
        $actual.Parameters.threadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases | Should -Be 'thread_id'

        $actual.Parameters.Keys.Contains('RunId') | Should -Be $true
        $actual.Parameters.runId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.RunId.Aliases.Count | Should -Be 1
        $actual.Parameters.RunId.Aliases | Should -Be 'run_id'
    }
}