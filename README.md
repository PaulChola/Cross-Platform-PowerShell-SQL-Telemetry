---

## 🔹 Overview

This project is designed to **collect critical endpoint data** such as OS information, login/logout events, and system activity across Windows devices.
The collected data is **stored in SQLite** for structured analysis, reporting, and integration with SIEM pipelines.

**Purpose:** Support **SOC analysts** in detecting suspicious activity and performing incident investigations.

---

## 🔹 SOC Use Cases

* Detect unauthorized logins or privilege escalation
* Investigate compromised endpoints
* Audit system activity for compliance
* Feed telemetry data into SIEM solutions (e.g., Splunk, Azure Sentinel)

---

## 🔹 Features

* Cross-platform collection (Windows-focused)
* Authentication event logging
* Host and OS metadata collection
* Structured SQLite storage for analysis
* Lightweight and easily extensible

---

## 🔹 Tech Stack

* **PowerShell** – endpoint collection
* **SQLite** – structured storage
* Optional: Python for post-processing / analysis

---

## 🔹 Sample Output

*(Sanitized example)*

| Hostname | Username | EventType | Timestamp        | OS          | Notes         |
| -------- | -------- | --------- | ---------------- | ----------- | ------------- |
| LAPTOP1  | paul     | Logon     | 2026-01-26 10:45 | Windows10   | Normal login  |
| SERVER1  | admin    | Logoff    | 2026-01-26 10:50 | Windows2019 | Session ended |

---

## 🔹 Installation & Running

1. Clone the repository:

```bash
git clone https://github.com/PaulChola/Cross-Platform-PowerShell-SQL-Telemetry.git
```

2. Navigate to the scripts folder:

```bash
cd Cross-Platform-PowerShell-SQL-Telemetry/scripts
```

3. Run the main script in **PowerShell** with appropriate permissions:

```powershell
.\Collect-Telemetry.ps1
```

4. SQLite database (`telemetry.db`) will store results automatically.

---

## 🔹 Folder Structure (Recommended)

```
/scripts             # PowerShell scripts
/database            # SQLite DB file
/docs                # Documentation, sample outputs
/images              # Screenshots / diagrams
README.md
```

---

## 🔹 Future Improvements

* Parse Windows Event IDs for security events
* Add Linux endpoint support
* Integrate directly with SIEM APIs
* Include automated detection logic

---

## 🔹 Contributing

Pull requests welcome. Ensure changes follow **PowerShell best practices** and include documentation.
