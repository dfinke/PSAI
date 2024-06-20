
Describe 'Remove-OAIAssistant' -Tag Remove-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Remove-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Id'
        $actual.Parameters['Id'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
    }
}