Describe "Convert To AI Prompt" -Tags ConvertTo-AIPrompt {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if ConvertTo-AIPrompt exists" {
        $actual = Get-Command ConvertTo-AIPrompt -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test ConvertTo-AIPrompt has correct parameters" {
        $actual = Get-Command ConvertTo-AIPrompt -ErrorAction SilentlyContinue

        $actual.Parameters.Keys.Contains('RepoSlug') | Should -Be $true
        $actual.Parameters.Keys.Contains('OutputPath') | Should -Be $true
        $actual.Parameters.Keys.Contains('Exclude') | Should -Be $true
        $actual.Parameters.Keys.Contains('Include') | Should -Be $true
        $actual.Parameters.Keys.Contains('Token') | Should -Be $true
        $actual.Parameters.Keys.Contains('IncludeBinary') | Should -Be $true
    }
}