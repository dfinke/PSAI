Describe "Set-OAIProvider" -Tag Set-OAIProvider {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Set-OAIProvider -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Provider') | Should -Be $true

        # $actual.Parameters.Provider.DefaultValue | Should -Be 'OpenAI'

        $actual.Parameters.Provider.Attributes.ValidValues | Should -Be @('AzureOpenAI', 'OpenAI', 'xAI', 'Groq', 'Anthropic')
    }
}