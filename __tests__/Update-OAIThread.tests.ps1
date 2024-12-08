Describe "Update-OAIThread" -Tag Update-OAIThread {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Update-OAIThread -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
       
        $keyArray[0] | Should -Be "threadId"
        $keyArray[1] | Should -Be "toolResources"
        $keyArray[2] | Should -Be "metadata"      
    }
}