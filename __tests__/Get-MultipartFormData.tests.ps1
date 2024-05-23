Describe 'Get-MultipartFormData' -Tag Get-MultipartFormData {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Get-MultipartFormData -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('FilePath') | Should -Be $true
        $actual.Parameters.Keys.Contains('Purpose') | Should -Be $true

        $actual.Parameters['FilePath'].Attributes.Mandatory | Should -Be $true
        $actual.Parameters['Purpose'].Attributes.Mandatory | Should -Be $true

        $validateset = $actual.Parameters['Purpose'].Attributes.ValidValues
        $validateset | Should -Be @('fine-tune', 'assistants', 'vision')
    }
}