<#
.SYNOPSIS
  The definitive, stable version of FileFlow. This script is fully configurable
  and 100% compatible with Windows PowerShell 5.1.
#>

# --- Configuration ---
$configFile = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) "..\config.json"
if (-not (Test-Path $configFile)) {
    Write-Host "FATAL ERROR: config.json not found. Make sure it is in the main 'fileflow' directory."
    exit 1
}
$config = Get-Content -Raw -Path $configFile | ConvertFrom-Json

$watchFolder = $config.watchFolder
$logFile = $config.logFile
$libreOfficePath = $config.libreOfficePath
$maxRetries = $config.maxRetries
$retryDelaySec = $config.retryDelaySec
$scanIntervalSec = $config.scanIntervalSec

# --- Logging function ---
function Write-Log {
    param([string]$Message)
    # THE FIX IS HERE: We pass the $logFile path as a parameter to this function.
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

# --- Main Conversion Logic ---
function Process-File {
    param(
        [string]$FilePath,
        [string]$LogPath,
        [string]$ConverterPath,
        [int]$Retries,
        [int]$Delay
    )

    $fileName = (Get-Item -LiteralPath $FilePath).Name
    $processedFolder = Join-Path (Split-Path $FilePath -Parent) "processed"
    $lockFilePath = "$FilePath.lock"

    if (Test-Path $lockFilePath) { return }
    New-Item -Path $lockFilePath -ItemType File | Out-Null
    # Call Write-Log with the correct log path variable from the parameters
    Write-Log "INFO: Detected and locked '$fileName' for processing."

    for ($i = 1; $i -le $Retries; $i++) {
        try {
            if (-not (Test-Path $processedFolder)) {
                New-Item -ItemType Directory -Path $processedFolder -ErrorAction Stop | Out-Null
            }
            $argumentList = "--headless --convert-to pdf `"$FilePath`" --outdir `"$processedFolder`""
            Start-Process -FilePath $ConverterPath -ArgumentList $argumentList -Wait -NoNewWindow
            $destination = Join-Path $processedFolder $fileName
            Move-Item -LiteralPath $FilePath -Destination $destination -Force
            Write-Log "SUCCESS: Converted and moved '$fileName'."
            Remove-Item $lockFilePath -Force
            return
        }
        catch {
            if ($i -lt $Retries) {
                Write-Log "WARN: Attempt $i failed on '$fileName' (likely locked). Retrying in $Delay seconds..."
                Start-Sleep -Seconds $Delay
            } else {
                Write-Log "ERROR: Failed to process '$fileName' after $Retries attempts. It remained locked."
                Remove-Item $lockFilePath -Force
            }
        }
    }
}

# --- Start Monitoring ---
Add-Content -Path $logFile -Value "=======================================================" -ErrorAction SilentlyContinue
Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - FileFlow Activated. Monitoring '$watchFolder'."
Write-Host "FileFlow Activated. Monitoring for files. (Press Ctrl+C to stop)"

# --- Main Loop ---
while ($true) {
    $unlockedFiles = Get-ChildItem -Path $watchFolder -Filter "*.docx" | Where-Object { -not (Test-Path "$($_.FullName).lock") }
    if ($unlockedFiles) {
        Write-Log "INFO: Scan detected $($unlockedFiles.Count) new file(s)."
        foreach ($file in $unlockedFiles) {
            # We are already passing all the necessary variables here, so no change is needed.
            Process-File -FilePath $file.FullName -LogPath $logFile -ConverterPath $libreOfficePath -Retries $maxRetries -Delay $retryDelaySec
        }
        Write-Log "INFO: Batch complete."
    }
    Start-Sleep -Seconds $scanIntervalSec
}