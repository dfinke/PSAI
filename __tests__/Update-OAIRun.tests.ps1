Describe "Update-OAIRun" -Tag Update-OAIRun {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Update-OAIRun -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'ThreadId'
        $keyArray[1] | Should -BeExactly 'RunId'

        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases | Should -Be 'thread_id'

        $actual.Parameters.RunId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.RunId.Aliases.Count | Should -Be 1
        $actual.Parameters.RunId.Aliases | Should -Be 'run_id'
    }
}