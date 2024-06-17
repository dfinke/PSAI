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
    
    $headers = @{
        'OpenAI-Beta'  = 'assistants=v1'     
        'Content-Type' = $ContentType
    }

    if ($NotOpenAIBeta) {
        $headers.Remove('OpenAI-Beta')
    }

    $Provider = Get-OAIProvider
    $AzOAISecrets = Get-AzOAISecrets
    switch ($Provider) {
        'OpenAI' {
            $headers['Authorization'] = "Bearer $env:OpenAIKey"
        }

        'AzureOpenAI' {
            $headers['api-key'] = "$($AzOAISecrets.apiKEY)"
            if ($Body -isnot [System.IO.Stream]) {
                if ($null -ne $Body -and $Body.Contains("model") ) {
                    $Body.model = $AzOAISecrets.deploymentName
                }
            }

            #$Uri = '{0}/openai/deployments/{1}/chat/completions?api-version={2}' -f $AzOAISecrets.apiURI.TrimEnd('/'), $AzOAISecrets.deploymentName, $AzOAISecrets.apiVersion        
            #$Uri = $Uri ?? '{0}/openai/assistants?api-version={1}' -f $AzOAISecrets.apiURI.TrimEnd('/'), $AzOAISecrets.apiVersion        
        }
    }    

    $params = @{
        Uri     = $Uri
        Method  = $Method
        Headers = $headers
    }
    
    if ($Body) {
        if ($Body -is [System.IO.Stream]) {
            $params['Body'] = $Body
        }
        else {
            $params['Body'] = $Body | ConvertTo-Json -Depth 10
        }
    }

    if ($OutFile) {
        $params['OutFile'] = $OutFile
    }
   

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

    try {
        Write-Verbose "Invoke-OAIBeta params:"
        $params |convertto-json |Write-Verbose
        Invoke-RestMethod @params
    } 
    catch {
        if ($Provider -eq 'OpenAI') {
            $message = $_.ErrorDetails.Message
            if (Test-JsonReplacement $message -ErrorAction SilentlyContinue) {            
                $targetError = $message | ConvertFrom-Json
                $targetError = $targetError.error.message
            } 
            else {
                $targetError = "[{0}] - {1}" -f $Uri, $message
            }
        }

        if ($Provider -eq 'AzureOpenAI') {
            $targetError = $_.Exception.Message
        }

        Write-Error $targetError
    }
}
