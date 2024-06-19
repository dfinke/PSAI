Describe "Get-OAIVectorStoreFilesInBatch" -Tag Get-OAIVectorStoreFilesInBatch {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStoreFilesInBatch -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'BatchId'
        $keyArray[2] | Should -BeExactly 'limit'
        $keyArray[3] | Should -BeExactly 'order'
        $keyArray[4] | Should -BeExactly 'after'
        $keyArray[5] | Should -BeExactly 'before'
        $keyArray[6] | Should -BeExactly 'filter'

        $actual.Parameters["VectorStoreId"].Attributes.Mandatory | Should -Be $true
        $actual.Parameters["BatchId"].Attributes.Mandatory | Should -Be $true
    }
}
