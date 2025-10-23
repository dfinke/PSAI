---
name: Process Management
description: Retrieve and manage information about running processes. Use when working with system processes or monitoring applications.
---

# Process Management

## Quick start 

Use `Get-Process` to retrieve information about running processes:

```powershell
Get-Process
```

## Getting specific processes

Filter by process name:

```powershell
Get-Process -Name "pwsh"
Get-Process | Where-Object { $_.CPU -gt 100 }
```

## Process details

Get detailed information about a process:

```powershell
Get-Process -Name "pwsh" | Select-Object Id, ProcessName, CPU, WorkingSet, StartTime
```

## Stopping processes

To stop a process (use with caution):

```powershell
Stop-Process -Name "notepad" -Force
Stop-Process -Id 1234
```

## Best practices

- Always verify process name before stopping processes
- Use `-WhatIf` parameter to preview actions
- Check process ownership and permissions
- Be cautious with system processes
- Use `Get-Process` first to identify correct process before stopping
