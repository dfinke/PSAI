Describe 'Get-OAIFile' -Tag 'Get-OAIFile' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-OAIFile -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('purpose') | Should -Be $true
        
        $actual.Parameters.Keys.Contains('Raw') | Should -Be $true
        $actual.Parameters['Raw'].SwitchParameter | Should -Be $true

        $validateset = $actual.Parameters['purpose'].Attributes[1]

        $validateset | Should -Not -BeNullOrEmpty
        $validateset.ValidValues | Should -Be @('fine-tune', 'fine-tune-results', 'assistants')
    }
}