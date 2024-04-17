Describe 'Invoke-OAIUploadFile' -Tag 'Invoke-OAIUploadFile' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Invoke-OAIUploadFile -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Path') | Should -Be $true
        $actual.Parameters.Path.Aliases.Count | Should -Be 1
        $actual.Parameters.Path.Aliases | Should -Be 'FullName'

        $actual.Parameters.Keys.Contains('Purpose') | Should -Be $true

        
        $validateset = $actual.Parameters['Purpose'].Attributes.ValidValues
        $validateset | Should -Be @('fine-tune', 'assistants')
    }
}