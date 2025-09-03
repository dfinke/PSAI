Describe "New-Agent" -Tag New-Agent {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }
    It "should have these parameters" {
        $actual = Get-Command New-Agent -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Instructions'
        $keyArray[1] | Should -BeExactly 'Tools'
        $keyArray[2] | Should -BeExactly 'LLM'
        $keyArray[3] | Should -BeExactly 'Name'
        $keyArray[4] | Should -BeExactly 'Description'
        $keyArray[5] | Should -BeExactly 'ShowToolCalls'

        $actual.Parameters.ShowToolCalls.SwitchParameter | Should -Be $true
    }

    Context "InteractiveCLI Slash Commands" {
        
        It "should handle the /clear command by calling Clear-Host" {
            InModuleScope 'PSAI' {
                $mockAgent = New-Agent -Name "TestAgent"
                $global:callCount = 0
                $inputReader = { if ($global:callCount++ -eq 0) { '/clear' } else { '' } }
                Mock Clear-Host { }
                Mock Write-Host { }
                Mock Out-BoxedText { }
                Mock Out-Host { }
                InModuleScope 'PSAI' { Mock Set-Clipboard { } }
                $global:printResponseCallCount = 0
                $mockAgent | Add-Member -MemberType ScriptMethod -Name "PrintResponse" -Value { $global:printResponseCallCount++; 'Mocked response' } -Force
                
                # Act
                $mockAgent.InteractiveCLI($null, 'User', '😎', $inputReader)
                
                # Assert
                Assert-MockCalled Clear-Host -Exactly 1
                $global:printResponseCallCount | Should -Be 0
            }
        }
        
        It "should handle unknown slash commands by writing an error message" {
            InModuleScope 'PSAI' {
                $mockAgent = New-Agent -Name "TestAgent"
                $global:callCount = 0
                $inputReader = { if ($global:callCount++ -eq 0) { '/unknown' } else { '' } }
                Mock Clear-Host { }
                Mock Write-Host { }
                Mock Out-BoxedText { }
                Mock Out-Host { }
                InModuleScope 'PSAI' { Mock Set-Clipboard { } }
                $global:printResponseCallCount = 0
                $mockAgent | Add-Member -MemberType ScriptMethod -Name "PrintResponse" -Value { $global:printResponseCallCount++; 'Mocked response' } -Force
                
                # Act
                $mockAgent.InteractiveCLI($null, 'User', '😎', $inputReader)
                
                # Assert
                Assert-MockCalled Write-Host -Exactly 1 -ParameterFilter { $Object -eq 'Unknown command: /unknown' }
                $global:printResponseCallCount | Should -Be 0
            }
        }
        
        It "should handle empty input by copying to clipboard and exiting" {
            InModuleScope 'PSAI' {
                $mockAgent = New-Agent -Name "TestAgent"
                $inputReader = { '' }
                Mock Clear-Host { }
                Mock Write-Host { }
                Mock Out-BoxedText { }
                Mock Out-Host { }
                InModuleScope 'PSAI' { Mock Set-Clipboard { } }
                $global:printResponseCallCount = 0
                $mockAgent | Add-Member -MemberType ScriptMethod -Name "PrintResponse" -Value { $global:printResponseCallCount++; 'Mocked response' } -Force
                
                # Act
                $mockAgent.InteractiveCLI($null, 'User', '😎', $inputReader)
                
                # Assert
                InModuleScope 'PSAI' { Assert-MockCalled Set-Clipboard -Exactly 1 }
                Assert-MockCalled Out-BoxedText -Exactly 1
                $global:printResponseCallCount | Should -Be 0
            }
        }
        
        It "should handle normal messages by calling PrintResponse and displaying output" {
            InModuleScope 'PSAI' {
                $mockAgent = New-Agent -Name "TestAgent"
                $global:callCount = 0
                $inputReader = { if ($global:callCount++ -eq 0) { 'Hello' } else { '' } }
                Mock Clear-Host { }
                Mock Write-Host { }
                Mock Out-BoxedText { }
                Mock Out-Host { }
                InModuleScope 'PSAI' { Mock Set-Clipboard { } }
                $global:printResponseCallCount = 0
                $mockAgent | Add-Member -MemberType ScriptMethod -Name "PrintResponse" -Value { $global:printResponseCallCount++; 'Mocked response' } -Force
                
                # Act
                $mockAgent.InteractiveCLI($null, 'User', '😎', $inputReader)
                
                # Assert
                Assert-MockCalled Out-BoxedText -Exactly 3
                $global:printResponseCallCount | Should -Be 1
            }
        }
    }
}