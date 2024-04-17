Describe 'Get-OAIFileItem' -Tag 'Get-OAIFileItem' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIFileItem -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('FileId') | Should -Be $true

        $actual.Parameters['FileId'].Attributes.Mandatory | Should -Be $true
    }
}