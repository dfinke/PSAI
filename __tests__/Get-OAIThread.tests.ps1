Describe 'Get-OAIThread' -Tag Get-OAIThread {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -Be 'threadId'
        $actual.Parameters.threadId.Attributes.Mandatory | Should -Be $true
    }
}