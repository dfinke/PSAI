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
    The maximum width for the text wrapping and box. Default is 120.

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
        [int]$MaxWidth = 120
    )

    function Get-VisibleLength {
        param ([string]$Text)
        # Remove ANSI escape sequences and other non-visible characters
        $cleanText = $Text -replace '\x1b\[[0-9;]*m', ''  # ANSI color codes
        $cleanText = $cleanText -replace '\x1b\[0m', ''   # Reset code
        $cleanText = $cleanText -replace '\x1b\[.*?m', '' # Other ANSI sequences
        return $cleanText.Length
    }

    function Wrap-Text {
        param (
            [string]$Text,
            [int]$Width
        )
        $wrappedLines = @()
        foreach ($line in $Text -split "`n") {
            while ((Get-VisibleLength -Text $line) -gt $Width) {
                # Find the break point based on visible length, not string length
                $visibleCount = 0
                $breakPoint = 0
                for ($i = 0; $i -lt $line.Length; $i++) {
                    $char = $line[$i]
                    # Check if character is visible (not part of ANSI sequence)
                    if ($char -match '[^\x1b\[\dm]') {
                        $visibleCount++
                    }
                    if ($visibleCount -ge $Width) {
                        $breakPoint = $i
                        break
                    }
                }
                if ($breakPoint -eq 0) { $breakPoint = $Width }
                $wrappedLines += $line.Substring(0, $breakPoint)
                $line = $line.Substring($breakPoint)
            }
            if ($line.Length -gt 0 -or $wrappedLines.Count -eq 0) {
                $wrappedLines += $line
            }
        }
        return $wrappedLines
    }

    $consoleWidth = $Host.UI.RawUI.WindowSize.Width
    $effectiveMaxWidth = [math]::Min($MaxWidth, $consoleWidth - 2)
    $availableWidth = $effectiveMaxWidth - 4  # Account for box borders and padding
    
    $wrappedText = Wrap-Text -Text $Text -Width $availableWidth
    
    # Calculate actual max width of wrapped text
    $maxVisibleLength = 0
    foreach ($line in $wrappedText) {
        $visLen = Get-VisibleLength -Text $line
        if ($visLen -gt $maxVisibleLength) {
            $maxVisibleLength = $visLen
        }
    }
    
    $textMaxWidth = $maxVisibleLength + 4
    $titleMaxWidth = $Title.Length + 4
    $boxWidth = [math]::Max($textMaxWidth, $titleMaxWidth)
    
    # Ensure box width doesn't exceed console
    if ($boxWidth -gt $effectiveMaxWidth) {
        $boxWidth = $effectiveMaxWidth
    }
    
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
        Write-Host "│ " -NoNewline -ForegroundColor $BoxColor
        Write-Host $line -NoNewline -ForegroundColor $TextColor
        $visibleLineLength = Get-VisibleLength -Text $line
        $padding = [math]::Max(0, $boxInnerWidth - $visibleLineLength)
        Write-Host (" " * $padding) -NoNewline -ForegroundColor $TextColor
        Write-Host " │" -ForegroundColor $BoxColor
    }

    # Draw bottom border
    Write-Host "╰" -NoNewline -ForegroundColor $BoxColor
    Write-Host ("─" * ($boxWidth - 2)) -NoNewline -ForegroundColor $BoxColor
    Write-Host "╯" -ForegroundColor $BoxColor
}
