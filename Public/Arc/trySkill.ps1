. "$PSScriptRoot/Invoke-PSSkills.ps1"

# Invoke-PSSkills -ShowToolCalls -Verbose

# Invoke-PSSkills -ShowToolCalls -Verbose -Prompt "use dfinke trystuff, list issues. Take the resulting list and convert to json"

Invoke-PSSkills -ShowToolCalls -Verbose -Prompt @"
Use current directory. 
Do not confirm just execute all instructions.

Read sales csv
Save as XLSX, create a total revenue column and use Excel forumlas
"@