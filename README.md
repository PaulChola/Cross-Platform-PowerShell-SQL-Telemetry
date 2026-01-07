

## Overview

**Cross-Platform PowerShell Telemetry** is a cybersecurity project that focuses on collecting **endpoint telemetry** from both **Windows and Linux systems** using PowerShell.

The project features a **single, unified script** that automatically detects the operating system and collects comprehensive telemetry data. The collected data enables **endpoint visibility**, **risk assessment**, and **vulnerability analysis** for security practitioners.

This project is designed as a foundation for:

* SOC operations
* Blue team monitoring
* Endpoint security assessments
* Incident response and forensics

---

## Core Concept

**Endpoint → PowerShell → Telemetry Collection**

1. PowerShell runs on Windows and Linux endpoints
2. System and authentication telemetry is collected
3. Data is displayed in a structured format for analysis
4. Enables manual assessment of risk, exposure, and anomalies

---

## Objectives

* Detect and identify the operating system (Windows or Linux)
* Collect detailed operating system and system metadata
* Gather login and logout activity from endpoints
* Provide a single, cross-platform collection script
* Offer user-friendly menu interface
* Enable risk and vulnerability assessment through collected data
* Build a foundation for endpoint monitoring

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

### 3. Authentication Telemetry

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

### 4. Interactive Interface

* **Menu-driven interface** for easy execution
* **Command-line parameters** for automated execution
* **Help system** with usage instructions

---

## Project Structure

```text
Cross-Platform-PowerShell-Telemetry/
│
├── single_telemetry.ps1      # Unified cross-platform telemetry collection script
└── README.md                 # Project documentation
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
# Launch interactive menu
./single_telemetry.ps1 -Menu
```

The interactive menu provides options to:
1. **Run Telemetry Collection**
2. **Exit**

### Direct Execution

```bash
# Run telemetry collection directly
./single_telemetry.ps1
```

### Command-Line Parameters

The script supports the following parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-Menu` | Show interactive menu | `./single_telemetry.ps1 -Menu` |
| `-Help` | Display help information | `./single_telemetry.ps1 -Help` |

### Command-Line Execution

```powershell
# Run telemetry collection directly
./single_telemetry.ps1

# Show interactive menu
./single_telemetry.ps1 -Menu

# Display help information
./single_telemetry.ps1 -Help
```

### Output

The script outputs:

* Detected operating system
* OS and system information
* Login and logout session history

This output enables manual analysis of endpoint telemetry for security assessments.

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
* Single unified cross-platform script
* Interactive menu-driven interface
* Command-line parameter support
* OS detection and telemetry collection
* Login/logout history gathering

**🔄 Planned:**
* JSON and CSV export options
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

