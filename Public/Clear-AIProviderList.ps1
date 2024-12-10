<#
.SYNOPSIS
    Clear the AIProviderList

.DESCRIPTION
    This cmdlet clears the AIProviderList

.EXAMPLE
    Clear-AIProviderList

    This clears the AIProviderList
#>
function Clear-AIProviderList {
    $script:ProviderList = $null
}
