Describe 'New-OAIMessage' -Tag New-OAIMessage {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIMessage -ErrorAction SilentlyContinue
        
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -Be 'ThreadId'
        $keyArray[1] | Should -Be 'Role'
        $keyArray[2] | Should -Be 'Content'
        $keyArray[3] | Should -Be 'Attachments'
        $keyArray[4] | Should -Be 'Metadata'

        # $actual.Parameters.Keys.Contains('ThreadId') | Should -Be $true
         $actual.Parameters['ThreadId'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true

         $actual.Parameters['ThreadId'].Aliases.Count | Should -Be 1
         $actual.Parameters['ThreadId'].Aliases | Should -Be @('Id')
 
         $validateSet = $actual.Parameters.Role.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
         $validateSet | Should -Not -BeNullOrEmpty
        
         $validateSet[0].ValidValues | Should -Be @('user', 'assistant')
    }
}