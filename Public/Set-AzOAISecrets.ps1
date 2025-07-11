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
The version of the Azure OAI in YYYY-MM-DD format.

.PARAMETER deploymentName
The name of the AI model deployment.

.PARAMETER organizationId
The organization ID associated with the Azure OAI. This parameter is optional.

.EXAMPLE
Set-AzOAISecrets -apiURI "https://api.example.com" -apiKEY "myApiKey" -apiVersion "2024-10-21" -deploymentName "MyDeployment"
Sets the Azure OAI secrets with the specified values.

.NOTES
See https://learn.microsoft.com/en-us/azure/ai-foundry/openai/reference for more information on Azure OpenAI API version
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
        $deploymentName,
        [Parameter(Mandatory=$false)]
        $organizationId = $null
    )

    $script:AzOAISecrets['apiURI'] = $apiURI
    $script:AzOAISecrets['apiKEY'] = $apiKEY
    $script:AzOAISecrets['apiVersion'] = $apiVersion
    $script:AzOAISecrets['deploymentName'] = $deploymentName
    $script:AzOAISecrets['organizationId'] = $organizationId
}