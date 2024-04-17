Describe 'New-OAIThreadQuery' -Tag New-OAIThreadQuery {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force

        Mock New-OAIThreadQuery { 
            [PSCustomObject]@{
                Thread  = 'mocked thread'
                Run     = 'mocked run'
                Message = $UserInput
            }
        }
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIThreadQuery -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('UserInput') | Should -Be $true
        $actual.Parameters.Keys.Contains('Assistant') | Should -Be $true

        $actual.Parameters['UserInput'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters['Assistant'].Attributes.Mandatory | Should -Be $true
    }

    It 'calls New-OAIThreadQuery' {        
        New-OAIThreadQuery -UserInput 'test' -Assistant 'assistant'
        Assert-MockCalled New-OAIThreadQuery -Times 1 -Exactly
    }

    It 'returns a PSCustomObject with the correct properties and values' {
        $actual = New-OAIThreadQuery -UserInput 'test' -Assistant 'assistant'

        $actual | Should -BeOfType [PSCustomObject]

        $actual.PSObject.Properties.Name | Should -Be @('Thread', 'Run', 'Message')
 
        $actual.Thread | Should -Be 'mocked thread'
        $actual.Run | Should -Be 'mocked run'
        $actual.Message | Should -Be 'test'
    }
}