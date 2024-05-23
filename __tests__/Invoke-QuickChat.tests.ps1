Describe "Invoke-QuickChat" -Tag Invoke-QuickChat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-QuickChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains("AssistantId") | Should -Be $true

        $actual.Parameters.AssistantId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters.AssistantId.Aliases.Count | Should -Be 1
        $actual.Parameters.AssistantId.Aliases | Should -Be 'id'        
    }
}