<#
.SYNOPSIS
Outputs messages with roles and content.

.DESCRIPTION
The Out-OAIMessages function is used to output messages with roles and content. It accepts an array of messages and an optional switch parameter to exclude the header.

.PARAMETER Messages
Specifies the array of messages to be output.

.PARAMETER NoHeader
Specifies whether to exclude the header. By default, the header is included.

.EXAMPLE
$messages = @(
    [PSCustomObject]@{
        role = "Info"
        content = [PSCustomObject]@{
            text = [PSCustomObject]@{
                value = "This is an informational message."
            }
        }
    },
    [PSCustomObject]@{
        role = "Warning"
        content = [PSCustomObject]@{
            text = [PSCustomObject]@{
                value = "This is a warning message."
            }
        }
    }
)

Out-OAIMessages -Messages $messages

This example demonstrates how to use the Out-OAIMessages function to output messages.

#>
function Out-OAIMessages {
    [CmdletBinding()]
    param(
        $Messages,
        [Switch]$NoHeader
    )

    if(!$NoHeader) {
        Write-Host "# Messages"
    }

    foreach ($m in $Messages) {
        Write-Host "$($m.role): " -NoNewline -ForegroundColor Green
        Write-Host "$($m.content.text.value)"
    }
}
