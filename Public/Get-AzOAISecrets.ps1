<#
.SYNOPSIS
Retrieves the AzOAI secrets.

.DESCRIPTION
The Get-AzOAISecrets function retrieves the AzOAI secrets.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-AzOAISecrets
This example demonstrates how to use the Get-AzOAISecrets function to retrieve the AzOAI secrets.

#>

function Get-AzOAISecrets {
    $script:AzOAISecrets
}