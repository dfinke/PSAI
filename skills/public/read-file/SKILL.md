---
name: Read File
description: Read content from a file and return it as text. Use when working with text files or when the user needs to view file contents.
---

# Read File 

## Quick start 

Use `Get-Content` to read text from a file:

```powershell
Get-Content -Path "input.txt"
```

## Reading specific lines

To read a specific range of lines:

```powershell
Get-Content -Path "input.txt" -TotalCount 10  # First 10 lines
Get-Content -Path "input.txt" -Tail 5         # Last 5 lines
```

## Reading as raw string

To read the entire file as a single string:

```powershell
Get-Content -Path "input.txt" -Raw
```

## Best practices

- Always check if the file exists before reading: `Test-Path -Path $filePath`
- Handle large files carefully to avoid memory issues
- Use `-ErrorAction` parameter for proper error handling
