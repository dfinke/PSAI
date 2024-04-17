Describe "Get-OpenAISpecDescriptions" -Tag Get-OpenAISpecDescriptions {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It 'Test if it Get-OpenAISpecDescriptions exists' {
        $actual = Get-Command Get-OpenAISpecDescriptions -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test if Get-OpenAISpecDescriptions has the correct parameters ' {
        $actual = Get-Command Get-OpenAISpecDescriptions -ErrorAction SilentlyContinue

        $actual.Parameters.ContainsKey('target') | Should -Be $true
    }

    It "Test returns null if no description is found" {
        $actual = Get-OpenAISpecDescriptions -target $null
        
        $actual | Should -Be $null
    }
 
    It 'Test if Get-OpenAISpecDescriptions returns the correct function description' {
        $testTarget = @"
function test {
    <#
       .FunctionDescription
       A function
    #>
}
"@

        $actual = Get-OpenAISpecDescriptions -target $testTarget

        $actual.FunctionDescription | Should -Be 'A function'
        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
    }

    It 'Test if Get-OpenAISpecDescriptions returns the correct function description with a variable' {
        $var = 'schema: {"a" : 1}}'
        $testTarget = @"
function test {
    <#
       .FunctionDescription
       A function $var
    #>
}
"@

        $actual = Get-OpenAISpecDescriptions -target $testTarget

        $actual.FunctionDescription | Should -Be ('A function ' + $var)
        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
    }

    It 'Test if Get-OpenAISpecDescriptions returns the correct parameter description' {
        $testTarget = @"
function test {
    <#
        .ParameterDescription param1
        A parameter
    #>
    param(
        [string]$param1
    )
"@

        $actual = Get-OpenAISpecDescriptions -target $testTarget

        $actual.FunctionDescription | Should -BeNullOrEmpty

        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
        $actual.ParameterDescription.Count | Should -Be 1
        $actual.ParameterDescription.ContainsKey('param1') | Should -Be $true
        $actual.ParameterDescription.param1 | Should -Be 'A parameter'    
    }

    It 'Test if Get-OpenAISpecDescriptions returns the correct parameter description with a variable' {
        $var = "should be in expand string"
        $var = '{"a" : 1}'
        $testTarget = @"
function test {
    <#
        .ParameterDescription param1
        A parameter $var
    #>
    param(
        [string]$param1
    )
}
"@

        $actual = Get-OpenAISpecDescriptions -target $testTarget

        $actual.FunctionDescription | Should -BeNullOrEmpty

        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
        $actual.ParameterDescription.Count | Should -Be 1
        $actual.ParameterDescription.ContainsKey('param1') | Should -Be $true
        $actual.ParameterDescription.param1 | Should -Be ('A parameter ' + $var)
    }

    It 'Test if Get-OpenAISpecDescriptions returns the correct parameter description for multiple parameters' {
        $testTarget = @"
function test {
    <#
        .ParameterDescription param1
        A parameter
        .ParameterDescription param2
        Another parameter
    #>
    param(
        [string]$param1,
        [string]$param2
    )
}
"@

        $actual = Get-OpenAISpecDescriptions -target $testTarget

        $actual.FunctionDescription | Should -BeNullOrEmpty

        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
        $actual.ParameterDescription.Count | Should -Be 2
        $actual.ParameterDescription.ContainsKey('param1') | Should -Be $true
        $actual.ParameterDescription.param1 | Should -Be 'A parameter'    
        $actual.ParameterDescription.ContainsKey('param2') | Should -Be $true
        $actual.ParameterDescription.param2 | Should -Be 'Another parameter'
    }

    It 'Test if Get-OpenAISpecDescriptions returns for function and parameter description' {
        $testTarget = @"
function test {
    <#
        .FunctionDescription
        A function
        .ParameterDescription param1
        A parameter
    #>
    param(
        [string]$param1
    )
}
"@
        $actual = Get-OpenAISpecDescriptions -target $testTarget
    
        $actual.FunctionDescription | Should -Be 'A function'
    
        $actual.ParameterDescription.GetType().Name | Should -Be 'HashTable'
        $actual.ParameterDescription.Count | Should -Be 1
        $actual.ParameterDescription.ContainsKey('param1') | Should -Be $true
        $actual.ParameterDescription.param1 | Should -Be 'A parameter'    
    }
}