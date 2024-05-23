Describe "Get-OAIVectorStoreFileItem" -Tag Get-OAIVectorStoreFileItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStoreFileItem -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'FileId'

        $actual.Parameters['VectorStoreId'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters['FileId'].Attributes.Mandatory | Should -Be $true

    }
}