Describe "Invoke-OAIChat" -Tag Invoke-OAIChat {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It 'should have these parameters' {
        $actual = Get-Command Invoke-OAIChat -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'UserInput'
        $keyArray[1] | Should -BeExactly 'Instructions'
        $keyArray[2] | Should -BeExactly 'model'
     
        $actual.Parameters.UserInput.Attributes.ValueFromPipeline | Should -Be $true
        $actual.Parameters.Instructions.Aliases.Count | Should -Be 0

        $ValidateSet = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        $ValidateSet | Should -Not -BeNullOrEmpty     

        $validValues = $actual.Parameters['model'].Attributes.ValidValues
        $validValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-1106-preview', 'gpt-4-turbo-preview', 'gpt-3.5-turbo-1106')
    }
}