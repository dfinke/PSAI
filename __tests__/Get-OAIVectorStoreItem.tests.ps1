Describe "Get-OAIVectorStoreItem" -Tag Get-OAIVectorStoreItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStoreItem -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]
        $keyArray[0] | Should -BeExactly 'VectorStoreId'

        $actual.Parameters["VectorStoreId"].Attributes.       ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters["VectorStoreId"].Aliases | Should -BeExactly "Id"
    }
}