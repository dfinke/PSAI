---
name: Data Management
description: Manage and manipulate data using PowerShell
---

# Data Management Skill
Reading CSV data and saving it to XLSX. Plus, when requested do data analytics as needed

## Commands

### Read location
Get the current working directory.

```powershell
Get-Location
```

### Read CSV

Read data from a CSV file.

```powershell
Import-Csv -Path "path\to\your\file.csv"
```

### Save to XLSX
Save data to an XLSX file.

```powershell
ConvertFrom-Json "jsonString" -Depth 3  | Export-Excel -Path "path\to\your\file.xlsx"
```

