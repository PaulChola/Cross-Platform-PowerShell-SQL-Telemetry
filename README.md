

## Overview

**Cross-Platform PowerShell Telemetry** is a cybersecurity project that focuses on collecting **endpoint telemetry** from both **Windows and Linux systems** using PowerShell.

The project features a **single, unified script** that automatically detects the operating system and collects comprehensive telemetry data. The collected data can be **stored in a MySQL/MariaDB database** for persistent storage and analysis. The collected data enables **endpoint visibility**, **risk assessment**, and **vulnerability analysis** for security practitioners.

This project is designed as a foundation for:

* SOC operations
* Blue team monitoring
* Endpoint security assessments
* Incident response and forensics
* Database-driven telemetry analysis

---

## Core Concept

**Endpoint → PowerShell → Telemetry Collection → MySQL Database**

1. PowerShell runs on Windows and Linux endpoints
2. System and authentication telemetry is collected
3. Data is displayed in a structured format for analysis
4. Optional persistent storage in MySQL/MariaDB database
5. Enables manual assessment of risk, exposure, and anomalies

---

## Objectives

* Detect and identify the operating system (Windows or Linux)
* Collect detailed operating system and system metadata
* Gather login and logout activity from endpoints
* Provide a single, cross-platform collection script
* Offer user-friendly menu interface
* Enable risk and vulnerability assessment through collected data
* Build a foundation for endpoint monitoring with database persistence
* Provide database query capabilities for stored telemetry

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

### 4. Database Storage (MySQL/MariaDB)

* **Optional persistent storage** in MySQL/MariaDB database
* **Two-table schema**:

  * `SystemInfo` – Operating system and system metadata
  * `SessionHistory` – Login and logout events
* **Automatic database initialization** with proper schema
* **Cross-platform compatibility** using mysql command-line client

### 5. Database Query Interface

* **Separate query script** for database analysis
* **Multiple query options**:

  * View system information
  * View session history
  * Database statistics
* **Interactive menu** for easy querying

### 6. Interactive Interface

* **Menu-driven interface** for easy execution
* **Command-line parameters** for automated execution
* **Help system** with usage instructions

---

## Project Structure

```text
Cross-Platform-PowerShell-Telemetry/
│
├── single_telemetry.ps1      # Unified cross-platform telemetry collection script
├── query_telemetry.ps1       # Database query and analysis script
├── README.md                 # Project documentation
└── MySqlConnector.dll        # .NET MySQL connector (legacy, not used)
```

---

## Requirements

### Windows

* PowerShell 5.1 or PowerShell 7+
* Administrator privileges (for Security Event Logs)
* MySQL/MariaDB server (optional, for database storage)

### Linux

* PowerShell 7+
* Standard GNU/Linux utilities
* Permission to read login history
* MariaDB/MySQL server and client (optional, for database storage)

### Database Setup (Optional)

For database storage functionality:

1. **Install MariaDB/MySQL server**
2. **Create database and user**:

```sql
CREATE DATABASE telemetry_db;
CREATE USER 'telemetry_user'@'localhost' IDENTIFIED BY 'telemetry_pass';
GRANT ALL PRIVILEGES ON telemetry_db.* TO 'telemetry_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## Usage

### Interactive Menu (Recommended)

```bash
# Launch interactive menu
./single_telemetry.ps1 -Menu
```

The interactive menu provides options to:
1. **Run Telemetry Collection**
2. **Run Telemetry Collection with Database Storage**
3. **Exit**

### Direct Execution

```bash
# Run telemetry collection (display only)
./single_telemetry.ps1

# Run telemetry collection with database storage
./single_telemetry.ps1 -Store
```

### Database Query Interface

```bash
# Launch database query interface
./query_telemetry.ps1
```

### Command-Line Parameters

The script supports the following parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-Menu` | Show interactive menu | `./single_telemetry.ps1 -Menu` |
| `-Store` | Store data in MySQL database | `./single_telemetry.ps1 -Store` |
| `-Help` | Display help information | `./single_telemetry.ps1 -Help` |

### Command-Line Execution

```powershell
# Run telemetry collection directly (display only)
./single_telemetry.ps1

# Run telemetry collection with database storage
./single_telemetry.ps1 -Store

# Show interactive menu
./single_telemetry.ps1 -Menu

# Display help information
./single_telemetry.ps1 -Help

# Query stored telemetry data
./query_telemetry.ps1
```

### Output

The script outputs:

* Detected operating system
* OS and system information
* Login and logout session history
* Database storage confirmation (when using -Store)

This output enables manual analysis of endpoint telemetry for security assessments.

---

## Database Schema

### SystemInfo Table

| Column | Type | Description |
|--------|------|-------------|
| ID | INT AUTO_INCREMENT | Primary key |
| Hostname | VARCHAR(255) | System hostname |
| OS | VARCHAR(50) | Operating system |
| OSInfo | JSON | Detailed OS information |
| CollectionTime | TIMESTAMP | Data collection timestamp |

### SessionHistory Table

| Column | Type | Description |
|--------|------|-------------|
| ID | INT AUTO_INCREMENT | Primary key |
| Hostname | VARCHAR(255) | System hostname |
| User | VARCHAR(255) | Username |
| EventType | VARCHAR(50) | Login/Logout |
| Time | VARCHAR(255) | Event timestamp |
| Terminal | VARCHAR(255) | Terminal/session info |
| CollectionTime | TIMESTAMP | Data collection timestamp |

---

## Use Cases

* SOC analyst endpoint investigations
* Blue team monitoring and visibility
* Risk assessment and exposure analysis
* Vulnerability assessment support
* PowerShell cross-platform automation practice
* Database-driven telemetry analysis
* Historical endpoint behavior analysis
* Foundation for SIEM or log aggregation systems

---

## Future Enhancements

**✅ Completed:**
* Single unified cross-platform script
* Interactive menu-driven interface
* Command-line parameter support
* OS detection and telemetry collection
* Login/logout history gathering
* MySQL/MariaDB database integration
* Database query interface
* Cross-platform database operations

**🔄 Planned:**
* JSON and CSV export options
* Field normalization across operating systems
* Risk scoring logic
* MITRE ATT&CK technique mapping
* Centralized collection from multiple endpoints
* Integration with SIEM platforms
* Database backup and restore functionality
* Web-based query interface

---

## Author

**Paul Chola Bwembya Mumbi**
Cybersecurity | Endpoint Security | Blue Team
Zambia 🇿🇲

---

## Disclaimer

This project is intended for **educational and defensive security purposes only**.
Ensure proper authorization before collecting or storing endpoint telemetry.

