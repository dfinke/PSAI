Describe "Invoke-OAIChatCompletion" -Tag Invoke-OAIChatCompletion {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Invoke-OAIChatCompletion -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Messages'
        $keyArray[1] | Should -BeExactly 'Model'
        $keyArray[2] | Should -BeExactly 'Provider'
        $keyArray[3] | Should -BeExactly 'FrequencyPenalty'
        $keyArray[4] | Should -BeExactly 'LogitBias'
        $keyArray[5] | Should -BeExactly 'Logprobs'
        $keyArray[6] | Should -BeExactly 'TopLogprobs'
        $keyArray[7] | Should -BeExactly 'MaxTokens'
        $keyArray[8] | Should -BeExactly 'N'
        $keyArray[9] | Should -BeExactly 'PresencePenalty'
        $keyArray[10] | Should -BeExactly 'ResponseFormat'
        $keyArray[11] | Should -BeExactly 'Seed'
        $keyArray[12] | Should -BeExactly 'Stop'
        $keyArray[13] | Should -BeExactly 'Stream'
        $keyArray[14] | Should -BeExactly 'StreamOptions'
        $keyArray[15] | Should -BeExactly 'Temperature'
        $keyArray[16] | Should -BeExactly 'TopP'
        $keyArray[17] | Should -BeExactly 'Tools'
        $keyArray[18] | Should -BeExactly 'ToolChoice'
        $keyArray[19] | Should -BeExactly 'ParallelToolCalls'
        $keyArray[20] | Should -BeExactly 'User'

        $actual.Parameters.Messages.Attributes.Mandatory | Should -Be $true

        $validValues = $actual.Parameters['ResponseFormat'].Attributes.ValidValues
        $validValues | Should -Be @('auto', 'json', 'text')        
        
        $actual.Parameters.Temperature.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 2 '
        $actual.Parameters.TopP.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 1 '
        
        # check the data type of the parameter

        # $actual.Parameters.Messages.Attributes.ParameterType.FullName | Should -Be 'System.Object'
    }
}