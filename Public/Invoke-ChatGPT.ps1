<#
.SYNOPSIS
Invokes the ChatGPT model to generate responses based on user input and instructions.

.DESCRIPTION
The Invoke-ChatGPT function is used to interact with the ChatGPT model. It takes user input and instructions as parameters and generates responses using the specified model.

.PARAMETER UserInput
Specifies the user input to be used as the initial prompt for the model.

.PARAMETER Instructions
Specifies additional instructions to guide the model's response. This parameter supports pipeline input.

.PARAMETER Model
Specifies the model to be used for generating responses. The default value is 'gpt-4o-mini'.

.EXAMPLE
PS C:\> Invoke-ChatGPT -UserInput "Hello, how are you?" -Instructions "Please provide me with some information about yourself."

This example demonstrates how to use the Invoke-ChatGPT function to generate a response based on the user input and instructions provided.

.INPUTS
[System.String]
The UserInput parameter accepts a string value representing the user input.

[System.String]
The Instructions parameter accepts a string value representing additional instructions.

.OUTPUTS
[System.String]
The function returns a string value representing the generated response from the ChatGPT model.

.NOTES
This function requires the Invoke-OAIChat function to be available.

.LINK
Invoke-OAIChat
#>
function Invoke-ChatGPT {
    [Alias('ChatGPT')]
    [CmdletBinding()]
    param (
        $UserInput,
        [Parameter(ValueFromPipeline)]
        $Instructions,
        $Model = 'gpt-4o-mini'
    )

    Begin {
        $targetData = @()
    }

    Process {
        $targetData += $Instructions
    }

    End {
        Invoke-OAIChat -UserInput $UserInput -Instructions ($targetData -join "`n") -Model $Model 
    }
}