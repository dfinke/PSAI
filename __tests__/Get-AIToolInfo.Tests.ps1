BeforeAll {
    Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
}
Describe "Get-AIToolInfo" {

    It 'should have these parameters' {
        $actual = Get-Command Get-AIToolInfo -ErrorAction SilentlyContinue
        $keyArray = $actual.Parameters.Keys -as [array]
        $actual | Should -Not -BeNullOrEmpty
        $keyArray[0] | Should -BeExactly 'CmdletName'
        $keyArray[1] | Should -BeExactly 'Strict'
        $keyArray[2] | Should -BeExactly 'ParameterSet'
        $keyArray[3] | Should -BeExactly 'ReturnJson'
        $keyArray[4] | Should -BeExactly 'ClearRequired'
    }


    # Mock Get-Command {
    #     return @{
    #         Name          = "Test-Cmdlet"
    #         ParameterSets = @(
    #             @{
    #                 Name       = "Default"
    #                 Parameters = @(
    #                     @{
    #                         Name          = "Param1"
    #                         ParameterType = [string]
    #                         IsMandatory   = $true
    #                         HelpMessage   = "Test parameter 1"
    #                     }
    #                 )
    #             }
    #         )
    #     }
    # }

    # Mock Get-Help {
    #     return @{
    #         description = @{
    #             text = "This is a test description that exceeds the maximum length of 1024 characters. " * 20
    #         }
    #     }
    # }

    # Mock Get-ToolProperty {
    #     param ($Parameter)
    #     return @{
    #         type = "string"
    #     }
    # }

    # It "Should truncate description to 1024 characters" {
    #     $result = Get-AIToolInfo -CmdletName "Test-Cmdlet" -ParameterSet 0
    #     $description = $result.function.description
    #     $description.Length | Should -Be 1024
    # }

    # It "Should not truncate description if it is less than 1024 characters" {
    #     Mock Get-Help {
    #         return @{
    #             description = @{
    #                 text = "This is a short description."
    #             }
    #         }
    #     }

    #     $result = Get-AIToolInfo -CmdletName "Test-Cmdlet" -ParameterSet 0
    #     $description = $result.function.description
    #     $description.Length | Should -BeLessThan 1025
    # }
}