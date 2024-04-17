<#
.SYNOPSIS
    Retrieves the OAI provider.

.DESCRIPTION
    This function retrieves the OAI provider.

.EXAMPLE
    Get-OAIProvider
#>
function Get-OAIProvider {
    [CmdletBinding()]
    $script:OAIProvider
}