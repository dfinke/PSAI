Describe "Reset-OAIProvider" -Tag Reset-OAIProvider {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Reset-OAIProvider -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Resets the OpenAI provider." {
        Set-OAIProvider AzureOpenAI
        Reset-OAIProvider
        Get-OAIProvider | Should -Be 'OpenAI'
    }
}