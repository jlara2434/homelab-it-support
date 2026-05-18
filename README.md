# homelab-it-support
Realistic SMB infrastructure lab — Active Directory, GPOs, networking, troubleshooting
# Acme Solutions — Homelab IT Support

Realistic IT infrastructure lab simulating a 25-employee SMB based in Madrid (Spain).
Built to practice and document hands-on competencies for an IT Support Technician role (L1/L2)
in a production-like environment.

## Stack

- **Hypervisor:** VMware Workstation Pro 17
- **Servers:** Windows Server 2022, Ubuntu Server 22.04 LTS
- **Client:** Windows 10 Enterprise
- **Core services:** Active Directory Domain Services, DNS, DHCP, File Server, GPOs
- **Differentiation layer:** PowerShell automation, basic cybersecurity hardening, ticketing simulation

## Network topology

See [`00-architecture/topology.md`](00-architecture/topology.md).

## Architecture decisions

See [`00-architecture/decisions.md`](00-architecture/decisions.md) — formal ADRs for every significant technical choice.

## Documented incidents

See [`03-incidents/`](03-incidents/) — real-world style cases with symptoms, diagnosis steps,
exact commands and resolution.

## Automation scripts

See [`04-scripts/`](04-scripts/) — PowerShell (Windows) and Bash (Linux) automation.

## Repository structure

> 🚧 Actively developed lab — updated weekly.