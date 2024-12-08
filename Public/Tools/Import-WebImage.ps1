<#
.SYNOPSIS
This function imports an image from a URL and saves it to a specified directory.

.DESCRIPTION
Given an url to an image in the form of a string, this function downloads the image and saves it to a specified directory with a specified name.

.PARAMETER Url
The image URL to download. Only HTTP and HTTPS URLs that point to an image file are supported. Make sure the URL is valid and points to an image file.

.PARAMETER outputDirectory
The directory to save the image to. The directory must exist and be writable.

.PARAMETER outputFileName


.EXAMPLE
Import-WebImage -Url "https://example.com/image.jpg" -OutputDirectory "C:\Images" -OutputFileName "image.jpg"

.NOTES
Additional information about the function, such as author, date, or version.

.INPUTS
Types of objects that can be piped to the function.

.OUTPUTS
Nothing if the operation is successful. If the operation fails, an error message is displayed.

#>

function Import-WebImage {
    param(
        [parameter(Mandatory, HelpMessage = "The URL of the image to download. Only HTTP and HTTPS URLs that point to an image file are supported.")]
        [string]$url,
        [parameter(Mandatory, HelpMessage = "The directory to save the image to.")]
        [string]$outputDirectory,
        [parameter(Mandatory, HelpMessage = "The name of the output file.")]
        [string]$outputFileName
    )

    try {
        Invoke-WebRequest -Uri $url -OutFile "$outputDirectory\$outputFileName"
    } catch { Write-Output $($Error[0] | Out-String) }
}