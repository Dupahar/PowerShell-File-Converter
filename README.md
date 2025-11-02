# FileFlow for Windows 📁➡️📄

A powerful, headless automation engine for Windows that monitors folders and automatically converts documents to PDF. Designed as a robust "set-and-forget" background service, hardened to work reliably with cloud-synced folders like OneDrive.

> Academic Project: Developed as a Major Project for the B.Tech (AI & MI) program at the University of Jammu.

## ✨ Key Features

- Automatic Conversion – Monitors a designated folder and converts new `.docx` files to `.pdf` automatically
- Cloud-Sync Resilient – Built to handle file locks from services like OneDrive using intelligent retry mechanisms
- Fully Configurable – All paths and settings managed through a simple `config.json` file
- Silent Background Operation – Runs invisibly using Windows Task Scheduler, starting automatically at login
- Robust & Stable – Processes files serially with file-locking to prevent duplicate processing
- Easy Installation – Automated setup via `install.ps1` script

## 📋 Prerequisites

Before installing FileFlow, ensure you have:

- Windows 10/11
- PowerShell 5.1+ (pre-installed on Windows)
- LibreOffice – [Download here](https://www.libreoffice.org/download/download-libreoffice/)
  - Default installation path: `C:\Program Files\LibreOffice`

## ⚙️ Installation

### 1. Download the Project

Clone or download this repository to your computer:

```bash
git clone https://github.com/Dupahar/PowerShell-File-Converter.git
cd PowerShell-File-Converter
```

Or download and extract the ZIP to a location like:
```
C:\Users\YourUser\Downloads\fileflow
```

### 2. Configure FileFlow

Open `config.json` in a text editor and update the paths to match your system:

```json
{
  "watchFolder": "C:\\Users\\YourUser\\OneDrive\\Documents\\WatchFolder",
  "logFile": "C:\\Users\\YourUser\\Downloads\\fileflow\\engine\\FileFlow.log",
  "libreOfficePath": "C:\\Program Files\\LibreOffice\\program\\soffice.exe",
  "maxRetries": 5,
  "retryDelaySec": 5,
  "scanIntervalSec": 15
}
```

Configuration Options:
- `watchFolder` – Directory to monitor for new `.docx` files
- `logFile` – Path where conversion logs will be saved
- `libreOfficePath` – Path to LibreOffice executable
- `maxRetries` – Number of conversion retry attempts
- `retryDelaySec` – Seconds to wait between retries
- `scanIntervalSec` – Folder scan frequency in seconds

### 3. Run the Installer

Important: The installer must be run with Administrator privileges.

1. Right-click PowerShell or Windows Terminal and select Run as Administrator
2. Navigate to the project directory:
   ```powershell
   cd C:\Users\YourUser\Downloads\fileflow
   ```
3. Run the installer:
   ```powershell
   .\install.ps1
   ```

You should see a success message confirming the background task was created.

## 🚀 Usage

Once installed, FileFlow runs automatically in the background.

### Starting FileFlow

- First Time: Log out and log back in to trigger the background task
- Subsequent Runs: FileFlow starts automatically at each login

### Converting Documents

1. Save or move any `.docx` file into your configured `watchFolder`
2. FileFlow scans every 15 seconds (configurable)
3. After conversion, both the PDF and original `.docx` will be moved to a `processed` subfolder

### Monitoring Activity

View the log file specified in `config.json` (default: `engine\FileFlow.log`) to check:
- Conversion status
- Error messages
- Processing history

## ⚙️ How It Works

FileFlow uses a polling-based system for maximum reliability:

1. Monitoring – The `Start-FileFlow.ps1` script runs in a loop, scanning the `watchFolder` periodically
2. File Locking – Detected files are "locked" to prevent duplicate processing
3. Cloud-Sync Handling – Implements retry logic to handle OneDrive/cloud service file locks
4. Conversion – Uses LibreOffice in headless mode to convert documents to PDF
5. Organization – Moves processed files to a `processed` subfolder

This architecture ensures that even with synchronization delays, files are eventually processed correctly.

## 🗂️ Project Structure

```
fileflow/
├── engine/
│   ├── Start-FileFlow.ps1    # Main monitoring script
│   └── FileFlow.log           # Activity log (created at runtime)
├── config.json                # Configuration file
├── install.ps1                # Installation script
└── README.md                  # This file
```

## 🛠️ Troubleshooting

### FileFlow isn't processing files

1. Check that the background task is running:
   - Open Task Scheduler
   - Look for "FileFlow Background Service"
   - Verify it's enabled and running

2. Review the log file for errors
3. Ensure LibreOffice is installed at the specified path
4. Verify the `watchFolder` path is correct and accessible

### Files aren't converting

- Ensure files are `.docx` format
- Check that LibreOffice path in `config.json` is correct
- Look for lock file issues in the logs
- Try manually running: `.\engine\Start-FileFlow.ps1`

### Uninstalling FileFlow

1. Open Task Scheduler as Administrator
2. Find and delete "FileFlow Background Service"
3. Delete the project folder

## 📝 License

This project is part of academic coursework for B.Tech (AI & MI) at the University of Jammu.

## 👥 Contributors

- [Dupahar](https://github.com/Dupahar)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Dupahar/PowerShell-File-Converter/issues).

---

Note: This is an academic project and may require additional hardening for production use.
