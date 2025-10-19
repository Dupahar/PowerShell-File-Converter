FileFlow for Windows 📁➡️📄



FileFlow is a powerful, headless automation engine for Windows that monitors a folder for new documents and automatically converts them to PDF. It is designed to be a robust "set-and-forget" background service, hardened to work reliably with cloud-synced folders like OneDrive.



This project was developed as a Major Project for the B.Tech (AI \& MI) program at the University of Jammu.



Key Features ✨



\- Automatic Conversion: Monitors a "watch folder" and automatically converts new .docx files to .pdf.

\- Cloud-Sync Aware: Built to be resilient against file locks from services like OneDrive, using a smart retry mechanism.

\- Fully Configurable: All paths and settings are managed in a simple config.json file.

\- Silent Background Service: Runs completely invisibly in the background using the Windows Task Scheduler, starting automatically when you log in.

\- Robust \& Stable: Processes files serially to ensure stability and uses a file-locking system to prevent duplicate processing.

\- Easy Installation: Comes with an install.ps1 script to automatically set up the background task.



Installation ⚙️



Follow these steps to get FileFlow running on your system.



1\. \*\*Prerequisites:\*\*

&nbsp;  - Windows 10/11  

&nbsp;  - PowerShell 5.1 (comes pre-installed)  

&nbsp;  - LibreOffice: Download and install from the \[official website](https://www.libreoffice.org/download/download-libreoffice/).  

&nbsp;    The script assumes the default installation path:

&nbsp;    ```

&nbsp;    C:\\Program Files\\LibreOffice

&nbsp;    ```



2\. \*\*Download the Project:\*\*  

&nbsp;  Clone or download this repository to a location on your computer, for example:  

&nbsp;  ```

&nbsp;  C:\\Users\\YourUser\\Downloads\\fileflow

&nbsp;  ```



3\. \*\*Configure FileFlow:\*\*  

&nbsp;  Open the `config.json` file in the main project directory with a text editor.  

&nbsp;  Review and update the paths to match your system.



&nbsp;  ```

&nbsp;  {

&nbsp;    "watchFolder": "C:\\\\Users\\\\mahaj\\\\OneDrive\\\\Documents\\\\WatchFolder",

&nbsp;    "logFile": "C:\\\\Users\\\\mahaj\\\\Downloads\\\\fileflow\\\\engine\\\\FileFlow.log",

&nbsp;    "libreOfficePath": "C:\\\\Program Files\\\\LibreOffice\\\\program\\\\soffice.exe",

&nbsp;    "maxRetries": 5,

&nbsp;    "retryDelaySec": 5,

&nbsp;    "scanIntervalSec": 15

&nbsp;  }

&nbsp;  ```



4\. \*\*Run the Installer:\*\*  

&nbsp;  The installer will automatically create the Windows Task Scheduler job to run FileFlow silently in the background.



&nbsp;  - Right-click the PowerShell or Windows Terminal icon and select \*\*Run as Administrator\*\*.

&nbsp;  - Navigate to the project directory:

&nbsp;    ```

&nbsp;    cd C:\\Users\\mahaj\\Downloads\\fileflow

&nbsp;    ```

&nbsp;  - Run the installer:

&nbsp;    ```

&nbsp;    .\\install.ps1

&nbsp;    ```



&nbsp;  You should see a success message confirming that the background task was created.



Usage 🚀



Once installed, FileFlow runs automatically.



\- \*\*Log Out and Log Back In:\*\* This will trigger the background task to start for the first time.  

\- \*\*Drop Files:\*\* Simply save or move any `.docx` file into the `watchFolder` you specified in your configuration.  

\- \*\*Check for PDFs:\*\* After a short delay (the script scans every 15 seconds), a PDF version of your file will appear in a subfolder named `processed` inside your watchFolder.  

&nbsp; The original `.docx` file will also be moved there.



To check the status or see a history of conversions, you can view the log file specified in your `config.json` (`engine\\FileFlow.log`).



How It Works ⚙️



FileFlow uses a polling-based system for maximum reliability.  

The main `Start-FileFlow.ps1` script runs in a loop, scanning the `watchFolder` periodically.  

To handle conflicts with cloud services like OneDrive, it implements a retry loop and a file-locking mechanism.



If a file is detected, it is "locked" to prevent re-processing.  

If the conversion fails because the file is in use, the script waits and retries several times before logging an error.  

This ensures that even with synchronization delays, the file is eventually processed correctly.



