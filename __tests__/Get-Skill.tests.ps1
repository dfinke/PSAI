Import-Module $PSScriptRoot/../PSAI.psd1 -Force

Describe "Get-Skill" {
    InModuleScope PSAI {
        Context "When getting installed skills" {
            It "Should return skills from Get-SkillFrontmatter" {
                Mock Get-SkillFrontmatter {
                    @(
                        [PSCustomObject]@{
                            name = "skill1"
                            description = "Description 1"
                            fullname = "C:\path\to\skill1"
                        },
                        [PSCustomObject]@{
                            name = "skill2"
                            description = "Description 2"
                            fullname = "C:\path\to\skill2"
                        }
                    )
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill

                $result | Should -HaveCount 2
                $result[0].Name | Should -Be "skill1"
                $result[0].Description | Should -Be "Description 1"
                $result[0].Fullname | Should -Be "C:\path\to\skill1"
            }

            It "Should filter skills by name pattern" {
                Mock Get-SkillFrontmatter {
                    @(
                        [PSCustomObject]@{
                            name = "data-skill"
                            description = "Data skill"
                            fullname = "C:\path\to\data-skill"
                        },
                        [PSCustomObject]@{
                            name = "web-skill"
                            description = "Web skill"
                            fullname = "C:\path\to\web-skill"
                        }
                    )
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill -Name "*skill"

                $result | Should -HaveCount 2
                $result.Name | Should -Contain "data-skill"
                $result.Name | Should -Contain "web-skill"
            }

            It "Should filter skills by specific name" {
                Mock Get-SkillFrontmatter {
                    @(
                        [PSCustomObject]@{
                            name = "skill1"
                            description = "Description 1"
                            fullname = "C:\path\to\skill1"
                        }
                    )
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill -Name "skill1"

                $result | Should -HaveCount 1
                $result.Name | Should -Be "skill1"
            }

            It "Should return empty when no skills match" {
                Mock Get-SkillFrontmatter {
                    @(
                        [PSCustomObject]@{
                            name = "skill1"
                            description = "Description 1"
                            fullname = "C:\path\to\skill1"
                        }
                    )
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill -Name "nonexistent"

                $result | Should -HaveCount 0
            }

            It "Should handle wildcard patterns" {
                Mock Get-SkillFrontmatter {
                    @(
                        [PSCustomObject]@{
                            name = "test-skill-1"
                            description = "Test skill 1"
                            fullname = "C:\path\to\test-skill-1"
                        },
                        [PSCustomObject]@{
                            name = "other-skill"
                            description = "Other skill"
                            fullname = "C:\path\to\other-skill"
                        }
                    )
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill -Name "test*"

                $result | Should -HaveCount 1
                $result.Name | Should -Be "test-skill-1"
            }
        }

        Context "Parameter validation" {
            It "Should accept Name parameter" {
                Mock Get-SkillFrontmatter { @() } -ParameterFilter { $AsPSCustomObject }

                { Get-Skill -Name "test" } | Should -Not -Throw
            }

            It "Should default Name to wildcard" {
                Mock Get-SkillFrontmatter {
                    @([PSCustomObject]@{ name = "skill1"; description = "desc"; fullname = "path" })
                } -ParameterFilter { $AsPSCustomObject }

                $result = Get-Skill

                $result | Should -HaveCount 1
            }
        }
    }
}