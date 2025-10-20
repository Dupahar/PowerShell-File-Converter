# This script must be run as an Administrator to create a scheduled task.

$taskName = "FileFlow Converter"
$taskDescription = "Silently converts DOCX to PDF in the background."

try {
    $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition -ErrorAction Stop
    $vbsLauncherPath = Join-Path -Path $scriptDirectory -ChildPath "launch_hidden.vbs" -ErrorAction Stop
    if (-not (Test-Path $vbsLauncherPath)) { throw "Could not find 'launch_hidden.vbs'." }
}
catch {
    Write-Host "❌ FATAL ERROR: Could not locate 'launch_hidden.vbs'. Make sure this installer is in the main 'fileflow' directory." -ForegroundColor Red
    exit 1
}

# 1. Define the Action to run the VBScript wrapper.
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$vbsLauncherPath`""

# 2. Define the Trigger to run when you log on.
$trigger = New-ScheduledTaskTrigger -AtLogOn

# 3. Register the Task. This simplified version lets Task Scheduler use the default user settings, which is more reliable.
try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description $taskDescription -Force -ErrorAction Stop
    Write-Host "✅ The '$taskName' background task has been created successfully." -ForegroundColor Green
    Write-Host "   It will now start automatically and invisibly every time you log in."
}
catch {
    Write-Host "❌ ERROR: Failed to create the scheduled task. Please make sure you are running this script as an Administrator." -ForegroundColor Red
}