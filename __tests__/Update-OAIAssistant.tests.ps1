Describe 'Update-OAIAssistant' -Tag Update-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Update-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Id'
        $keyArray[1] | Should -BeExactly 'Model'
        $keyArray[2] | Should -BeExactly 'Name'
        $keyArray[3] | Should -BeExactly 'Description'
        $keyArray[4] | Should -BeExactly 'Instructions'
        $keyArray[5] | Should -BeExactly 'Tools'
        $keyArray[6] | Should -BeExactly 'ToolResources'
        $keyArray[7] | Should -BeExactly 'Metadata'
        $keyArray[8] | Should -BeExactly 'Temperature'
        $keyArray[9] | Should -BeExactly 'TopP'
        $keyArray[10] | Should -BeExactly 'ResponseFormat'
        
        $actual.Parameters['Id'].Attributes.ValueFromPipelineByPropertyName | Should -Be $true

        $actual.Parameters.Temperature.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 2 '
        $actual.Parameters.TopP.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 1 '

        $validValues = $actual.Parameters['ResponseFormat'].Attributes.ValidValues
        $validValues | Should -Be @('auto', 'json', 'text')
   }
}