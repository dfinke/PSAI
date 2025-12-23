Import-Module $PSScriptRoot/../PSAI.psd1 -Force

# Mock git command globally
function global:git { $global:LASTEXITCODE = 0 }

Describe "Install-Skill" {
    InModuleScope PSAI {
        BeforeEach {
            Mock Test-Path { $true } -ParameterFilter { $Path -match "temp" }
            Mock Remove-Item { }
            Mock New-Item { }
            Mock Copy-Item { }
            Mock Write-Host { }
            Mock Write-Error { }
        }

        Context "Successful installation" {
            It "Should handle CurrentUser scope" {
                Install-Skill -Name "skill1" -Repository "test/repo" -Scope CurrentUser
                Should -Invoke Copy-Item -ParameterFilter { $Destination -match [regex]::Escape("$HOME/.powershell/skills/") }
            }

            It "Should handle Workspace scope" {
                Install-Skill -Name "skill1" -Repository "test/repo" -Scope Workspace
                Should -Invoke Copy-Item -ParameterFilter { $Destination -match "\.github" }
            }

            It "Should handle Local scope" {
                Install-Skill -Name "skill1" -Repository "test/repo" -Scope Local
                Should -Invoke Copy-Item -ParameterFilter { $Destination -match "\.powershell" -and $Destination -notmatch [regex]::Escape($HOME) }
            }

            It "Should create installation directory if it doesn't exist" {
                Mock Test-Path { $false } -ParameterFilter { $Path -match "skills" }

                Install-Skill -Name "skill1" -Repository "test/repo"

                Should -Invoke New-Item -ParameterFilter { $ItemType -eq "Directory" }
            }

            It "Should remove existing skill directory before installing" {
                Mock Test-Path { $true } -ParameterFilter { $Path -match "skill1$" }

                Install-Skill -Name "skill1" -Repository "test/repo"

                Should -Invoke Remove-Item -ParameterFilter { $Recurse -and $Force }
            }

            It "Should handle pipeline input" {
                $skill = [PSCustomObject]@{
                    Name = "skill1"
                    Repository = "test/repo"
                }

                $skill | Install-Skill

                Should -Invoke Copy-Item
            }
        }

        Context "Error handling" {
            It "Should return early if Name is not provided" {
                { Install-Skill -Repository "test/repo" } | Should -Not -Throw
                Should -Not -Invoke Copy-Item
            }

            It "Should return early if Repository is not provided" {
                { Install-Skill -Name "skill1" } | Should -Not -Throw
                Should -Not -Invoke Copy-Item
            }

            It "Should handle missing skill directory after clone" {
                Mock Test-Path { $false } -ParameterFilter { $Path -match "skill1$" -and $Path -notmatch "dest" }

                { Install-Skill -Name "skill1" -Repository "test/repo" } | Should -Not -Throw
                # Should write error
            }
        }

        Context "Parameter validation" {
            It "Should validate Scope parameter" {
                { Install-Skill -Name "skill1" -Repository "test/repo" -Scope InvalidScope } | Should -Throw
            }

            It "Should accept valid scopes" {
                { Install-Skill -Name "skill1" -Repository "test/repo" -Scope CurrentUser } | Should -Not -Throw
                { Install-Skill -Name "skill1" -Repository "test/repo" -Scope Workspace } | Should -Not -Throw
                { Install-Skill -Name "skill1" -Repository "test/repo" -Scope Local } | Should -Not -Throw
            }

            It "Should default to CurrentUser scope" {
                Install-Skill -Name "skill1" -Repository "test/repo"

                Should -Invoke Copy-Item -ParameterFilter { $Destination -match [regex]::Escape("$HOME/.powershell/skills/") }
            }
        }

        Context "Cleanup" {
            It "Should clean up temporary directory" {
                Mock Test-Path { $true } -ParameterFilter { $Path -match "temp" }

                Install-Skill -Name "skill1" -Repository "test/repo"

                Should -Invoke Remove-Item -ParameterFilter { $Recurse -and $Force -and $Path -match "temp" }
            }
        }
    }
}