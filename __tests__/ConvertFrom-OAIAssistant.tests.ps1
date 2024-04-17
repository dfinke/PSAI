Describe "Convert From OAI Assistant" -Tags ConvertFrom-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "Test if it ConvertFrom-OAIAssistant exists" {
        $actual = Get-Command ConvertFrom-OAIAssistant -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test ConvertFrom-OAIAssistant has correct parameters" {
        $actual = Get-Command ConvertFrom-OAIAssistant -ErrorAction SilentlyContinue

        $actual.Parameters.Keys.Contains('Assistant') | Should -Be $true
        $actual.Parameters['Assistant'].Attributes.Mandatory | Should -Be $true
    }
}