---
name: Write File
description: Write content to a file. Use when creating new files or updating existing file contents.
---

# Write File 

## Quick start 

Use `Set-Content` to write text to a file:

```powershell
Set-Content -Path "output.txt" -Value "Hello, World!"
```

## Appending to a file

To add content without overwriting:

```powershell
Add-Content -Path "output.txt" -Value "New line"
```

## Writing arrays

When writing arrays, each element becomes a line:

```powershell
$lines = @("Line 1", "Line 2", "Line 3")
Set-Content -Path "output.txt" -Value $lines
```

## Writing with encoding

Specify encoding for special characters:

```powershell
Set-Content -Path "output.txt" -Value "Content" -Encoding UTF8
```

## Best practices

- Use `Set-Content` to overwrite existing files
- Use `Add-Content` to append to files
- Always specify `-Path` explicitly for clarity
- Consider using `-Force` to create parent directories if needed
