Describe "Invoke-OAIChat" -Tag Invoke-OAIChat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'should have these parameters' {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
     
        $actual.Parameters.Keys.Contains('UserInput') | Should -Be $true
     
        $actual.Parameters.UserInput.Attributes.ValueFromPipeline | Should -Be $true
     
        $actual.Parameters.Keys.Contains('Instructions') | Should -Be $true
     
        $actual.Parameters.Instructions.Aliases.Count | Should -Be 0
     
        $actual.Parameters.Keys.Contains('model') | Should -Be $true

        $ValidateSet = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        $ValidateSet | Should -Not -BeNullOrEmpty     

        $validValues = $actual.Parameters['model'].Attributes.ValidValues
        $validValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-1106-preview', 'gpt-4-turbo-preview', 'gpt-3.5-turbo-1106')

        # $validateScript = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateScriptAttribute] }
        # $validateScript | Should -Not -BeNullOrEmpty
        # $scriptBlock = $validateScript.ScriptBlock
        # $scriptBlock.ToString().Trim() | Should -BeExactly 'Test-LLMModel'
    }
}