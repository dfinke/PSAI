Describe "Remove-OAIVectorStore" -Tag Remove-OAIVectorStore {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Remove-OAIVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
        $keyArray[0] | Should -BeExactly 'VectorStoreId'

        $actual.Parameters.VectorStoreId.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.VectorStoreId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters.VectorStoreId.Aliases.Count | Should -Be 1
        $actual.Parameters.VectorStoreId.Aliases | Should -Be 'Id'
    }
}