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
        $Body = [ordered]@{},
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

    # If the Provider List is empty, try to create it
    if ($null -eq $ProviderList) { New-ProviderListFromEnv }
    

    # The code below is still required to run 2 tests in the test suite
### START ###
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
### END ###
    # Write-Verbose ($params | ConvertTo-Json -Depth 5)
    
    $provider = Get-AIProvider |Select-Object -ExpandProperty Name
    if (Test-IsUnitTestingEnabled) {
        Write-Host "Data saved. Use Get-UnitTestingData to retrieve the data."
        $headers = @{
            'OpenAI-Beta'  = 'assistants=v2'
            'Content-Type' = 'application/json'
            }
        if ($provider -eq 'OpenAI') {
            $headers.Add('Authorization', 'Bearer ')
        }
        if ($provider -eq 'AzureOpenAI') {
            $headers.Add('api-key',(Get-AIProvider).GetApiKey())
        }
        $script:InvokeOAIUnitTestingData = @{
            Uri           = $Uri
            Method        = $Method
            Headers       = $headers.Clone() # @{
                # 'OpenAI-Beta'  = 'assistants=v2'
                # 'Content-Type' = 'application/json'
                # 'api-key'      = (Get-AIProvider).GetApiKey()
            #} # $headers.Clone()
            Body          = $Body
            OAIProvider   = Get-OAIProvider
            ContentType   = $ContentType
            OutFile       = $OutFile
            NotOpenAIBeta = $NotOpenAIBeta
        }        
        return
    }
    
    # Remove model from body - handled by modelobject
    try {$Body.Remove('model')} catch{} #MemoryStreams don't have a remove method
    # Get default providers default model.
    ## TODO implement model passing in all functions
    $model = Get-AIModel
    Write-Verbose "Using provider: $($model.Provider.Name)"
    Write-Verbose "Using model: $($model.Name)"
    $Response = $model.InvokeModel('', $true, $Body, @(), $Uri, $Method, $ContentType)
    if ($response.ResponseObject) {
        return $response.ResponseObject
    }
    throw $Response
}
