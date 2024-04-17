# Once developers start to understand the entirely new capabilities that having 
# cheap intelligence-on-demand brings to the table we are going to
# see a burst of really exciting and novel things ~ Ethan Mollick

<#
This script is an simple example of how to use the OpenAI PowerShell module to create a simple tutor.

Additional functions can be built to further simplify the process.

You can experiment with different questions and instructions.

Try:
------
$Instructions = 'You are a personal math tutor. When asked a math question, write and run code to answer the question.'

$question = 'I need to solve the equation `3x + 11 = 14`. Can you help me?'
#>
param(
    $question = 'What is the capital of France?'
)

$assistant = New-OAIAssistant -Instructions 'You are an expert in geography, be helpful and concise.'

$thread = New-OAIThread

$null = New-OAIMessage $thread.id -Role user -Content $question

$run = New-OAIRun $thread.Id $assistant.Id
$status = $run.status

# Let's poll
while ($status -ne 'completed') {
    Write-Host "[$(Get-Date)] Waiting for run to complete..."
    $run = Get-OAIRun -threadId $thread.id
    $status = $run.data[0].status
    Start-Sleep -Seconds 1
}

# Get and print the messages
$messages = Get-OAIMessage -threadId $thread.id -Order asc
#$messages.data | ConvertTo-Json -Depth 10
Write-Host -ForegroundColor Yellow "Messages:"
$messages.data.content.text.value 

<#
# Optional, get and print the steps
$steps = Get-OAIRunStep -ThreadId $thread.Id -RunId $run.data[0].id
$steps | ConvertTo-Json -Depth 10
#>

# Delete the assistant
#$null = Remove-OAIAssistant $assistant.Id