Describe "Get-ToolProperty" -Tag Get-ToolProperty {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if it Get-ToolProperty exists" {
        $actual = Get-Command Get-ToolProperty -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Parameter'

        $actual.Parameters['Parameter'].Attributes.Mandatory | Should -Be $true

        $actual.Parameters['Parameter'].Attributes.ValueFromPipeline | Should -Be $true
    }

    It "Tests returning a string type property" {
        function DoTest {
            param(
                [string]$name,
                [int]$age,
                [switch]$isHappy,
                [decimal]$money,
                [float]$float,
                [single]$single,                
                [bool]$bool,
                [string[]]$stringArray,
                [psobject]$targetObject,
                [object]$object,
                [object[]]$objectArray,
                [long]$long,
                [datetime]$date,
                [pscustomobject]$customObject,
                [System.Collections.ArrayList]$arrayList
            )
            Write-Host "Hello $name"
        }

        $CommandInfo = Get-Command DoTest
        $Command = $CommandInfo[0]
        $Parameters = $Command.ParameterSets[0].Parameters

        for ($i = 0; $i -lt $Parameters.Count; $i++) {
            $properties = Get-ToolProperty $Parameters[$i]

            switch ($i) {
                0 { $properties.type | Should -Be 'string' }
                1 { $properties.type | Should -Be 'number' }
                2 { $properties.type | Should -Be 'boolean' }
                3 { $properties.type | Should -Be 'number' }
                4 { $properties.type | Should -Be 'number' }
                5 { $properties.type | Should -Be 'number' }
                6 { $properties.type | Should -Be 'boolean' }
                7 { $properties.type | Should -Be 'array' }
                8 { $properties.type | Should -Be 'object' }
                9 { $properties.type | Should -Be 'object' }
                10 { $properties.type | Should -Be 'object' }
                11 { $properties.type | Should -Be 'number' }
                12 { $properties.type | Should -Be 'string' }
                13 { $properties.type | Should -Be 'object' }
                14 { $properties.type | Should -Be 'object' }
            }            
        }
    }

    # TODO: Needs to handle the datetime type
    It "Tests returning a datetime type property" {
        function DoTest {
            param(
                [datetime]$date
            )
            Write-Host "Hello $date"
        }

        $CommandInfo = Get-Command DoTest
        $Command = $CommandInfo[0]
        $Parameters = $Command.ParameterSets[0].Parameters

        $properties = Get-ToolProperty $Parameters[0]

        $properties.type | Should -Be 'string'
    }   

    It "Tests returning a string type property with valid values" {
        function DoTest {
            param(
                [ValidateSet('One', 'Two', 'Three')]
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $CommandInfo = Get-Command DoTest
        $Command = $CommandInfo[0]
        $Parameters = $Command.ParameterSets[0].Parameters

        $properties = Get-ToolProperty $Parameters[0]

        $properties.type | Should -Be 'string'
        $properties.enum | Should -Be @('One', 'Two', 'Three')
    }

    It "Tests returning a string type property with no help message" {
        function DoTest {
            param(
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $CommandInfo = Get-Command DoTest
        $Command = $CommandInfo[0]
        $Parameters = $Command.ParameterSets[0].Parameters

        $properties = Get-ToolProperty $Parameters[0]

        $properties.type | Should -Be 'string'
        $properties.description | Should -BeNullOrEmpty
    }

    It "Tests returning a string type property with a help message" {
        function DoTest {
            param(
                [Parameter(HelpMessage = "This is a person's name")]
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $CommandInfo = Get-Command DoTest
        $Command = $CommandInfo[0]
        $Parameters = $Command.ParameterSets[0].Parameters

        $properties = Get-ToolProperty $Parameters[0]

        $properties.type | Should -Be 'string'
        $properties.description | Should -BeExactly "This is a person's name"
    }
}