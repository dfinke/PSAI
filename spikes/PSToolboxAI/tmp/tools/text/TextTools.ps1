<#
.SYNOPSIS
Text processing toolbox for PSAI agents.

.DESCRIPTION
Provides text processing operations as tools for AI agents.
Tools include: counting words, converting case, searching text.

.NOTES
This toolbox is automatically discovered when $env:PSAI_TOOLBOX_PATH is set
or when using the default toolbox path.
#>

function TextTools {
    [CmdletBinding()]
    param()
    
    # Check if we should register tools based on environment variable
    if ($env:PSAI_ENABLE_TOOLBOX -eq $false) {
        Write-Verbose "Toolbox registration skipped (PSAI_ENABLE_TOOLBOX is false)"
        return @()
    }
    
    Write-Verbose "Registering Text toolbox tools"
    
    # Register the tools using PSAI's Register-Tool function
    $tools = @(
        Register-Tool -FunctionName Get-TextStatistics
        Register-Tool -FunctionName Convert-TextCase
        Register-Tool -FunctionName Search-TextPattern
    )
    
    return $tools
}

<#
.SYNOPSIS
Gets statistics about text content.

.DESCRIPTION
Analyzes text and returns statistics like word count, character count, line count, etc.

.PARAMETER Text
The text to analyze.

.EXAMPLE
Get-TextStatistics -Text "Hello world! This is a test."
Returns statistics about the text.
#>
function Get-TextStatistics {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text
    )
    
    try {
        $lines = $Text -split "`n"
        $words = $Text -split '\s+' | Where-Object { $_ -ne '' }
        $sentences = $Text -split '[.!?]+' | Where-Object { $_ -match '\S' }
        
        $result = @{
            character_count = $Text.Length
            character_count_no_spaces = ($Text -replace '\s', '').Length
            word_count = $words.Count
            line_count = $lines.Count
            sentence_count = $sentences.Count
            average_word_length = if ($words.Count -gt 0) { 
                [math]::Round(($words | ForEach-Object { $_.Length } | Measure-Object -Average).Average, 2)
            } else { 0 }
            average_words_per_sentence = if ($sentences.Count -gt 0) {
                [math]::Round($words.Count / $sentences.Count, 2)
            } else { 0 }
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Converts text case.

.DESCRIPTION
Converts text to various cases: upper, lower, title, or sentence case.

.PARAMETER Text
The text to convert.

.PARAMETER Case
The target case: Upper, Lower, Title, or Sentence.

.EXAMPLE
Convert-TextCase -Text "hello world" -Case Title
Converts to "Hello World".
#>
function Convert-TextCase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        
        [Parameter(Mandatory)]
        [ValidateSet('Upper', 'Lower', 'Title', 'Sentence')]
        [string]$Case
    )
    
    try {
        $converted = switch ($Case) {
            'Upper' {
                $Text.ToUpper()
            }
            'Lower' {
                $Text.ToLower()
            }
            'Title' {
                (Get-Culture).TextInfo.ToTitleCase($Text.ToLower())
            }
            'Sentence' {
                if ($Text.Length -gt 0) {
                    $Text.Substring(0, 1).ToUpper() + $Text.Substring(1).ToLower()
                } else {
                    $Text
                }
            }
        }
        
        $result = @{
            original = $Text
            case_type = $Case
            converted = $converted
        }
        
        return ($result | ConvertTo-Json -Depth 2 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            text = $Text
        } | ConvertTo-Json -Compress)
    }
}

<#
.SYNOPSIS
Searches for a pattern in text.

.DESCRIPTION
Searches for a regular expression pattern in text and returns matches.

.PARAMETER Text
The text to search.

.PARAMETER Pattern
The regex pattern to search for.

.PARAMETER CaseSensitive
If specified, search is case-sensitive.

.EXAMPLE
Search-TextPattern -Text "Hello world 123" -Pattern "\d+"
Finds all numeric sequences in the text.
#>
function Search-TextPattern {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        
        [Parameter(Mandatory)]
        [string]$Pattern,
        
        [Parameter()]
        [switch]$CaseSensitive
    )
    
    try {
        $options = [System.Text.RegularExpressions.RegexOptions]::None
        if (-not $CaseSensitive) {
            $options = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        }
        
        $matches = [regex]::Matches($Text, $Pattern, $options)
        
        $matchResults = @()
        foreach ($match in $matches) {
            $matchResults += @{
                value = $match.Value
                index = $match.Index
                length = $match.Length
            }
        }
        
        $result = @{
            pattern = $Pattern
            case_sensitive = $CaseSensitive.IsPresent
            match_count = $matches.Count
            matches = $matchResults
        }
        
        return ($result | ConvertTo-Json -Depth 3 -Compress)
    }
    catch {
        return (@{
            error = $_.Exception.Message
            pattern = $Pattern
        } | ConvertTo-Json -Compress)
    }
}

# Return the toolbox registration function
return TextTools
