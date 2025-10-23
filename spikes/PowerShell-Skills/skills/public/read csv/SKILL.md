---
name: Read CSV File
description: Read content from a csv file.
---

# Read CSV File 
 
## Quick start 

To read the csv file, use the `Import-Csv` cmdlet in PowerShell. Here is a simple example:

```powershell
Write-Host "Using PowerShell Skill - Read CSV File" -ForegroundColor Green; Write-Host "Reading csv file..." -ForegroundColor Green
Import-Csv -Path $targetCSVFile
```