Describe "ConvertTo-ToolFormat" -Tag ConvertTo-ToolFormat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "Test if it ConvertTo-ToolFormat exists" {
        $actual = Get-Command ConvertTo-ToolFormat -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('functions') | Should -Be $true
    }
}