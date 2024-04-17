Describe 'New-OAIMessage' -Tag New-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIMessage -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
        $actual.Parameters['ThreadId'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters['ThreadId'].Aliases.Count | Should -Be 1
        $actual.Parameters['ThreadId'].Aliases | Should -Be @('Id')
        
        $actual.Parameters.Keys.Contains('Role') | Should -Be $true
        $actual.Parameters['Role'].Attributes.Mandatory | Should -Be $true

        $actual.Parameters.Keys.Contains('Content') | Should -Be $true
        $actual.Parameters['Content'].Attributes.Mandatory | Should -Be $true

        $validateSet = $actual.Parameters.Role.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        $validateSet | Should -Not -BeNullOrEmpty
        $validateSet[0].ValidValues | Should -Be @('user')
        
        $actual.Parameters.Keys.Contains('FileIds') | Should -Be $true

        $actual.Parameters.Keys.Contains('Metadata') | Should -Be $true
    }
}