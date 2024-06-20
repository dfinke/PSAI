
Describe 'Remove-OAIThread' -Tag Remove-OAIThread {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Remove-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        #$actual.Parameters.Keys.Contains('threadId') | Should -Be $true
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -Be 'threadId'

        $actual.Parameters.threadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
    }
}