function Out-BoxedText {
    <#
    .SYNOPSIS
    Displays text inside a boxed frame with optional title.

    .DESCRIPTION
    This function displays the provided text inside a boxed frame with an optional title. 
    The box and title are displayed in the specified foreground color, while the text is displayed in dark gray.

    .PARAMETER Text
    The text to be displayed inside the box.

    .PARAMETER Title
    The optional title to be displayed at the top of the box.

    .PARAMETER ForegroundColor
    The color of the box and title. Default is White.

    .EXAMPLE
    Out-BoxedText -Text "Paris" -Title "Agent" -ForegroundColor DarkBlue

    .EXAMPLE
    Out-BoxedText -Text "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -ForegroundColor Cyan

    .EXAMPLE
    Out-BoxedText -Text "Copied to clipboard." -Title "Information" -ForegroundColor Green
    #>

    param (
        [Parameter(Mandatory)]
        [string]$Text,
        [string]$Title,        
        [ConsoleColor]$ForegroundColor = "White"
    )

    $textMaxWidth = ($Text.Split("`n") | Measure-Object -Maximum -Property Length).Maximum + 4
    $titleMaxWidth = $Title.Length + 4
    $maxWidth = [math]::Max($textMaxWidth, $titleMaxWidth)
    $height = $Text.Split("`n").Count + 2

    Write-Host "╭" -NoNewline -ForegroundColor $ForegroundColor
    if ($Title) {
        Write-Host " $Title " -NoNewline -ForegroundColor $ForegroundColor
        Write-Host ("─" * ($maxWidth - $Title.Length - 4)) -NoNewline -ForegroundColor $ForegroundColor
    }
    else {
        Write-Host ("─" * ($maxWidth - 2)) -NoNewline -ForegroundColor $ForegroundColor
    }
    Write-Host "╮" -ForegroundColor $ForegroundColor
    foreach ($line in $Text.Split("`n")) {
        Write-Host "│" -NoNewline -ForegroundColor $ForegroundColor
        Write-Host " $line$(" " * ($maxWidth - $line.Length - 4)) " -NoNewline -ForegroundColor DarkGray
        Write-Host "│" -ForegroundColor $ForegroundColor
    }
    Write-Host "╰" -NoNewline -ForegroundColor $ForegroundColor
    Write-Host ("─" * ($maxWidth - 2)) -NoNewline -ForegroundColor $ForegroundColor
    Write-Host "╯" -ForegroundColor $ForegroundColor
}

Out-BoxedText -Text "Paris" -Title "Agent Response" -ForegroundColor DarkBlue
Out-BoxedText -Text "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -ForegroundColor Cyan
Out-BoxedText -Text "Copied to clipboard." -Title "Information" -ForegroundColor Green

# Format-SpectrePanel -Data "Copied to clipboard." -Title "Information" -Border "Rounded" -Color "Green"