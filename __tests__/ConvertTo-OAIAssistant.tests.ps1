Describe "Convert To OAI Assistant" -Tags ConvertTo-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "Test if it ConvertTo-OAIAssistant exists" {
        $actual = Get-Command ConvertTo-OAIAssistant -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test ConvertTo-OAIAssistant has correct parameters" {
        $actual = Get-Command ConvertTo-OAIAssistant -ErrorAction SilentlyContinue

        $actual.Parameters.Keys.Contains('AssistantConfig') | Should -Be $true
    }
}