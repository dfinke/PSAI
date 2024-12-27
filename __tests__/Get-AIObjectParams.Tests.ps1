BeforeAll {
    Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
}

Describe "Get-AIObjectParams" {
    It 'should have these parameters' {
        $actual = Get-Command Get-AIObjectParams -ErrorAction SilentlyContinue
        $keyArray = $actual.Parameters.Keys -as [array]
     
        $actual | Should -Not -BeNullOrEmpty
        $keyArray[0] | Should -BeExactly 'BoundParameters'
        $keyArray[1] | Should -BeExactly 'Exclude'
    }

    It "should return a hashtable with parameters excluding specified ones" {
        $params = @{
            Param1 = "Value1"
            Param2 = "Value2"
            Verbose = $true
            Debug = $false
        }
        $exclude = @("Param2")

        $result = Get-AIObjectParams -BoundParameters $params -Exclude $exclude

        $result.Keys | Should -Not -Contain "Param2"
        $result.Keys | Should -Not -Contain "Verbose"
        $result.Keys | Should -Not -Contain "Debug"
        $result["Param1"] | Should -Be "Value1"
    }

    It "should return an empty hashtable if all parameters are excluded" {
        $params = @{
            Param1 = "Value1"
            Param2 = "Value2"
        }
        $exclude = @("Param1", "Param2")

        $result = Get-AIObjectParams -BoundParameters $params -Exclude $exclude

        $result.Keys.Count | Should -Be 0
    }

    It "should return all parameters if no exclusions are specified" {
        $params = @{
            Param1 = "Value1"
            Param2 = "Value2"
        }
        $exclude = @()

        $result = Get-AIObjectParams -BoundParameters $params -Exclude $exclude

        $result.Keys | Should -Contain "Param1"
        $result.Keys | Should -Contain "Param2"
        $result["Param1"] | Should -Be "Value1"
        $result["Param2"] | Should -Be "Value2"
    }
}