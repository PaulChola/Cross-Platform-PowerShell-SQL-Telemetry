

## Overview

**Cross-Platform PowerShell & SQL Telemetry** is a cybersecurity project that focuses on collecting **endpoint telemetry** from both **Windows and Linux systems** using PowerShell and storing that data in a **SQL database** for analysis.

The project features a **menu-driven interface** that allows users to choose between different telemetry collection methods, including cross-platform, Windows-specific, and Linux-specific scripts. The collected data enables **endpoint visibility**, **risk assessment**, and **vulnerability analysis** by allowing security practitioners to run structured SQL queries against centralized endpoint information.

This project is designed as a foundation for:

* SOC operations
* Blue team monitoring
* Endpoint security assessments
* SIEM-style data pipelines

---

## Core Concept

**Endpoint → PowerShell → SQL → Analysis**

1. PowerShell runs on Windows and Linux endpoints
2. System and authentication telemetry is collected
3. Data is normalized and stored in a SQL database
4. SQL queries are used to assess risk, exposure, and anomalies

---

## Objectives

* Detect and identify the operating system (Windows or Linux)
* Collect detailed operating system and system metadata
* Gather login and logout activity from endpoints
* Provide multiple collection methods (cross-platform, OS-specific)
* Offer user-friendly menu interface for script selection
* Store telemetry data in a SQL database
* Enable risk and vulnerability assessment through queries
* Build a scalable foundation for future SIEM integration

---

## Features

### 1. Cross-Platform OS Detection

* Automatically detects:

  * Windows endpoints
  * Linux endpoints
* Handles unknown or unsupported systems gracefully

---

### 2. Operating System Telemetry

#### Windows

Collected using native Windows APIs (CIM):

* OS name and version
* Build number
* System architecture
* Last boot time

#### Linux

Collected using native GNU/Linux utilities:

* Distribution name
* Logged-in user
* Hostname
* Kernel version
* System architecture
* Uptime

### 4. Interactive Runner Script

* **Menu-driven interface** for easy script selection
* **Command-line parameters** for automated execution
* **OS auto-detection** for appropriate script selection
* **Export functionality** (JSON/CSV formats planned)
* **Help system** with comprehensive usage instructions

### 5. Multiple Collection Methods

* **Cross-platform script**: Unified collection for any supported OS
* **OS-specific scripts**: Optimized collection for Windows/Linux
* **Flexible execution**: Choose manual selection or automatic detection

#### Windows

* Collects authentication events from **Windows Security Logs**
* Event IDs:

  * `4624` – Successful logon
  * `4634` – Logoff
* Captures:

  * Username
  * Event type (Login / Logout)
  * Timestamp

#### Linux

* Collects session history using the `last` command
* Filters out reboot and shutdown entries
* Captures:

  * User
  * Terminal
  * Login time
  * Logout time (best-effort parsing)

---

## Data Storage (SQL)

All collected telemetry is designed to be stored in a **SQL database**, enabling:

* Centralized endpoint visibility
* Historical tracking
* Risk scoring
* Vulnerability trend analysis
* Query-driven investigations

Example analysis use cases:

* Identify stale or rarely rebooted systems
* Detect unusual login patterns
* Track endpoint uptime and exposure
* Compare endpoint configurations for inconsistencies

---

## Project Structure

```text
Cross-Platform-PowerShell-SQL-Telemetry/
│
├── run.ps1                   # Main runner script with interactive menu
├── endpoint_telemetry.ps1    # Cross-platform telemetry collection script
├── WindowsEpoint.ps1         # Windows-specific telemetry collection
├── LinuxEpoint.ps1           # Linux-specific telemetry collection
├── README.md                 # Project documentation
└── run.ps1.backup           # Backup of runner script
```

---

## Requirements

### Windows

* PowerShell 5.1 or PowerShell 7+
* Administrator privileges (for Security Event Logs)

### Linux

* PowerShell 7+
* Standard GNU/Linux utilities
* Permission to read login history

---

## Usage

### Interactive Menu (Recommended)

```bash
# Launch interactive menu for script selection
./run.ps1

# Or explicitly request the menu
./run.ps1 -Menu
```

The interactive menu provides options to:
1. **Windows Telemetry** - Run WindowsEpoint.ps1
2. **Linux Telemetry** - Run LinuxEpoint.ps1  
3. **Cross-Platform Telemetry** - Run endpoint_telemetry.ps1
4. **Exit** - Close the application

### Command-Line Parameters

The runner script supports the following parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-Collect` | Auto-detect OS and run telemetry collection | `./run.ps1 -Collect` |
| `-Menu` | Show interactive menu | `./run.ps1 -Menu` |
| `-Export` | Export results to file (framework ready) | `./run.ps1 -Collect -Export` |
| `-OutputFormat` | Output format: Console, JSON, CSV | `-OutputFormat JSON` |
| `-OutputFile` | Output file path (required with -Export) | `-OutputFile results.json` |
| `-Help` | Display help information | `./run.ps1 -Help` |

### Command-Line Execution

```powershell
# Auto-detect OS and run appropriate telemetry collection
./run.ps1 -Collect

# Export results to file (future feature)
./run.ps1 -Collect -Export -OutputFormat JSON -OutputFile results.json

# Display help information
./run.ps1 -Help
```

### Direct Script Execution

```powershell
# Run cross-platform collection directly
./endpoint_telemetry.ps1

# Run Windows-specific collection
./WindowsEpoint.ps1

# Run Linux-specific collection
./LinuxEpoint.ps1
```

### Output

All scripts output:

* Detected operating system
* OS and system information
* Login and logout session history

This output is intended to be **stored in SQL** for further analysis.

---

## Use Cases

* SOC analyst endpoint investigations
* Blue team monitoring and visibility
* Risk assessment and exposure analysis
* Vulnerability assessment support
* PowerShell cross-platform automation practice
* Foundation for SIEM or log aggregation systems

---

## Future Enhancements

**✅ Completed:**
* Interactive menu-driven interface
* Multiple collection method support
* Cross-platform and OS-specific scripts
* Command-line parameter support

**🔄 Planned:**
* Automated SQL ingestion
* JSON and CSV export options (framework in place)
* Field normalization across operating systems
* Risk scoring logic
* MITRE ATT&CK technique mapping
* Centralized collection from multiple endpoints
* Integration with SIEM platforms

---

## Author

**Paul Chola Bwembya Mumbi**
Cybersecurity | Endpoint Security | Blue Team
Zambia 🇿🇲

---

## Disclaimer

This project is intended for **educational and defensive security purposes only**.
Ensure proper authorization before collecting or storing endpoint telemetry.

