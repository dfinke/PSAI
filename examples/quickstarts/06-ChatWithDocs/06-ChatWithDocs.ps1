. $PSScriptRoot\PSChatDocs.ps1

$pdfFiles = Get-ChildItem $PSScriptRoot *.pdf

$prompt = @'
please summarize the {0} attached PDF docs: {1}. 
please make 3 bullet points for each document
'@ -f $pdfFiles.Count, ($pdfFiles -join ', ')

Remove-Item $PSScriptRoot\PSChatDocs.md -ErrorAction SilentlyContinue

Measure-Command {
    PSChatDocs $prompt $PSScriptRoot\*.pdf | Set-Content $PSScriptRoot\PSChatDocs.md
}

Write-Host "Saved response to $PSScriptRoot\PSChatDocs.md" -ForegroundColor Cyan