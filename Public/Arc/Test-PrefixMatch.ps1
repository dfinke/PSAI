<#
.SYNOPSIS
Tests if a target input matches a given pattern using prefix or exact matching.

.DESCRIPTION
The Test-PrefixMatch function evaluates whether a target input string matches a specified pattern.
Patterns ending with ':*' are treated as prefix matches (case-insensitive), while other patterns
require exact matches (case-insensitive). This is useful for matching command patterns with optional
parameters or subcommands.

.PARAMETER targetInput
The string to test against the pattern. This is typically a command or command line input.

.PARAMETER pattern
The pattern to match against. Patterns ending with ':*' perform prefix matching on the substring
before ':*'. Other patterns require exact matches with the entire targetInput.

.EXAMPLE
Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "get-content:*"
Returns $true because "get-content" is a prefix match.

.EXAMPLE
Test-PrefixMatch -targetInput "get-date" -pattern "get-date"
Returns $true because of exact match (case-insensitive).

.EXAMPLE
Test-PrefixMatch -targetInput "get-content -path C:\file.txt" -pattern "select-string:*"
Returns $false because "get-content" does not match the prefix "select-string".

#>
function Test-PrefixMatch {
    param(
        [string]$targetInput,
        [string]$pattern
    )

    if([string]::IsNullOrEmpty($targetInput) -and [string]::IsNullOrEmpty($pattern)) {
        return $false
    }
    
    # Check if pattern ends with :*
    if ($pattern.EndsWith(':*')) {
        # Remove :* and use prefix match
        $prefix = $pattern.Substring(0, $pattern.Length - 2)
        # For :*, we match the prefix and anything that follows
        return $targetInput.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
    }
    else {
        # For exact patterns, require exact match (including trailing slash)
        return $targetInput.Equals($pattern, [System.StringComparison]::OrdinalIgnoreCase)
    }
}
