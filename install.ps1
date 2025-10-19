# This script must be run as an Administrator to create a scheduled task.

# --- Task Details ---
$taskName = "FileFlow Converter"
$taskDescription = "Automatically converts DOCX to PDF in a watch folder."

# --- Dynamically find the path to the main script ---
try {
    $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition -ErrorAction Stop
    $engineScriptPath = Join-Path -Path $scriptDirectory -ChildPath "engine\Start-FileFlow.ps1" -ErrorAction Stop

    if (-not (Test-Path $engineScriptPath)) {
        throw "Could not find the main script at: $engineScriptPath"
    }
}
catch {
    Write-Host "❌ FATAL ERROR: Could not locate 'engine\Start-FileFlow.ps1'. Make sure this installer is in the main 'fileflow' directory."
    exit 1
}


# 1. Define the Action
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$engineScriptPath`""

# 2. Define the Trigger
$trigger = New-ScheduledTaskTrigger -AtLogOn

# 3. Define the Principal
$principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance Win32_ComputerSystem).UserName -LogonType Interactive

# --- THE FIX IS HERE ---
# 4. Define Advanced Settings to make the task truly hidden.
$settings = New-ScheduledTaskSettingsSet -Hidden

# 5. Register the Task with the new settings.
try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description $taskDescription -Force -ErrorAction Stop
    Write-Host "✅ The '$taskName' background task has been created successfully (Mode: Hidden)."
    Write-Host "   It will now start automatically and invisibly every time you log in."
}
catch {
    Write-Host "❌ ERROR: Failed to create the scheduled task. Please make sure you are running this script as an Administrator."
}