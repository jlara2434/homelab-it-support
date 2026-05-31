# Lab journal — Acme Homelab

## Day 1 — 2026-05-18

### Done
- Host validation: RAM, virtualization, Hyper-V status checked
- Downloaded ISOs: Windows Server 2022 EN, Windows 10 Enterprise EN, Ubuntu Server 22.04 LTS
- Configured VMnet10 (Host-Only, 192.168.50.0/24, no DHCP, no host adapter)
- Prepared folder structure on D: drive
- Added antivirus exclusions for VMs and ISOs
- Created public GitHub repo: homelab-acme-it-support
- Bootstrapped repo: 9-folder structure, English README, placeholders
- Initial commit pushed

### Issues encountered
- (none / describe here)

### Time spent
- 2h

## Day 2 (full) — 2026-05-19

### Done
- VM DC01 created on VMnet10 (Host-Only, 192.168.50.0/24)
- Windows Server 2022 Standard Evaluation installed (Desktop Experience, EN UI / ES keyboard)
- VMware Tools installed
- Removed unnecessary virtual devices (Floppy, Sound, Printer)
- Static IP configured via PowerShell: 192.168.50.10/24
- DNS pointing to self (127.0.0.1) in preparation for DC role
- Host renamed to DC01
- Snapshots taken: EMPTY-VM (pre-install), BASE-CLEAN (post-install, pre-roles)
- Setup documented in 01-servers/DC01/setup.md

### Issues encountered
- None during install itself.
- Windows Update intentionally deferred — DC isolated on VMnet10 has no Internet
  access by design. Will be patched in a controlled session via temporary NAT adapter.

### Lessons reinforced
- 'Custom: Specific virtual network' option moved to Customize Hardware in WS17,
  no longer in the New VM wizard. UI changes ≠ feature removal.

### Time spent
- ~2h

## Day 3 — 2026-05-20

### Done
- Installed AD DS role on DC01 (no reboot needed for install itself)
- Promoted DC01 as first DC of new forest acme.local
- Forest/Domain functional level: WinThreshold (Server 2016 = highest available)
- NetBIOS name: ACME
- Integrated DNS deployed during promotion
- DSRM password stored separately in password manager (DC01-DSRM)
- Post-promotion validation: Get-AD* OK, dcdiag /v clean (FrsEvent ignored),
  DNS SRV records present, repadmin shows no failures (single DC env)
- Snapshot ROLES-INSTALLED taken
- 3 screenshots captured for portfolio

### Issues encountered
- None blocking. Warnings about NT4 cryptography compatibility during promotion
  are normal Microsoft notices, not errors.

### Concepts internalized
- Forest > Domain > DC hierarchy
- DSRM password is separate from Administrator and used only for AD recovery
- WinThreshold functional level explained
- DNS is AD's nervous system — validated SRV records as part of health check

### Time spent
- ~2h

## Day 4 — 2026-05-21

### Done
- Verified DC health post-snapshot (5 core services running, dcdiag OK)
- Installed and configured DHCP role on DC01
- AUTHORIZED DHCP server in AD (the step most juniors forget)
- Created scope Acme-LAN-50 (192.168.50.100-200), 8-day lease
- Configured scope options 3 (gateway), 6 (internal DNS), 15 (domain suffix)
- Validated: server authorized, scope active, 101 free addresses
- Created OU structure: Acme > Usuarios/Grupos/Equipos/Servidores (deletion-protected)
- Created RRHH global security group
- Created first user laura.garcia, added to RRHH, forced password change at logon
- Snapshot DOMAIN-READY taken

### Issues encountered
- None.

### Concepts internalized
- Rogue DHCP and why AD requires DHCP authorization
- DHCP scope design: reserve space for statics, keep DC outside the range
- The 3 standard scope options (3/6/15) and why DNS must be internal
- OUs vs default Users container; GPOs apply at OU level
- Group scope/category; AGDLP nesting best practice
- ProtectedFromAccidentalDeletion as operational safeguard

### Time spent
- ~1h50

### Next (Saturday)
- Deploy CLIENT01 (Windows 10), join to domain, verify DHCP lease end-to-end

## Saturday (Week 1 close) — 2026-05-25

### Done
- Deployed CLIENT01 (Windows 11 Enterprise) on VMnet10
- Verified DHCP lease end-to-end (client received IP/GW/DNS/suffix from DC01)
- Joined CLIENT01 to acme.local, moved to OU=Equipos
- Validated secure channel and Kerberos logon (laura.garcia)
- Documented 2 incidents as tickets: INC-001 (DNS), INC-002 (IP/DHCP)
- Snapshots: EMPTY-VM, DOMAIN-JOINED, PRE-INCIDENT (CLIENT01); WITH-CLIENT (DC01)

### Concepts internalized
- Domain join internals (computer object, secure channel, SRV-based DC location)
- Diagnostic logic: ping by IP vs by name isolates connectivity vs DNS
- Why domain clients must use internal DNS
- Breaking-on-purpose as diagnostic training

### Time spent
- ~4h

## Day 1 (Week 2) 2026-05-25 — Active Directory GPO Fundamentals & Base Configurations
**Date:** 2026-05-25 | **Environment:** Windows Server 2022 | **Focus:** GPO Architecture

### 🎯 Executive Summary
Initial setup of the Group Policy Management infrastructure. Focused on understanding the inheritance model and deploying the first set of baseline policies, strictly differentiating between User and Computer contexts to avoid deployment failures.

### 🛠️ Execution & Deployment Log
- **Tooling Verification:** Validated GPMC (Group Policy Management Console) installation on DC01 (`Get-WindowsFeature GPMC`).
- **GPO 1 (Corporate Legal Notice):** - Created `Acme - Legal Logon Notice`. 
  - Configured under **Computer Config** (`Policies → Windows Settings → Security Settings → Local Policies → Security Options`).
  - Correctly linked to `OU=Equipos` (Computers) to ensure execution at the hardware level before user authentication.
- **GPO 2 (Network Drives Skeleton):** - Created `Acme - Network Drives` and linked it to `OU=Usuarios`. Content is pending the File Server deployment.
- **Client Validation:** - Forced policy refresh on `CLIENT01` using `gpupdate /force`.
  - Generated an HTML diagnostic report locally to verify applied and filtered objects: `gpresult /h C:\Users\laura.garcia\Desktop\gpreport.html`.

### 🧠 Strategic & Architectural Learnings
- **LSDOU Architecture:** GPO precedence flows through Local -> Site -> Domain -> OU. The OU closest to the target object always wins in case of conflicts.
- **The Context Trap:** Linking Machine policies (Computer Config) to an OU containing only Users results in a silent failure. Proper OU segregation is mandatory unless Loopback Processing is enabled.
- **Troubleshooting:** `gpresult /r` and `/h` are the definitive Layer 7 diagnostic tools to audit Group Policy application and pinpoint exactly why a policy fails to reach an endpoint.

### ⏳ Time Spent
- ~2 hours (including technical English vocabulary review: Inheritance, Enforced, Scope, Link Order).

### ⏭️ Next Steps
- Security baselines deployment (USB restrictions, Screen inactivity lock).
- File Server role installation.

## Day 2 (Week 2) 2026-05-26 — Active Directory Security Hardening & Defenses
**Date:** 2026-05-26 | **Environment:** Windows Server 2022 | **Focus:** SecOps & Defense in Depth

### 🎯 Executive Summary
Deployment of physical and logical Security Baselines to mitigate common attack vectors. The strategy prioritizes endpoint hardening via GPOs and strengthening the domain's credential policies through PowerShell automation.

### 🛠️ Execution & Deployment Log

#### 1. GPO: Physical Data Loss Prevention (DLP)
- **Policy Name:** `Acme - SEC - USB Block`
- **Scope & Link:** `Computer Configuration` -> Linked to `OU=Equipos`.
- **Path:** `Policies → Admin Templates → System → Removable Storage Access → All Removable Storage classes: Deny all access`.
- **Security Rationale:** Mitigates data exfiltration and physical malware execution vectors (e.g., MITRE ATT&CK T1091). Applied at the machine level to prevent bypass via local privilege escalation or user switching.

#### 2. GPO: Unattended Workstation Mitigation
- **Policy Name:** `Acme - SEC - Screen Lock (600s)`
- **Scope & Link:** `Computer Configuration` -> Linked to `OU=Equipos`.
- **Path:** `Policies → Windows Settings → Security Settings → Local Policies → Security Options → Interactive logon: Machine inactivity limit` (Set to: 600 seconds).
- **Security Rationale:** Closes opportunistic *Insider Threat* gaps and ensures physical access compliance in corporate environments.

#### 3. Domain-Level Password Hardening
- **Objective:** Fortify the `Default Domain Policy` against brute-force and password spraying attacks.
- **Implementation:** Automated deployment via PowerShell on DC01.
- powershell
# Audit current baseline
Get-ADDefaultDomainPasswordPolicy

# Harden password policy (Root Domain Level)
Set-ADDefaultDomainPasswordPolicy -Identity acme.local `
    -MinPasswordLength 10 `
    -ComplexityEnabled $true `
    -MaxPasswordAge "60.00:00:00" `
    -LockoutThreshold 5 `
    -LockoutDuration "00:30:00" 


## Day 3 (week 2) - 2026-05-27

### Done
- VM FILE01 created on VMnet10 (Host-Only, 192.168.50.0/24)
- Windows Server 2022 Standard Evaluation installed (Desktop Experience, EN UI / ES keyboard)
- VMware Tools installed and unnecessary legacy virtual devices removed
- Static IP configured via PowerShell: 192.168.50.20/24
- DNS pointed strictly to DC01 (192.168.50.10) to guarantee correct domain resolution
- Host renamed to FILE01
- Joined to `acme.local` domain successfully
- Computer object moved from default `CN=Computers` to `OU=Servidores,OU=Acme,DC=acme,DC=local` via PowerShell (executed from DC01)
- Setup documented in `01-servers/FILE01/setup.md`

### Issues encountered
- None. Process was streamlined leveraging scripts and mental models from Day 2.

### Time spent
- 1,5 h 

### Lessons reinforced
- **DNS is the compass for Member Servers:** Unlike a DC, a member server cannot rely on loopback (127.0.0.1) or external DNS (like 8.8.8.8) for primary resolution. It must point to the DC to resolve the SRV records required for the domain join. Misconfiguring this is a guaranteed point of failure.
- **Active Directory structure logic:** New objects default to `CN=Computers`. This is a *Container*, not an *Organizational Unit (OU)*, meaning GPOs cannot be directly linked to it. Moving the server to a dedicated OU immediately after joining is a non-negotiable step for scalable configuration management.

## Day 4 (week 2)- 2026-05-28

### Done
- Created physical directory structure for File Server (`C:\Shares\RRHH`, `C:\Shares\Comun`).
- Provisioned SMB Network Shares.
- Configured Share vs NTFS permissions following industry best practices:
  - **Share Permissions:** Set to `Authenticated Users - Full Control` to act as an open gateway.
  - **NTFS Permissions:** Disabled inheritance, purged default rules, and applied explicit granular controls (`ACME\RRHH` -> Modify, `Domain Admins` -> Full Control, `SYSTEM` -> Full Control).
- Validated access restrictions successfully from `CLIENT01` (user `laura.garcia`).
- Configured Group Policy (GPO) to automatically map `\\FILE01\RRHH` to drive `Z:` for targeted users.
- Documented INC-003 regarding Share vs NTFS troubleshooting logic.

### Time spent
- 1h 30m

### Lessons reinforced
- **The "Two Doors" rule:** Share permissions and NTFS permissions evaluate together, but the most restrictive wins. Attempting to manage granular access at the Share level breaks scalability. Standardize open Share permissions and lock down at the NTFS level.
- **Kerberos TGT caching:** Adding a user to an AD group does not grant immediate access to a resource if they are currently logged in. The Kerberos token must be regenerated via a fresh login.

## Day 5 (week 2 ) | 2026-05-29

### Done
- **Block A: Infrastructure**
  - Deployed UBUNTU01 VM on VMnet10 (1GB RAM, 20GB disk).
  - Installed Ubuntu Server 22.04 LTS (CLI only) to enforce terminal-based management.
  - Configured static IP during setup: 192.168.50.30/24, GW: 192.168.50.1, DNS: 192.168.50.10.
  - Created local admin `acmeadmin` and installed OpenSSH Server.
  - Executed initial updates (`sudo apt update && sudo apt upgrade -y`).

- **Block B: Linux Fundamentals**
  - Mapped Windows admin concepts to Linux equivalents.
  - Practiced service management (`systemctl`), network diagnostics (`ip addr`, `ss -tulpn`), permission handling (`chmod`, `chown`), and log auditing (`journalctl`, `tail /var/log/syslog`).

- **Block C: PowerShell Automation**
  - Developed `New-BulkADUsers.ps1`: Automated AD user creation from CSV, handling UPN generation and enforcing default password resets.
  - Developed `Get-DCHealthReport.ps1`: Automated domain health checks (ADWS, DNS, Netlogon), DHCP scope usage metrics, and ID 4625 (logon failure) security event parsing.

- **Closing Actions**
  - Documented UBUNTU01 setup in `01-servers/UBUNTU01/setup.md`.
  - Added script documentation in `04-scripts/powershell/README.md`.
  - Taken BASE snapshot of UBUNTU01.
  - Pushed large commit to GitHub.
  - Completed 30 minutes of technical English practice.

### Issues encountered
- (none / describe here if any arose during Linux setup or script execution)

### Time spent
- 5h (Heavy deployment and scripting day)
## Saturday (Week 2 close) — 2026-05-31

### Done
- Cybersecurity layer:
  - Privileged account audit script (CSV export for compliance evidence)
  - Account compromise scenario: detection -> containment -> remediation
  - Hardening GPO: audit policy, firewall on all profiles
- Three new incidents documented (INC-005, INC-006, INC-007):
  - Service down (Print Spooler) - includes recovery actions hardening
  - Intermittent connectivity - OSI bottom-up method
  - GPO not applying - five common root causes
- PORTFOLIO.md created as guided tour for recruiters/interviewers
- 10 portfolio screenshots captured and committed
- CV updated with Week 2 competencies and bullets

### Concepts internalized
- Incident response pattern (D-C-I-R-LL)
- Least-privilege principle applied to AD groups
- Continuous measurement for intermittent issues
- Five common reasons a GPO does not apply
- Service recovery actions for self-healing

### Time spent
- ~5h

### WEEK 2 COMPLETE
Differentiation layer in place. Portfolio ready to send.

## Saturday (Week 2 close) — 2026-05-31

### Done
- Cybersecurity layer:
  - Privileged account audit script (CSV export for compliance evidence)
  - Account compromise scenario: detection -> containment -> remediation
  - Hardening GPO: audit policy, firewall on all profiles
- Three new incidents documented (INC-005, INC-006, INC-007):
  - Service down (Print Spooler) - includes recovery actions hardening
  - Intermittent connectivity - OSI bottom-up method
  - GPO not applying - five common root causes
- PORTFOLIO.md created as guided tour for recruiters/interviewers
- 10 portfolio screenshots captured and committed
- CV updated with Week 2 competencies and bullets

### Concepts internalized
- Incident response pattern (D-C-I-R-LL)
- Least-privilege principle applied to AD groups
- Continuous measurement for intermittent issues
- Five common reasons a GPO does not apply
- Service recovery actions for self-healing

### Time spent
- ~5h

### WEEK 2 COMPLETE
Differentiation layer in place. Portfolio ready to send.
