Describe 'Get-OAIMessage' -Tag Get-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
        # $actual.Parameters['threadId'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 2
        $actual.Parameters.ThreadId.Aliases.Contains('thread_id') | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Contains('id') | Should -Be $true

        $actual.Parameters.Keys.Contains('Limit') | Should -Be $true

        $actual.Parameters.Keys.Contains('Order') | Should -Be $true

        $validateset = $actual.Parameters.Order.Attributes[1]

        $validateset | Should -Not -BeNullOrEmpty
        $validateset.ValidValues | Should -Be @('asc', 'desc')

        $actual.Parameters.Keys.Contains('After') | Should -Be $true

        $actual.Parameters.Keys.Contains('Before') | Should -Be $true
    }
}