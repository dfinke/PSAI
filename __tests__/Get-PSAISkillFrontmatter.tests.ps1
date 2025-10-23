Describe "Get-PSAISkillFrontmatter" -Tag Get-PSAISkillFrontmatter {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        
        # Create a temporary skills directory for testing
        $script:testSkillsRoot = Join-Path $TestDrive "test-skills"
        New-Item -ItemType Directory -Path $script:testSkillsRoot -Force | Out-Null
        
        # Create a test skill
        $skill1Path = Join-Path $script:testSkillsRoot "read-file"
        New-Item -ItemType Directory -Path $skill1Path -Force | Out-Null
        
        $skill1Content = @"
---
name: Read File
description: Read content from a file and return it as text.
---

# Read File

## Quick start

Use ``Get-Content`` to read text from a file.
"@
        
        Set-Content -Path (Join-Path $skill1Path "SKILL.md") -Value $skill1Content
        
        # Create another test skill
        $skill2Path = Join-Path $script:testSkillsRoot "write-file"
        New-Item -ItemType Directory -Path $skill2Path -Force | Out-Null
        
        $skill2Content = @"
---
name: Write File
description: Write content to a file.
---

# Write File

## Quick start

Use ``Set-Content`` to write text to a file.
"@
        
        Set-Content -Path (Join-Path $skill2Path "SKILL.md") -Value $skill2Content
    }
    
    It "should have these parameters" {
        $actual = Get-Command Get-PSAISkillFrontmatter -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray | Should -Contain 'SkillsRoot'
        $keyArray | Should -Contain 'AsPSCustomObject'
        $keyArray | Should -Contain 'Compress'
        
        $actual.Parameters.AsPSCustomObject.SwitchParameter | Should -Be $true
        $actual.Parameters.Compress.SwitchParameter | Should -Be $true
    }
    
    It "should return JSON by default" {
        $result = Get-PSAISkillFrontmatter -SkillsRoot $script:testSkillsRoot
        
        $result | Should -Not -BeNullOrEmpty
        { $result | ConvertFrom-Json } | Should -Not -Throw
    }
    
    It "should return PSCustomObject when specified" {
        $result = Get-PSAISkillFrontmatter -SkillsRoot $script:testSkillsRoot -AsPSCustomObject
        
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [PSCustomObject]
        $result.Count | Should -Be 2
    }
    
    It "should extract skill name and description correctly" {
        $result = Get-PSAISkillFrontmatter -SkillsRoot $script:testSkillsRoot -AsPSCustomObject
        
        $readFileSkill = $result | Where-Object { $_.name -eq "Read File" }
        $readFileSkill | Should -Not -BeNullOrEmpty
        $readFileSkill.description | Should -Be "Read content from a file and return it as text."
        $readFileSkill.fullname | Should -Not -BeNullOrEmpty
        
        $writeFileSkill = $result | Where-Object { $_.name -eq "Write File" }
        $writeFileSkill | Should -Not -BeNullOrEmpty
        $writeFileSkill.description | Should -Be "Write content to a file."
    }
    
    It "should handle non-existent directory gracefully" {
        $result = Get-PSAISkillFrontmatter -SkillsRoot "C:\NonExistentPath\Skills" -AsPSCustomObject
        
        $result | Should -BeNullOrEmpty
    }
    
    It "should return compressed JSON when specified" {
        $compressed = Get-PSAISkillFrontmatter -SkillsRoot $script:testSkillsRoot -Compress
        $uncompressed = Get-PSAISkillFrontmatter -SkillsRoot $script:testSkillsRoot
        
        $compressed | Should -Not -BeNullOrEmpty
        $compressed.Length | Should -BeLessThan $uncompressed.Length
    }
}
