Describe 'Wait-OAIOnRun' -Tag Wait-OAIOnRun {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Wait-OAIOnRun -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Run') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('Thread') | Should -Be $true
    }
}