function Out-BoxedText {
    <#
    .SYNOPSIS
    Displays text inside a boxed frame with optional title.

    .DESCRIPTION
    This function displays the provided text inside a boxed frame with an optional title. 
    The box and title are displayed in the specified box color, while the text is displayed in the specified text color.
    
    It handles text wrapping to ensure the box is drawn correctly around the wrapped text.

    .PARAMETER Text
    The text to be displayed inside the box.

    .PARAMETER Title
    The optional title to be displayed at the top of the box.

    .PARAMETER BoxColor
    The color of the box and title. Default is White.

    .PARAMETER TextColor
    The color of the text inside the box. Default is Gray.

    .PARAMETER MaxWidth
    The maximum width for the text wrapping and box. Default is 80.

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
        [ConsoleColor]$TextColor = "Gray",
        [int]$MaxWidth = 80
    )

    function Wrap-Text {
        param (
            [string]$Text,
            [int]$Width
        )
        $wrappedLines = @()
        foreach ($line in $Text -split "`n") {
            while ($line.Length -gt $Width) {
                $wrappedLines += $line.Substring(0, $Width)
                $line = $line.Substring($Width)
            }
            $wrappedLines += $line
        }
        return $wrappedLines
    }

    $consoleWidth = $Host.UI.RawUI.WindowSize.Width
    $effectiveMaxWidth = [math]::Min($MaxWidth, $consoleWidth - 2)
    $wrappedText = Wrap-Text -Text $Text -Width ($effectiveMaxWidth - 4)
    $textMaxWidth = ($wrappedText | Measure-Object -Maximum -Property Length).Maximum + 4
    $titleMaxWidth = $Title.Length + 4
    $boxWidth = [math]::Min([math]::Max($textMaxWidth, $titleMaxWidth), $effectiveMaxWidth)
    $boxInnerWidth = $boxWidth - 4

    # Draw top border
    Write-Host "╭" -NoNewline -ForegroundColor $BoxColor
    if ($Title) {
        Write-Host " $Title " -NoNewline -ForegroundColor $BoxColor
        Write-Host ("─" * ($boxWidth - $Title.Length - 4)) -NoNewline -ForegroundColor $BoxColor
    }
    else {
        Write-Host ("─" * ($boxWidth - 2)) -NoNewline -ForegroundColor $BoxColor
    }
    Write-Host "╮" -ForegroundColor $BoxColor

    # Draw text lines
    foreach ($line in $wrappedText) {
        Write-Host "│" -NoNewline -ForegroundColor $BoxColor
        Write-Host " $line" -NoNewline -ForegroundColor $TextColor
        Write-Host (" " * ($boxInnerWidth - $line.Length)) -NoNewline -ForegroundColor $TextColor
        Write-Host " │" -ForegroundColor $BoxColor
    }

    # Draw bottom border
    Write-Host "╰" -NoNewline -ForegroundColor $BoxColor
    Write-Host ("─" * ($boxWidth - 2)) -NoNewline -ForegroundColor $BoxColor
    Write-Host "╯" -ForegroundColor $BoxColor
}
