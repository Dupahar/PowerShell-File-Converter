' This script's only job is to run a PowerShell script in a completely hidden window.

Dim shell, command

' THE FIX IS HERE: We use the full, absolute path to the PowerShell script.
strPowerShellScript = "C:\Users\mahaj\Downloads\fileflow\engine\Start-FileFlow.ps1"

' Build the full command to execute
command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & strPowerShellScript & """"

' Run the command completely hidden (the '0' means "hidden window")
Set shell = CreateObject("WScript.Shell")
shell.Run command, 0, False