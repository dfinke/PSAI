Describe "Invoke-SimpleQuestion" -Tag "Invoke-SimpleQuestion" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-SimpleQuestion -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains("Question") | Should -Be $true

        $actual.Parameters.Keys.Contains("AssistantId") | Should -Be $true

        $actual.Parameters.AssistantId.Aliases.Count | Should -Be 1
        $actual.Parameters.AssistantId.Aliases | Should -Be "id"
        $actual.Parameters.AssistantId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters.Question.Attributes.Mandatory | Should -Be $true
    }
}