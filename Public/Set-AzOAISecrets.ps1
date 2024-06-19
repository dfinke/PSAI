<#
.SYNOPSIS
Sets the Azure OAI secrets.

.DESCRIPTION
This function sets the Azure OAI (OpenAPI Service) secrets by storing the provided values in the script scope.

.PARAMETER apiURI
The URI of the Azure OAI.

.PARAMETER apiKEY
The API key for accessing the Azure OAI.

.PARAMETER apiVersion
The version of the Azure OAI.

.PARAMETER deploymentName
The name of the deployment.

.EXAMPLE
Set-AzOAISecrets -apiURI "https://api.example.com" -apiKEY "myApiKey" -apiVersion "v1" -deploymentName "MyDeployment"
Sets the Azure OAI secrets with the specified values.

#>

function Set-AzOAISecrets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $apiURI,
        [Parameter(Mandatory)]
        $apiKEY,
        [Parameter(Mandatory)]
        $apiVersion,
        [Parameter(Mandatory)]
        $deploymentName
    )

    $script:AzOAISecrets['apiURI'] = $apiURI
    $script:AzOAISecrets['apiKEY'] = $apiKEY
    $script:AzOAISecrets['apiVersion'] = $apiVersion
    $script:AzOAISecrets['deploymentName'] = $deploymentName
}