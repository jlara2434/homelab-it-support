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
