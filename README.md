<p align="center">
    <img src="Media/PSAI.png" alt="drawing" width="200"/>
</p>

<p align="center">
    • <a href="https://github.com/dfinke/PSAI/wiki">Documentation</a> •

  <a href="https://x.com/dfinke">
    <img src="https://img.shields.io/twitter/follow/dfinke.svg?style=social&label=Follow%20%40dfinke"></a>
  <a href="https://youtube.com/@dougfinke">
    <img src="https://img.shields.io/youtube/channel/subscribers/UCP47ZkO5EDkoI2sr-3P4ShQ"></a>
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/v/PSAI.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/dt/PSAI.svg"></a>
    
</p>

# PSAI
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/v/PSAI.svg"></a>

The OpenAI PowerShell module provides convenient access to the OpenAI REST API from the console and from PowerShell scripts. The module includes type definitions for all request params and response fields.


## Installation

```powershell
Install-Module -Name PSAI -Scope CurrentUser -Force 
```

## Usage

> [!IMPORTANT]
> The SDK was rewritten in v1, which was released November 6th 2023. See the [v1 migration guide](https://github.com/openai/openai-python/discussions/742), which includes scripts to automatically update your code.

```powershell
New-OAICompletion 'How do I output all files in a directory PowerShell?'
```