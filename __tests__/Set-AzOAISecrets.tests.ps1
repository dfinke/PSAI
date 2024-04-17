Describe "Set-AzOAISecrets" -Tag Set-AzOAISecrets {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Set-AzOAISecrets -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('apiURI') | Should -Be $true
        $actual.Parameters.Keys.Contains('apiKEY') | Should -Be $true
        $actual.Parameters.Keys.Contains('apiVersion') | Should -Be $true
        $actual.Parameters.Keys.Contains('deploymentName') | Should -Be $true

        $actual.Parameters.apiURI.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.apiKEY.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.apiVersion.Attributes.Mandatory | Should -Be $true
        $actual.Parameters.deploymentName.Attributes.Mandatory | Should -Be $true
    }
}