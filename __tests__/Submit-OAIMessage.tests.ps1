Describe 'Submit-OAIMessage' -Tag Submit-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Submit-OAIMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Assistant') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('Thread') | Should -Be $true

        $actual.Parameters.Keys.Contains('UserInput') | Should -Be $true
    }
}