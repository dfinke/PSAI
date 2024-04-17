Describe 'New-OAIAssistant' -Tag New-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('name') | Should -Be $true
        $actual.Parameters.Keys.Contains('Description') | Should -Be $true
        $actual.Parameters.Keys.Contains('instructions') | Should -Be $true
        $actual.Parameters.Keys.Contains('Metadata') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('FileIds') | Should -Be $true
        $actual.Parameters.FileIds.Aliases.Count | Should -Be 1
        $actual.Parameters.FileIds.Aliases | Should -Be 'file_ids'
        
        $actual.Parameters.Keys.Contains('Tools') | Should -Be $true      

        $actual.Parameters.Keys.Contains('model') | Should -Be $true

        $ValidateSet = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        $ValidateSet | Should -Not -BeNullOrEmpty

        $validValues = $actual.Parameters['model'].Attributes.ValidValues
        $validValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106')

        # $validateScript = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateScriptAttribute] }
        # $validateScript | Should -Not -BeNullOrEmpty
        # $scriptBlock = $validateScript.ScriptBlock
        # $scriptBlock.ToString().Trim() | Should -BeExactly 'Test-LLMModel'
    }
}