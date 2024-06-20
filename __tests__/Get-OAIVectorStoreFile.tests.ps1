Describe "Get-OAIVectorStoreFile" -Tag Get-OAIVectorStoreFile {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIVectorStoreFile -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'VectorStoreId'
        $keyArray[1] | Should -BeExactly 'limit'
        $keyArray[2] | Should -BeExactly 'order'
        $keyArray[3] | Should -BeExactly 'after'
        $keyArray[4] | Should -BeExactly 'before'
        $keyArray[5] | Should -BeExactly 'filter'

        $actual.Parameters['VectorStoreId'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters['VectorStoreId'].Attributes.Mandatory | Should -Be $true

        $ValidateSet = $actual.Parameters.order.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        $ValidateSet | Should -Not -BeNullOrEmpty     

        $validValues = $actual.Parameters['order'].Attributes.ValidValues
        
        $validValues | Should -Be @('asc', 'desc')

        $ValidateSet = $actual.Parameters.filter.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }

        $ValidateSet | Should -Not -BeNullOrEmpty

        $validValues = $actual.Parameters['filter'].Attributes.ValidValues

        $validValues | Should -Be @('in_progress', 'completed', 'failed', 'cancelled')
    }
}