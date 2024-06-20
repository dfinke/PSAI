Describe "New-OAIAssistantWithVectorStore" -Tag New-OAIAssistantWithVectorStore {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-OAIAssistantWithVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]
        
        $keyArray[0] | Should -BeExactly 'Path'

        $actual.Parameters['Path'].Attributes.Mandatory | Should -Be $true
    }
}