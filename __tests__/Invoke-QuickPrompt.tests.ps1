Describe 'Test Invoke-QuickPrompt' -Tag Invoke-QuickPrompt {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if it Invoke-QuickPrompt exists" {
        $actual = Get-Command Invoke-QuickPrompt -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }

    It "Test if it q alias exists" {
        $actual = Get-Command q -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty
    }
    
    Context "Parameter Tests" {
        BeforeAll {
            $command = Get-Command Invoke-QuickPrompt
            $parameters = $command.Parameters
        }

        It "Should have parameter 'targetPrompt'" {
            $parameters.ContainsKey('targetPrompt') | Should -Be $true
        }

        It "Should have parameter 'pipelineInput' with ValueFromPipeline attribute" {
            $parameters.ContainsKey('pipelineInput') | Should -Be $true
            $parameters['pipelineInput'].Attributes.ValueFromPipeline | Should -Be $true
        }

        It "Should have parameter 'Tools'" {
            $parameters.ContainsKey('Tools') | Should -Be $true
        }

        It "Should have switch parameter 'OutputOnly'" {
            $parameters.ContainsKey('OutputOnly') | Should -Be $true
            $parameters['OutputOnly'].SwitchParameter | Should -Be $true
        }

        It "Should have switch parameter 'ShowToolCalls'" {
            $parameters.ContainsKey('ShowToolCalls') | Should -Be $true
            $parameters['ShowToolCalls'].SwitchParameter | Should -Be $true
        }

        It "Parameters should be in the correct order" {
            $expectedOrder = @('targetPrompt', 'pipelineInput', 'Tools', 'OutputOnly', 'ShowToolCalls')
            $actualOrder = $command.Parameters.Keys | Where-Object { $expectedOrder -contains $_ } 
            for ($i = 0; $i -lt $expectedOrder.Count; $i++) {
                $actualOrder[$i] | Should -Be $expectedOrder[$i]
            }
        }
    }
}