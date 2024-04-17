Describe 'Get-OAIRunStep' -Tag 'Get-OAIRunStep' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIRunStep -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Threadid') | Should -Be $true
        $actual.Parameters.threadId.Attributes.Mandatory | Should -Be $true

        $actual.Parameters.Keys.Contains('Runid') | Should -Be $true
        $actual.Parameters.runId.Attributes.Mandatory | Should -Be $true

        $actual.Parameters.Keys.Contains('Limit') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('Order') | Should -Be $true

        # $actual.Parameters.order.Attributes.ValidateSet | Should -Be @('asc', 'desc')

        $actual.Parameters.Keys.Contains('After') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('Before') | Should -Be $true
    }
}