---
name: File System
description: Provides functionality to interact with the file system, including reading, writing, and managing files and directories.
---

# File System

The File System skill provides functionality to interact with the file system.

## Commands

### List Files

Lists all files in a specified directory.

```
Get-ChildItem -Path <directory> -Filter <filter> 
```

### Read File

Reads the contents of a specified file.

```
Get-Content -Path <file>
```

### Write File

Writes content to a specified file.

```
Set-Content -Path <file> -Value <content>
```