function ConvertFrom-GPTMarkdownTable {
    <#
    .SYNOPSIS
        Converts a markdown table to a PowerShell object.

    .PARAMETER Markdown
        The markdown table to convert.
    .EXAMPLE
        ConvertFrom-GPTMarkdownTable -Markdown @'
        | Name | Value |
        | ---- | ----- |
        | foo  | bar   |
        | baz  | qux   |
        '@

    .EXAMPLE
        ai 'markdown table syntax' | ConvertFrom-GPTMarkdownTable        
    #>
    param(
        [Parameter(ValueFromPipeline)]
        $markdown
    )

    End {
        
        $lines = $markdown.Trim() -split "`n"

        $data = foreach ($line in $lines) {
            if ($line -match '[A-Za-z0-9]') {
                $line.Trim() -replace "^\|", "" -replace "\| ", "|" -replace " \|", "|"
            }
        }

        $data | ConvertFrom-Csv -Delimiter '|'
    }
}