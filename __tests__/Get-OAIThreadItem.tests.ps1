Describe 'Get-OAIThreadItem' -Tag Get-OAIThreadItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIThreadItem -ErrorAction SilentlyContinue
      
        $actual | Should -Not -BeNullOrEmpty
        
        $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases | Should -Be 'thread_id'
    }
}