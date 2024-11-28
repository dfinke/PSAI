

$agentParams = @{
    Instructions = @"
    You help users find images of Music Albums on the internet and download them to a folder.
    Ensure the filename is formatted BandName-AlbumName. Use the file extension from the link image.
    Images are usually in JPG, PNG, or GIF format hidden in the webpage content.
    Most albums can be found on https://www.metal-archives.com/ by looking up the BAND_NAME and ALBUM_TITLE like this:
    https://www.metal-archives.com/albums/BAND_NAME/ALBUM_TITLE
"@
    Tools        = @("Import-WebImage", "Invoke-WebSearch", "Get-WebScrape")
    ShowToolCalls = $true
}

$agent = New-Agent @agentParams

$agent | Get-AgentResponse "Please find 10 extreme metal band album covers and save them in C:\temp\TestData" 