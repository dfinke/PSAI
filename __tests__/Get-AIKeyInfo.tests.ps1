Describe "Test Set-AIKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $Profile = $env:USERPROFILE
        $TestPath = Join-Path $env:TEMP 'TestProfile'
        $env:USERPROFILE = $TestPath 
        New-Item -Path $env:USERPROFILE -ItemType Directory -Force | Out-Null
    }

    It "Get a list of 4 preconfigured AIKeyInfo PSCustomObjects" {
        $AIKeyInfo = Get-AIKeyInfo
        $AIKeyInfo | Should -BeOfType [PSCustomObject]
        $AIKeyInfo.Count | Should -Be 4
    }
    It "Get a list of 4 preconfigured AIKeyInfo HashTable" {
        $AIKeyInfo = Get-AIKeyInfo -AsHashTable
        $AIKeyInfo | Should -BeOfType [System.Collections.Hashtable]
        $AIKeyInfo.Count | Should -Be 4
    }

    AfterAll {
        $env:USERPROFILE = $Profile
        Remove-Item -Path $TestPath -Recurse -Force
    }
}