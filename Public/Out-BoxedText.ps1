function Out-BoxedText {
    <#
    .SYNOPSIS
    Displays text inside a boxed frame with optional title.

    .DESCRIPTION
    This function displays the provided text inside a boxed frame with an optional title. 
    The box and title are displayed in the specified box color, while the text is displayed in the specified text color.

    .PARAMETER Text
    The text to be displayed inside the box.

    .PARAMETER Title
    The optional title to be displayed at the top of the box.

    .PARAMETER BoxColor
    The color of the box and title. Default is White.

    .PARAMETER TextColor
    The color of the text inside the box. Default is DarkGray.

    .EXAMPLE
    Out-BoxedText -Text "Paris" -Title "Agent" -BoxColor DarkBlue -TextColor White

    .EXAMPLE
    Out-BoxedText -Text "Follow up, Enter to copy & quit, Ctrl+C to quit." -Title "Next Steps" -BoxColor Cyan -TextColor Yellow

    .EXAMPLE
    Out-BoxedText -Text "Copied to clipboard." -Title "Information" -BoxColor Green -TextColor Black
    #>

    param (
        [Parameter(Mandatory)]
        [string]$Text,
        [string]$Title,        
        [ConsoleColor]$BoxColor = "White",
        [ConsoleColor]$TextColor = "DarkGray"
    )

    $textMaxWidth = ($Text.Split("`n") | Measure-Object -Maximum -Property Length).Maximum + 4
    $titleMaxWidth = $Title.Length + 4
    $maxWidth = [math]::Max($textMaxWidth, $titleMaxWidth)
    $height = $Text.Split("`n").Count + 2

    Write-Host "╭" -NoNewline -ForegroundColor $BoxColor
    if ($Title) {
        Write-Host " $Title " -NoNewline -ForegroundColor $BoxColor
        Write-Host ("─" * ($maxWidth - $Title.Length - 4)) -NoNewline -ForegroundColor $BoxColor
    }
    else {
        Write-Host ("─" * ($maxWidth - 2)) -NoNewline -ForegroundColor $BoxColor
    }
    Write-Host "╮" -ForegroundColor $BoxColor
    foreach ($line in $Text.Split("`n")) {
        Write-Host "│" -NoNewline -ForegroundColor $BoxColor
        Write-Host " $line$(" " * ($maxWidth - $line.Length - 4)) " -NoNewline -ForegroundColor $TextColor
        Write-Host "│" -ForegroundColor $BoxColor
    }
    Write-Host "╰" -NoNewline -ForegroundColor $BoxColor
    Write-Host ("─" * ($maxWidth - 2)) -NoNewline -ForegroundColor $BoxColor
    Write-Host "╯" -ForegroundColor $BoxColor
}