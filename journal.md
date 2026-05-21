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
