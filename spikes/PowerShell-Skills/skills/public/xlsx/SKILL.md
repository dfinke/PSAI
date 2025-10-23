---
name: Read xlsx File
description: Read content from the an xlsx file.
---

# Read xlsx File

## Quick start

To read the xlsx file, use the `Import-Excel` cmdlet from the `ImportExcel` module. Here is a simple example:

```powershell
Write-Host "Using PowerShell Skill - xlsx" -ForegroundColor Green; Write-Host "Reading data from xlsx file..." -ForegroundColor Green
Import-Excel -Path $targetXLSXFile
```