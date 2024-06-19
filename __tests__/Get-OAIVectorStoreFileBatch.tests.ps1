Describe "Get-OAIVectorStoreFileBatch" -Tag Get-OAIVectorStoreFileBatch {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStoreFileBatch -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'BatchId'

        $actual.Parameters["VectorStoreId"].Attributes.Mandatory | Should -Be $true
        $actual.Parameters["BatchId"].Attributes.Mandatory | Should -Be $true
    }
}