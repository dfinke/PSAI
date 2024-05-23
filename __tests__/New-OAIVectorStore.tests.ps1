Describe "New-OAIVectorStore" -Tag New-OAIVectorStore {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-OAIVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Name'
        $keyArray[1] | Should -BeExactly 'FileIds'
        $keyArray[2] | Should -BeExactly 'ExpiresAfter'
        $keyArray[3] | Should -BeExactly 'Metadata'

        $actual.Parameters.Name.Attributes.ValueFromPipeline | Should -Be $true
    }
}