# Portfolio Tour — Acme Solutions Homelab

> A guided walkthrough of this lab for recruiters and technical interviewers.
> Estimated reading time: 5 minutes. Estimated tour time: 15 minutes.

## What this repo proves

A working **IT Support technical profile** built around hands-on practice
rather than coursework. The lab simulates a 25-employee Spanish SMB
infrastructure and demonstrates the competencies most asked for in Madrid's
L1/L2 support job market.

## Recommended reading order

If you have **2 minutes** → read this file and the [`README.md`](README.md).

If you have **10 minutes** → also read:
1. [`00-architecture/decisions.md`](00-architecture/decisions.md) — Why I built it this way (6 ADRs).
2. [`03-incidents/`](03-incidents/) — Pick any 2 incident playbooks.

If you have **30 minutes** → also review:
1. [`01-servers/DC01/`](01-servers/DC01/) — Setup, AD structure, DHCP config.
2. [`04-scripts/powershell/`](04-scripts/powershell/) — Automation scripts with documented intent.

## What is demonstrated

### Infrastructure
- Active Directory Domain Services on Windows Server 2022
  (`acme.local` forest, single DC, integrated DNS).
- DHCP server **authorized in AD**, scope with proper option configuration.
- File server (FILE01) with NTFS and Share permissions correctly layered.
- Linux server (Ubuntu 22.04) for cross-platform exposure.

### Identity and policy
- Custom OU structure (Acme > Usuarios / Grupos / Equipos / Servidores).
- 5+ GPOs covering legal notice, security baseline, drive mapping, USB lockdown,
  password policy.
- Default domain password policy hardened.

### Security
- Privileged account auditing (least-privilege principle).
- Incident response pattern applied (detection → containment → investigation →
  remediation → lessons learned).
- Audit policy enabled by GPO (events 4624, 4625, 4740 captured).
- Account lockout policy enforced.

### Operations and automation
- 7 incidents simulated, diagnosed and documented as service-desk playbooks.
- PowerShell scripts for bulk user provisioning, DC health checks,
  privileged-account audit (with CSV evidence export).
- Snapshot strategy documented as ADR-004.

### Discipline signals (what you don't always see in junior portfolios)
- **Architecture Decision Records** for every significant choice.
- **English-language documentation** (passive English-skill signal).
- **Conventional Commits** throughout.
- **Daily journal** showing iterative progress, not retrofitted writing.

## Topology at a glance

See [`00-architecture/topology.md`](00-architecture/topology.md).

## Incident catalog (the proof of "support with technical judgment")

| ID      | Title                                       | Category          |
|---------|---------------------------------------------|-------------------|
| INC-001 | Client does not receive an IP address       | Network / DHCP    |
| INC-002 | Name resolution fails, IP works             | Network / DNS     |
| INC-003 | User cannot access shared folder            | Permissions       |
| INC-004 | Account potentially compromised             | Security / IR     |
| INC-005 | Print Spooler service stopped               | Services          |
| INC-006 | Intermittent network connectivity           | Network L1/L2     |
| INC-007 | GPO not applying to workstation             | AD / GPO          |

Every incident follows the same format: symptom, step-by-step diagnosis,
root cause, resolution, common junior pitfall, and how to explain it in an
interview.

## Stack

VMware Workstation Pro 17 · Windows Server 2022 · Windows 10 Pro
· Ubuntu Server 22.04 LTS · PowerShell · Bash · Git / GitHub

## About me

[Tu nombre] — SMR graduate, based in Madrid, in active search for IT Support
roles (L1/L2). LinkedIn: [link] · Email: [link]