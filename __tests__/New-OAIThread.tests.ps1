Describe 'New-OAIThread' -Tag New-OAIThread {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
       
        $keyArray[0] | Should -Be 'Messages'
        $keyArray[1] | Should -Be 'ToolResources'
        $keyArray[2] | Should -Be 'Metadata'
    }
}