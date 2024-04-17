Describe 'New-OAIThread' -Tag New-OAIThread {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }
}