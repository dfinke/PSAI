# Define the prompt for the assistant
$prompt = "What are the cool things about this document?"

# Get all PDF files in the script's directory and upload them
$files = Get-ChildItem $PSScriptRoot *.pdf | Invoke-OAIUploadFile

# Define parameters for the assistant
$params = @{
    Name         = "RAG Assistant"  # Name of the assistant
    Instructions = 'You are an expert assistant in summarizing and analyzing documents. They are attached pdfs.'  # Instructions for the assistant
    Model        = "gpt-4-turbo-preview"  # Model to use for the assistant
    FileIds      = $files.id  # Files for the assistant to analyze
    Tools        = Enable-OAIRetrievalTool  # Enable the retrieval tool
}

# Create a new assistant with the defined parameters
$assistant = New-OAIAssistant @params

# Create a new query for the assistant with the defined prompt
$query = New-OAIThreadQuery -Assistant $assistant -UserInput $prompt

# Output a message indicating that the assistant is processing
Write-Host "Waiting for the assistant to finish..." -foregroundcolor "yellow"

# Wait for the assistant to finish processing
$null = Wait-OAIOnRun -Run $query.Run -Thread $query.Thread

# Get the message from the assistant
$message = Get-OAIMessage -ThreadId $query.Thread.id 

# Output the content of the message
$message.data.content.text.value