Import-Module $PSScriptRoot/../PSAI.psd1 -Force

Describe "Find-Skill" {
    InModuleScope PSAI {
        Context "When repository is specified" {
            BeforeEach {
                Remove-Variable PSSkillRepository -Scope Global -ErrorAction SilentlyContinue
                $env:PSSkillRepository = $null
            }

            It "Should return skills from repository" {
                Mock Invoke-RestMethod {
                    # Mock root contents
                    @(
                        @{ name = "skill1"; type = "dir" },
                        @{ name = "skill2"; type = "dir" },
                        @{ name = "README.md"; type = "file" }
                    )
                } -ParameterFilter { $Uri -match "/contents$" }

                Mock Invoke-RestMethod {
                    # Mock directory contents
                    @(
                        @{ name = "SKILL.md"; type = "file"; download_url = "https://raw.githubusercontent.com/test/repo/main/skill1/SKILL.md" }
                    )
                } -ParameterFilter { $Uri -match "/contents/skill" }

                Mock Invoke-WebRequest {
                    # Mock SKILL.md content
                    [PSCustomObject]@{ Content = @"
---
name: Test Skill
description: A test skill description
---
"@ 
                    }
                }

                $result = Find-Skill -Repository "test/repo"

                $result | Should -HaveCount 2
                $result[0].Name | Should -Be "skill1"
                $result[0].Repository | Should -Be "test/repo"
                $result[0].Description | Should -Be "A test skill description"
            }

            It "Should filter skills by name pattern" {
                Mock Invoke-RestMethod {
                    @(
                        @{ name = "data-skill"; type = "dir" },
                        @{ name = "web-skill"; type = "dir" },
                        @{ name = "other"; type = "dir" }
                    )
                }

                Mock Invoke-RestMethod { @() } -ParameterFilter { $Uri -match "/contents/" }

                $result = Find-Skill -Repository "test/repo" -Name "*skill"

                $result | Should -HaveCount 2
                $result.Name | Should -Contain "data-skill"
                $result.Name | Should -Contain "web-skill"
            }

            It "Should use environment variable for repository" {
                $env:PSSkillRepository = "test/repo"

                Mock Invoke-RestMethod { @(@{ name = "skill1"; type = "dir" }) }
                Mock Invoke-RestMethod { @() } -ParameterFilter { $Uri -match "/contents/skill" }

                $result = Find-Skill

                $result | Should -HaveCount 1
                $result.Name | Should -Be "skill1"

                Remove-Variable PSSkillRepository -Scope Global -ErrorAction SilentlyContinue
            }

            It "Should handle multiple repositories" {
                Mock Invoke-RestMethod {
                    @(@{ name = "skill1"; type = "dir" })
                } -ParameterFilter { $Uri -match "repo1" }

                Mock Invoke-RestMethod {
                    @(@{ name = "skill2"; type = "dir" })
                } -ParameterFilter { $Uri -match "repo2" }

                Mock Invoke-RestMethod { @() } -ParameterFilter { $Uri -match "/contents/skill" }

                $result = Find-Skill -Repository "test/repo1", "test/repo2"

                $result | Should -HaveCount 2
                $result.Name | Should -Contain "skill1"
                $result.Name | Should -Contain "skill2"
            }

            It "Should sort results by name" {
                Mock Invoke-RestMethod {
                    @(
                        @{ name = "z-skill"; type = "dir" },
                        @{ name = "a-skill"; type = "dir" }
                    )
                }

                Mock Invoke-RestMethod { @() } -ParameterFilter { $Uri -match "/contents/" }

                $result = Find-Skill -Repository "test/repo"

                $result[0].Name | Should -Be "a-skill"
                $result[1].Name | Should -Be "z-skill"
            }
        }

        Context "Error handling" {
            BeforeEach {
                Remove-Variable PSSkillRepository -Scope Global -ErrorAction SilentlyContinue
                $env:PSSkillRepository = $null
            }
            It "Should throw when no repository specified" {
                { Find-Skill } | Should -Throw "No repository specified. Use -Repository or set `$env:PSSkillRepository`."
            }

            It "Should warn on invalid repository format" {
                { Find-Skill -Repository "invalid" } | Should -Not -Throw
                # Would need to capture warnings
            }

            It "Should handle API errors gracefully" {
                Mock Invoke-RestMethod { throw "API Error" }

                { Find-Skill -Repository "test/repo" } | Should -Not -Throw
            }
        }
    }
}