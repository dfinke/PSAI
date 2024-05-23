Describe 'New-OAIRun' -Tag New-OAIRun {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIRun -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'ThreadId'
        $keyArray[1] | Should -BeExactly 'AssistantId'
        $keyArray[2] | Should -BeExactly 'Model'
        $keyArray[3] | Should -BeExactly 'Instructions'
        $keyArray[4] | Should -BeExactly 'AdditionalInstructions'
        $keyArray[5] | Should -BeExactly 'AdditionalMessages'
        $keyArray[6] | Should -BeExactly 'Tools'
        $keyArray[7] | Should -BeExactly 'Metadata'
        $keyArray[8] | Should -BeExactly 'Temperature'
        $keyArray[9] | Should -BeExactly 'TopP'
        $keyArray[10] | Should -BeExactly 'Stream'
        $keyArray[11] | Should -BeExactly 'MaxPromptTokens'
        $keyArray[12] | Should -BeExactly 'MaxCompletionTokens'
        $keyArray[13] | Should -BeExactly 'TruncationStrategy'
        $keyArray[14] | Should -BeExactly 'ToolChoice'
        $keyArray[15] | Should -BeExactly 'ResponseFormat'

        
        $actual.Parameters.ThreadId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        $actual.Parameters.ThreadId.Aliases.Count | Should -Be 1
        $actual.Parameters.ThreadId.Aliases.Contains('thread_id') | Should -Be $true
               
        $actual.Parameters.AssistantId.Attributes.ValueFromPipelineByPropertyName | Should -Be $true
        # $actual.Parameters.AssistantId.Aliases.Count | Should -Be 1
        # $actual.Parameters.AssistantId.Aliases.Contains('id') | Should -Be $true

        # $actual.Parameters.Keys.Contains('Model') | Should -Be $true
        # # $ValidateSet = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
        # # $ValidateSet | Should -Not -BeNullOrEmpty

        # # $validValues = $actual.Parameters['model'].Attributes.ValidValues
        # # $validValues | Should -Be @('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106', 'gpt-4-turbo')

        # # $validateScript = $actual.Parameters.model.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateScriptAttribute] }
        # # $validateScript | Should -Not -BeNullOrEmpty
        # # $scriptBlock = $validateScript.ScriptBlock
        # # $scriptBlock.ToString().Trim() | Should -BeExactly 'Test-LLMModel'

        # $actual.Parameters.Keys.Contains('Instructions') | Should -Be $true
        # $actual.Parameters.Keys.Contains('Tools') | Should -Be $true
        # $actual.Parameters.Keys.Contains('Metadata') | Should -Be $true
    }
}