Describe 'Submit-OAIToolOutputs' -Tag 'Submit-OAIToolOutputs' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Submit-OAIToolOutputs -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('threadId') | Should -Be $true
        $actual.Parameters.threadId.Attributes.Mandatory | Should -Be $true
        
        $actual.Parameters.Keys.Contains('runId') | Should -Be $true
        $actual.Parameters.runId.Attributes.Mandatory | Should -Be $true
        
        $actual.Parameters.Keys.Contains('toolOutputs') | Should -Be $true
        $actual.Parameters.toolOutputs.Attributes.Mandatory | Should -Be $true
    }
}