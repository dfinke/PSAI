# BeforeAll {
#     $moduleRoot = Split-Path -Parent $PSScriptRoot
#     $functionPath = Join-Path $moduleRoot "Public/Arc/Test-PrefixMatch.ps1"
#     . $functionPath
# }

Describe "Test-PrefixMatch" -Tag Test-PrefixMatch {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    Context "Prefix matching with :*" {
        It "Returns true for matching prefix" {
            Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "get-content:*" | Should -Be $true
        }

        It "Returns true for prefix match with case-insensitive input" {
            Test-PrefixMatch -targetInput "GET-CONTENT -path C:\file.txt" -pattern "get-content:*" | Should -Be $true
        }

        It "Returns true for prefix match with case-insensitive pattern" {
            Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "GET-CONTENT:*" | Should -Be $true
        }

        It "Returns false for non-matching prefix" {
            Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "select-string:*" | Should -Be $false
        }

        It "Returns true for exact prefix match (no parameters)" {
            Test-PrefixMatch -targetInput "get-content" -pattern "get-content:*" | Should -Be $true
        }

        It "Returns false when targetInput is shorter than prefix" {
            Test-PrefixMatch -targetInput "get" -pattern "get-content:*" | Should -Be $false
        }

        It "Returns true for prefix match with special characters" {
            Test-PrefixMatch -targetInput "get-content:*:file.txt" -pattern "get-content:*" | Should -Be $true
        }
    }

    Context "Exact matching without :*" {
        It "Returns true for exact match" {
            Test-PrefixMatch -targetInput "get-date" -pattern "get-date" | Should -Be $true
        }

        It "Returns true for case-insensitive exact match" {
            Test-PrefixMatch -targetInput "GET-DATE" -pattern "get-date" | Should -Be $true
        }

        It "Returns true for case-insensitive exact match (mixed case)" {
            Test-PrefixMatch -targetInput "Get-Date" -pattern "GET-DATE" | Should -Be $true
        }

        It "Returns false for partial match" {
            Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "get-content" | Should -Be $false
        }

        It "Returns false for non-matching exact match" {
            Test-PrefixMatch -targetInput "get-date" -pattern "get-content" | Should -Be $false
        }

        It "Returns false when targetInput has more content" {
            Test-PrefixMatch -targetInput "get-date -uformat" -pattern "get-date" | Should -Be $false
        }

        It "Returns true for exact match with special characters" {
            Test-PrefixMatch -targetInput "test-string:value" -pattern "test-string:value" | Should -Be $true
        }
    }

    Context "Empty and null values" {
        It "Returns false when both targetInput and pattern are empty" {
            Test-PrefixMatch -targetInput "" -pattern "" | Should -Be $false
        }

        It "Returns false when targetInput is empty and pattern is not" {
            Test-PrefixMatch -targetInput "" -pattern "get-content:*" | Should -Be $false
        }

        It "Returns false when pattern is empty and targetInput is not" {
            Test-PrefixMatch -targetInput "get-content" -pattern "" | Should -Be $false
        }

        It "Returns false when targetInput is null and pattern is not" {
            Test-PrefixMatch -targetInput $null -pattern "get-content:*" | Should -Be $false
        }

        It "Returns false when pattern is null and targetInput is not" {
            Test-PrefixMatch -targetInput "get-content" -pattern $null | Should -Be $false
        }
    }

    Context "Edge cases" {
        It "Returns true for pattern containing only :*" {
            Test-PrefixMatch -targetInput "anything" -pattern ":*" | Should -Be $true
        }

        It "Returns true for pattern containing only :* with empty targetInput (empty prefix matches)" {
            Test-PrefixMatch -targetInput "" -pattern ":*" | Should -Be $true
        }

        It "Returns true for single character prefix match" {
            Test-PrefixMatch -targetInput "abc" -pattern "a:*" | Should -Be $true
        }

        It "Returns true for single character exact match" {
            Test-PrefixMatch -targetInput "a" -pattern "a" | Should -Be $true
        }

        It "Returns false for single character mismatch" {
            Test-PrefixMatch -targetInput "a" -pattern "b" | Should -Be $false
        }

        It "Returns true for whitespace prefix matching" {
            Test-PrefixMatch -targetInput "test value" -pattern "test:*" | Should -Be $true
        }

        It "Returns false for whitespace-only targetInput against pattern" {
            Test-PrefixMatch -targetInput "   " -pattern "test:*" | Should -Be $false
        }

        It "Returns true for prefix with numbers" {
            Test-PrefixMatch -targetInput "cmd123 -param" -pattern "cmd123:*" | Should -Be $true
        }

        It "Returns true for exact match with numbers" {
            Test-PrefixMatch -targetInput "cmd123" -pattern "cmd123" | Should -Be $true
        }
    }

    Context "Real-world scenarios" {
        It "Matches PowerShell command with parameters (prefix)" {
            Test-PrefixMatch -targetInput "Get-Process -Name powershell" -pattern "get-process:*" | Should -Be $true
        }

        It "Does not match similar but different command" {
            Test-PrefixMatch -targetInput "Get-Process -Name powershell" -pattern "get-service:*" | Should -Be $false
        }

        It "Matches exact cmdlet name without parameters" {
            Test-PrefixMatch -targetInput "Remove-Item" -pattern "remove-item" | Should -Be $true
        }

        It "Does not match cmdlet with extra content for exact match" {
            Test-PrefixMatch -targetInput "Remove-Item -Path C:\temp" -pattern "remove-item" | Should -Be $false
        }

        It "Matches long command with complex parameters (prefix)" {
            Test-PrefixMatch -targetInput "Invoke-WebRequest -Uri 'https://api.example.com' -Method POST" -pattern "invoke-webrequest:*" | Should -Be $true
        }
    }
}
