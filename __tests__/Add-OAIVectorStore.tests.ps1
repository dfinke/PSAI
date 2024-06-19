Describe "Add-OAIVectorStore" -Tag "Add-OAIVectorStore" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Add-OAIVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Path'
        $actual.Parameters['Path'].Attributes.Mandatory | Should -Be $true
    }
}