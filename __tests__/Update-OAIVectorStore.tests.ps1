Describe "Update-OAIVectorStore" -Tag Update-OAIVectorStore {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Update-OAIVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'Name'
        $keyArray[2] | Should -BeExactly 'ExpiresAfter'
        $keyArray[3] | Should -BeExactly 'Metadata'        

        $actual.Parameters["VectorStoreId"].Attributes.Mandatory | Should -Be $true
    }
}
