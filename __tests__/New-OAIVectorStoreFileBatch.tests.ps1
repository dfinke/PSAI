Describe "New-OAIVectorStoreFileBatch" -Tag New-OAIVectorStoreFileBatch {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-OAIVectorStoreFileBatch -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'FileIds'

        $actual.Parameters["VectorStoreId"].Attributes.Mandatory | Should -Be $true

        $actual.Parameters["FileIds"].Attributes.Mandatory | Should -Be $true
    }
}