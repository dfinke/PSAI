Describe "Remove-OAIMessage" -Tag Remove-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Remove-OAIMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -Be "ThreadId"
        $keyArray[1] | Should -Be "MessageId"

        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases.Contains("thread_id") | Should -Be $true

        $actual.Parameters.MessageId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.MessageId.Aliases.Count | Should -Be 1
        $actual.Parameters.MessageId.Aliases.Contains("id") | Should -Be $true
    }
}