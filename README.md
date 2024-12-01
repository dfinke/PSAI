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

## Autonomous Agents

**PSAI** brings the power of autonomous agents to PowerShell, allowing you to seamlessly integrate AI capabilities into your scripts and terminal workflows. PSAI Agents enable you to build powerful, interactive tools that handle a variety of tasks, all powered by OpenAI's models. From quick calculations to detailed web searches, PSAI offers a flexible and intuitive way to create agents that can autonomously solve complex problems.

Think of PSAI Agents as digital Swiss Army knives—each agent is a specialized tool capable of running calculations, interacting with web services, fetching data, and executing multi-step tasks, all from within your PowerShell console.

Check out [What Are Autonomous Agents](#what-are-autonomous-agents) in this README for more information.

## Philosophy: Be the Automator, Not the Automated

PSAI and Agents embody the principle of "be the automator, not the automated." By giving you the tools to create sophisticated agents, PSAI empowers you to automate repetitive, data-driven tasks and allows you to focus on strategy and creativity.

----

## Installation

```powershell
Install-Module -Name PSAI
Import-Module PSAI
```

## Provider-Model list

PSAI uses a Provider-Model list for storing multiple providers and models. The first Provider to be imported, will be the default Provider for all calls, unless a specific other Provider is requested in the call.

Likewise, a Provider can have one or more models. The Model first imported to the Provider, will be set as the default Model and default model will be used in all calls, unless another specific model is requested by the cmdlet.

Both default Provider and Providers default Model can be changed after import.


## Importing Providers and Models

PSAI currently supports the following Providers:
* AIToolkit
* Anthropic
* AzureOpenAI
* Gemini
* Groq
* Ollama
* OpenAI

You can also write your own integrations to other Providers

Using the above providers usually require an API key and in some cases a baseUrl and specific model versions (Azure OpenAI) Others, usually the once running locally, do not require any additional information to be imported.

In the following, we assume that [Microsoft.PowerShell.SecretManagement](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.secretmanagement/?view=ps-modules) is installed and setup on your system. If not, you can supply the secrets in any other way you prefer.

<details>
<summary><h3>Importing OpenAI</h3></summary>

Get/Create your OpenAI API key from https://platform.openai.com/account/api-keys.

Import OpenAI and the default Model gpt-4o-mini like this

```powershell
$ApiKey = Get-Secret OpenAI # Or $ApiKey = "YourSecretKey" | ConvertTo-SecureString -AsPlainText -Force
$params = @{
    Provider = 'OpenAI'
    ApiKey   = $ApiKey
  }
Import-AIProvider @params
```

If you want other models to be available, just specify the models. First model will be the default:
```powershell
$params = @{
    Provider = 'OpenAI'
    ApiKey = Get-Secret OpenAI,
    ModelNames = 'gpt-4o', 'gpt-o1-mini'
  }
Import-AIProvider @params
```

Legacy settings are still supported for OpenAI. If you set `$env:OpenAIKey` to contain your clear test API key, the OpenAI provider will be loaded for you with the built-in default provider.
</details> 
<details>
<summary><h3>Importing Azure OpenAI</h3></summary>

After creating an [Azure OpenAI resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal), you can use the `PSAI` module to interact with it. 

You need to get the following secrets form the Azure Portal and Azure AI Studio - `apiURI`,`apiKey`,`deploymentName`.

```powershell
$DeploymentName = '<The name of your deployment>'
$params = @{
    Provider   = 'AzureOpenAI'
    BaseUri    = Get-Secret AzureOpenAIBaseUri -asPlainText
    ModelNames = $DeploymentName
    ApiKey     = Get-Secret AzureOpenAIKey
  }
Import-AIProvider @params
```

Legacy import is also supported:
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
</details>

<details>
<summary><h3>Importing AIToolkit</h3></summary>

AI Toolkit is a free plugin for VS Code. Once installed, you can try out the available local models. https://learn.microsoft.com/en-us/windows/ai/toolkit covers the required installation procedures.

API key is not required. Local models are free, but required reasonable specs on the system running the models.

```powershell
$params = @{
    Provider = 'AIToolkit'
  }
Import-AIProvider @params
```

The default model in AI Toolkit is "Phi-3-mini-4k-directml-int4-awq-block-128-onnx". Feel free totest any of the available local Models by utilizing the -ModelNames parameter
</details>

<details>
<summary><h3>Importing Anthropic</h3></summary>

Anthropic is another paid service. You can get an API key by signing up here: https://console.anthropic.com/ You will need to connect a credit card and deposit a small amount of $ to get started.

To Connect to Anthropic, run the following
```powershell
$params = @{
    Provider = 'Anthropic'
    ApiKey   = Get-Secret -Name AnthropicCAPI
  }
Import-AIProvider @params
```

The built-in default Model is "claude-3-5-sonnet-20240620", but you change or add other Models with the -ModelNames parameter
</details>

<details>
<summary><h3>Importing Gemini</h3></summary>

Gemini is another paid Provider. Setup an account here: https://ai.google.dev/ to get an API key. Google let's you start for free, but you have to connect with a google account with access to a credit card.

Connecting to Gemini:
```powershell
$params = @{
    Provider = 'Gemini'
    ApiKey   = Get-Secret -Name GeminiApiKey
  }
Import-AIProvider @params
```
The default Model is "gemini-1.5-flash" and other Models can be loaded with the -ModuleNames parameter
</details>

<details>
<summary><h3>Importing Groq</h3></summary>

You can get an API key for Groq by setting up an account here: https://console.groq.com/ You do not need to add a credit card at the moment.

Run the following to get started, once you have your API code setup:
```powershell
$params = @{
    Provider = 'Groq'
    ApiKey   = Get-Secret -Name GroqAPI
  }
Import-AIProvider @params
```

The default Model provided in the module is "llama3-8b-8192" Use -ModuleNames to add additional Models
</details>

<details>
<summary><h3>Importing Ollama</h3></summary>

Ollama lets you run LLMs on your own machine for free. All you need to do is install the binaries found here: https://ollama.com/ no API key is required.

Once you are setup, run this to get started:
```powershell
$params = @{
    Provider = 'Ollama'
  }
Import-AIProvider @params
```

2 Models are importet: "llama3.1" and "phi3:mini". This can be changed by using the -ModuleNames parameter
</details>

Custom Providers can be added to the module. Take a look in the Providers folder to see, how a Provider is crafted for the module.

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


## What Are Autonomous Agents?

Autonomous agents are AI-driven entities capable of making decisions and completing tasks without continuous human guidance. PSAI Agents combine the scripting power of PowerShell with the intelligence of OpenAI’s models to automate workflows that require both information processing and decision-making capabilities.

### Features of PSAI Agents
- **Modular Tools Integration**: Agents can leverage various specialized tools, such as:
  - **CalculatorTool**: Handles arithmetic and mathematical operations.
  - **WebSearchTool**: Retrieves information from the web.
  - **StockTickerTool**: Fetches stock information in real time.  

- **Customizable Agents**: Create agents that use predefined tools or add custom ones. Easily expand agent capabilities by registering new tools tailored to specific needs.

- **Natural Language Interaction**: Utilize OpenAI models to interpret complex prompts and provide contextual, intelligent responses using natural language.

### Creating Your First Agent

Here’s how to create a simple agent using the **CalculatorTool**:

```powershell
$calculatorTool = New-CalculatorTool
$agent = New-Agent -Tools $calculatorTool -Name "CalculatorAgent" -Description "An agent that performs basic arithmetic operations"
```

Once created, you can interact with the agent using the `Get-AgentResponse` command:

```powershell
$agent | Get-AgentResponse '3 * 5 + 6 - is it prime?'
```

The agent will respond with step-by-step calculations, such as:

```
Multiplying 3 and 5 to get 15
Adding 15 and 6 to get 21
The result of (3 * 5 + 6) is 21, and 21 is not a prime number.
```

### Examples: What PSAI Agents Can Do

Below are a few examples that showcase PSAI's capabilities:

#### **Basic Agent**
Create a simple agent with instructions:

```powershell
$SecretAgent = New-Agent -Instructions "Recipes should be under 5 ingredients"
$SecretAgent | Get-AgentResponse 'Share a breakfast recipe.'
```

#### **Calculator Tool**
A calculator agent can solve arithmetic problems and check properties like primality:

```powershell
param(
    [string]$prompt = 'is 5 * 2 + 1 a prime number?',
    [Switch]$ShowToolCalls
)

$agent = New-Agent -Tools (New-CalculatorTool) -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse $prompt
```

#### **Web Search Tool**
Search for information using the TavilyAI tool:
NOTE: You need to set the `TavilyAIKey` environment variable with your API key. You can get a free key at https://tavily.com.

Set the `TavilyAIKey` environment variable: `$env:TAVILY_API_KEY`

```powershell
$agent = New-Agent -Tools (New-TavilyAITool) -ShowToolCalls
$agent | Get-AgentResponse 'what is the latest news on PowerShell?'
```

#### **Finance Tool**
Fetch stock market data
NOTE You can obtain an API key from: https://intelligence.financialmodelingprep.com/developer/docs

Set the `StockTickerKey` environment variable: `$env:financialmodelingprep`

```powershell
$agent = New-Agent -Tools (New-StockTickerTool) -ShowToolCalls
$agent | Get-AgentResponse 'What did Microsoft, Apple, and Google close at?'
```

#### **Multi-Agent**
Combining multiple tools to handle complex tasks:

```powershell
$tools = $(
  New-TavilyAITool
  New-StockTickerTool
)

$agent = New-Agent -Tools $tools -ShowToolCalls
$agent | Get-AgentResponse 'What did Microsoft close at and the latest news for them?'
```

## Future Roadmap

We are continuously evolving PSAI Agents to meet more diverse automation needs:

- **More Tools**: Including weather information, document parsing, and task automation features.
- **Interactive Sessions**: Richer CLI interactions for more dynamic agent conversations.
- **Workflow Automation**: Agents capable of multi-step workflows that integrate with existing scripts and systems.

## Questions? Feedback?

For questions or feedback, open an issue on GitHub or reach out via [Twitter](https://x.com/dfinke) or [LinkedIn](https://www.linkedin.com/in/douglasfinke/).

Happy Automating!