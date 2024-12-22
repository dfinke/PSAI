Import-Module PSAI -Force

Clear-Host

$prompt = "
In the hockey game, Mitchell scored more points than William 
but fewer points than Auston. 
Who scored the most points? 
Who scored the fewest points?
"

$slugs = $(
    'Gemini:gemini-2.0-flash-thinking-exp-1219'
    'Anthropic:claude-3-5-sonnet-20240620'
    'OpenAI:gpt-4o'
)

foreach ($slug in $slugs) {
    Write-Host (Set-AIDefault $slug) -ForegroundColor Green
    q $prompt -OutputOnly
    ''
}

