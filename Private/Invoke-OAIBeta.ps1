<#
.SYNOPSIS
    Invokes an OpenAI API endpoint using the OpenAI-Beta header.

.DESCRIPTION
    The Invoke-OAIBeta function is used to send requests to an OpenAI API endpoint. It supports various parameters such as the URI, HTTP method, request body, content type, output file, and more.

.PARAMETER Uri
    Specifies the URI of the OpenAI API endpoint.

.PARAMETER Method
    Specifies the HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE).

.PARAMETER Body
    Specifies the request body to be sent with the API request.

.PARAMETER ContentType
    Specifies the content type of the request body. The default value is 'application/json'.

.PARAMETER OutFile
    Specifies the path to save the response content to a file.

.PARAMETER NotOpenAIBeta
    If specified, removes the 'OpenAI-Beta' header from the request.

.EXAMPLE
    Invoke-OAIBeta -Uri 'https://api.openai.com/v1/endpoint' -Method 'GET' -OutFile 'response.json'

    This example sends a GET request to the specified API endpoint and saves the response content to a file named 'response.json'.

#>
function Invoke-OAIBeta {
    [CmdletBinding()]
    param(
        $Uri,
        $Method,
        $Body,
        $ContentType = 'application/json',
        $OutFile,        
        [Switch]$NotOpenAIBeta        
    )        
    

    # $headers = @{
    #     'OpenAI-Beta'  = 'assistants=v2'    
    #     'Content-Type' = $ContentType
    # }

    # if ($NotOpenAIBeta) {
    #     $headers.Remove('OpenAI-Beta')
    # }

    # Get the correct model based on input and ProviderList
    # Make sure the Provider List exists
    $ProviderList = Get-AIProviderList

    # Get the OAI variables
    $OAIProvider = Get-OAIProvider
    $OAIApiKey = $env:OpenAIKey
    $AzOAISecrets = Get-AzOAISecrets
    $BodyModel = $Body['model']

    # If the Provider List is empty, try to create it
    if ($null -eq $ProviderList) {
        if ($null -ne $OAIApiKey) {
            $params = @{
                Provider = 'OpenAI'
                ApiKey   = $OAIApiKey | ConvertTo-SecureString -AsPlainText -Force
            }
            if ($null -ne $BodyModel) {
                $params['ModelNames'] = $BodyModel
            }
            Import-AIProvider @params
            continue
        }
        if ($null -ne $AzOAISecrets['apiKEY']) {
            $params = @{
                Provider      = 'AzureOpenAI'
                ApiKey        = $AzOAISecrets.apiKEY |ConvertTo-SecureString -AsPlainText -Force
                ModelNames = $AzOAISecrets.deploymentName
                BaseUri       = $AzOAISecrets.apiURI
            }
            Import-AIProvider @params
            continue
        }
        throw "No provider has been set up yet. Please read the instructions for the module to set up a provider."
    }
    


    # $Provider = Get-OAIProvider
    # $AzOAISecrets = Get-AzOAISecrets
    # switch ($Provider) {
    #     'OpenAI' {
    #         $headers['Authorization'] = "Bearer $env:OpenAIKey"
    #     }

    #     'AzureOpenAI' {
    #         $headers['api-key'] = "$($AzOAISecrets.apiKEY)"
            
    #         if ($Body -isnot [System.IO.Stream]) {
    #             if ($null -ne $Body -and $Body.Contains("model") ) {
    #                 $Body.model = $AzOAISecrets.deploymentName
    #             }
    #         }

    #         $Uri = $Uri -replace $baseUrl, ''
    #         if ($Uri.EndsWith('/')) {
    #             $Uri = $Uri.Substring(0, $Uri.Length - 1)
    #         }
            
    #         $separator = '?'
    #         if ($Uri.Contains('?')) {
    #             $separator = '&'
    #         }
    #         $Uri = "{0}/openai{1}{2}api-version={3}" -f $AzOAISecrets.apiURI, $Uri, $separator, $AzOAISecrets.apiVersion         
    #     }
    # }    

    # $params = @{
    #     Uri     = $Uri
    #     Method  = $Method
    #     Headers = $headers
    # }
    
    # if ($Body) {
    #     if ($Body -is [System.IO.Stream]) {
    #         $params['Body'] = $Body
    #     }
    #     else {
    #         $params['Body'] = $Body | ConvertTo-Json -Depth 10
    #     }
    # }

    # if ($OutFile) {
    #     $params['OutFile'] = $OutFile
    # }

    # Write-Verbose ($params | ConvertTo-Json -Depth 5)
    
    if (Test-IsUnitTestingEnabled) {
        Write-Host "Data saved. Use Get-UnitTestingData to retrieve the data."
        $script:InvokeOAIUnitTestingData = @{
            Uri           = $Uri
            Method        = $Method
            Headers       = $headers.Clone()
            Body          = $Body
            OAIProvider   = Get-OAIProvider            
            ContentType   = $ContentType
            OutFile       = $OutFile
            NotOpenAIBeta = $NotOpenAIBeta
        }        
        return
    }
    
    # Remove model from body - handled by modelobject
    $Body.Remove('model')
    # Get default providers default model.
    ## TODO implement model passing in all functions
    $model = Get-AIModel
    Write-Verbose "Using model: $($model.Name)"
    $Response = $model.Chat('',$true,$Body,@())
    if ($response.ResponseObject) {
        return $response.ResponseObject
    }
    throw $Response
}
