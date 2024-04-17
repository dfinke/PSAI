
Describe 'Remove-OAIFile' -Tag 'Remove-OAIFile' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Remove-OAIFile -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('id') | Should -Be $true
        $actual.Parameters.id.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
    }
}