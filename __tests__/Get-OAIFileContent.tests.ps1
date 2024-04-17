Describe 'Get-OAIFileContent' -Tag 'Get-OAIFileContent' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIFileContent -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('FileId') | Should -Be $true
        $actual.Parameters['FileId'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters.Keys.Contains('ContentType') | Should -Be $true
        $actual.Parameters.Keys.Contains('OutFile') | Should -Be $true
    }
}