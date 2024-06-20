Describe "New-OAIVectorStoreFile" -Tag New-OAIVectorStoreFile {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-OAIVectorStoreFile -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'FileIds'

        $actual.Parameters['VectorStoreId'].Attributes.Mandatory | Should -Be $true

        $actual.Parameters['FileIds'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters['FileIds'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.FileIds.Aliases.Count | Should -Be 1
        $actual.Parameters.FileIds.Aliases | Should -Be 'id'
    }
}