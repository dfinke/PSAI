Describe "Test Set-AIKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $backup = Get-AIKeyInfo -AsHashTable
        $path = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        Remove-Item $path -ErrorAction SilentlyContinue
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
        $backup | ConvertTo-Json | Out-File $path
     }
}