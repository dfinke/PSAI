Describe 'Get-OAIAssistantItem' -Tag Get-OAIAssistantItem {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIAssistantItem -ErrorAction SilentlyContinue
      
        $actual | Should -Not -BeNullOrEmpty
        
        $actual.Parameters.Keys.Contains('AssistantId') | Should -Be $true

        $actual.Parameters.AssistantId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.AssistantId.Aliases.Count | Should -Be 1
        $actual.Parameters.AssistantId.Aliases | Should -Be 'assistant_id'
    }
}