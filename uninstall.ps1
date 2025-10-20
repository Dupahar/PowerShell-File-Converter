# This script must be run as an Administrator to remove a scheduled task.

$taskName = "FileFlow Converter"

try {
    # The -Confirm:$false flag prevents it from asking "Are you sure?"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
    Write-Host "✅ The '$taskName' background task has been successfully removed."
}
catch {
    Write-Host "⚠️ Could not find the task '$taskName' (it may have already been removed), or an error occurred."
}