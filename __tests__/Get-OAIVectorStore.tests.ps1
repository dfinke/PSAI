Describe "Get-OAIVectorStore" -Tag Get-OAIVectorStore {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStore -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'limit'
        $keyArray[1] | Should -BeExactly 'order'
        $keyArray[2] | Should -BeExactly 'after'
        $keyArray[3] | Should -BeExactly 'before'
        $keyArray[4] | Should -BeExactly 'Raw'

        $actual.Parameters.order.Attributes.ValidValues | Should -Be @('asc', 'desc')
    }
}