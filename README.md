<p align="center">
    <img src="Media/PSAI.png" alt="drawing" width="200"/>
</p>

<p align="center">
  <a href="https://x.com/dfinke">
    <img src="https://img.shields.io/twitter/follow/dfinke.svg?style=social&label=Follow%20%40dfinke"></a>
  <a href="https://youtube.com/@dougfinke">
    <img src="https://img.shields.io/youtube/channel/subscribers/UCP47ZkO5EDkoI2sr-3P4ShQ"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/v/PSAI.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/dt/PSAI.svg"></a> 
</p>

<p align="center">
    • <a href="https://github.com/dfinke/PSAI/wiki">Documentation</a> •
</p>

# PSAI

Imagine empowering your PowerShell scripts with the intelligence of OpenAI. With PSAI, I’ve transformed how we interact with AI, making it as simple as running a command. PSAI bridges the gap between PowerShell and AI, enabling seamless integration for file searches, data analysis, and more. It's not just about automation; it's about revolutionizing what we can achieve with just a few lines of code. This module opens a world of possibilities, making AI accessible directly from your console and your scripts.

----

This release supports the latest OpenAI API changes.
Here's what's new:

- Improved retrieval tool called file_search, which can ingest up to 10,000 files per assistant - 500x more than before. It is faster, supports parallel queries through multi-threaded searches, and features enhanced reranking and query rewriting.
- Introducing vector_store objects in the API. Once a file is added to a vector store, it's automatically parsed, chunked, and embedded, made ready to be searched. Vector stores can be used across assistants and threads, simplifying file management and billing.
- Control the maximum number of tokens a run uses in the Assistants API, allowing you to manage token usage costs. 
- Set limits on the number of previous / recent messages used in each run.
- Supports the tool_choice parameter which can be used to force the use of a specific tool (like file_search, code_interpreter, or a function) in a particular run.
- Create messages with the role assistant to create custom conversation histories in Threads.
- Assistant and Run objects now support model configuration parameters like temperature, response_format (JSON mode), and top_p.

more to come ...

## Documentation

https://github.com/dfinke/PSAI/wiki

## Installation

```powershell
Install-Module -Name PSAI -Scope CurrentUser -Force 
```

## OpenAI API KEY

Get/Create your OpenAI API key from https://platform.openai.com/account/api-keys.

Then set `$env:OpenAIKey` to your key.

## Usage

The full set of functions can be found here https://github.com/dfinke/PSAI/wiki/

```powershell
Invoke-OAIChat 'How do I output all files in a directory PowerShell?'
```

### GPT Response

To output all files in a directory using PowerShell, you can use the `Get-ChildItem` cmdlet. Here's an example of how you can do it:


```powershell
Get-ChildItem -Path "C:\Path\To\Directory" -File
```

Replace `"C:\Path\To\Directory"` with the path to the directory whose files you want to output. This command will list only files in the specified directory.

If you want to list all files, including files in subdirectories, you can add the `-Recurse` parameter to `Get-ChildItem`:

```powershell
Get-ChildItem -Path "C:\Path\To\Directory" -File -Recurse
```

This command will recursively list all files in the specified directory and its subdirectories.

Run either of these commands in PowerShell to output all files in a directory.

## Support for Azure OpenAI 

After creating an [Azure OpenAI resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal), you can use the `PSAI` module to interact with it. 

You need to get the following secrets form the Azure Portal and Azure AI Studio - `apiURI`,`apiVersion`,`apiKey`,`deploymentName`.

```powershell
$secrets = @{
    apiURI         = "<Your Azure OpenAI API URI>"
    apiVersion     = "<Your Azure OpenAI API Version>"
    apiKey         = "<Your Azure OpenAI API Key>"
    deploymentName = "<Your Azure OpenAI Deployment Name>"
}

Set-OAIProvider AzureOpenAI
Set-AzOAISecrets @secrets
```
