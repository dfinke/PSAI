<#
Create image
POST
 
https://api.openai.com/v1/images/generations

Creates an image given a prompt.

Request body
prompt
string

Required
A text description of the desired image(s). The maximum length is 1000 characters for dall-e-2 and 4000 characters for dall-e-3.

model
string

Optional
Defaults to dall-e-2
The model to use for image generation.

n
integer or null

Optional
Defaults to 1
The number of images to generate. Must be between 1 and 10. For dall-e-3, only n=1 is supported.

quality
string

Optional
Defaults to standard
The quality of the image that will be generated. hd creates images with finer details and greater consistency across the image. This param is only supported for dall-e-3.

response_format
string or null

Optional
Defaults to url
The format in which the generated images are returned. Must be one of url or b64_json. URLs are only valid for 60 minutes after the image has been generated.

size
string or null

Optional
Defaults to 1024x1024
The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024 for dall-e-2. Must be one of 1024x1024, 1792x1024, or 1024x1792 for dall-e-3 models.

style
string or null

Optional
Defaults to vivid
The style of the generated images. Must be one of vivid or natural. Vivid causes the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce more natural, less hyper-real looking images. This param is only supported for dall-e-3.

user
string

Optional
A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. Learn more.

Returns
Returns a list of image objects.
#>

<#
.SYNOPSIS
Generates an image using the OpenAI API.

.DESCRIPTION
The Get-OAIImageGeneration function generates an image using the OpenAI API by sending a POST request to the '/images/generations' endpoint. It allows you to specify various parameters such as the prompt, model, number of generations, quality, response format, size, style, and user.

.PARAMETER Prompt
Specifies the prompt for generating the image. This parameter is mandatory.

.PARAMETER Model
Specifies the model to use for generating the image. If not specified, the default model will be used.

.PARAMETER N
The number of images to generate. Must be between 1 and 10. For dall-e-3, only n=1 is supported.

.PARAMETER Quality
The quality of the image that will be generated. hd creates images with finer details and greater consistency across the image. This param is only supported for dall-e-3.

.PARAMETER ResponseFormat
The format in which the generated images are returned. Must be one of url or b64_json. URLs are only valid for 60 minutes after the image has been generated.

.PARAMETER Size
The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024 for dall-e-2. Must be one of 1024x1024, 1792x1024, or 1024x1792 for dall-e-3 models.

.PARAMETER Style
The style of the generated images. Must be one of vivid or natural. Vivid causes the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce more natural, less hyper-real looking images. This param is only supported for dall-e-3.

.PARAMETER User
Specifies the user for generating the image. If not specified, the default user will be used.

.EXAMPLE
PS> Get-OAIImageGeneration -Prompt "Generate a beautiful landscape image"

Generates an image using the default parameters and the specified prompt.

.EXAMPLE
PS> Get-OAIImageGeneration -Prompt "Generate a cute cat image" -Model "cat-v1" -N 5 -Quality "high" -ResponseFormat "json"

Generates 5 high-quality cat images in JSON format using the specified prompt and model.

.LINK
https://platform.openai.com/docs/api-reference/images/create
#>

function Get-OAIImageGeneration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Prompt,
        [ValidateSet('dall-e-2', 'dall-e-3')]
        $Model,
        $N,
        $Quality,
        [ValidateSet('url', 'b64_json')] 
        $ResponseFormat,
        $Size,
        $Style,
        $User,
        [Switch]$Show
    )

    $body = @{'prompt' = $Prompt }
    
    if ($null -ne $Model) { 
        $body['model'] = $Model 
    }

    if ($null -ne $N) { 
        $body['n'] = $N 
    }

    if ($null -ne $Quality) { 
        $body['quality'] = $Quality 
    }

    if ($null -ne $ResponseFormat) { 
        $body['response_format'] = $ResponseFormat 
    }

    if ($null -ne $Size) { 
        $body['size'] = $Size 
    }

    if ($null -ne $Style) { 
        $body['style'] = $Style 
    }

    if ($null -ne $User) { 
        $body['user'] = $User 
    }

    $url = $baseUrl + '/images/generations'
    $Method = 'POST'

    $response = Invoke-OAIBeta -Uri $url -Method $Method -Body $body

    if ($Show) {
        Start-Process $response.data.url
    }

    $response
}