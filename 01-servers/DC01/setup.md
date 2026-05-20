# DC01 — Domain Controller — acme.local

## Role
Primary Domain Controller for the `acme.local` Active Directory forest.
Hosts AD DS, DNS and DHCP.

## Hardware specs (VMware)
| Resource          | Value                                  |
|-------------------|----------------------------------------|
| OS                | Windows Server 2022 Standard Eval (Desktop Experience) |
| vCPU              | 2                                      |
| RAM               | 2 GB                                   |
| Disk              | 60 GB NVMe, thin provisioned           |
| Network adapter   | Custom — VMnet10 (Host-Only)           |
| Firmware          | UEFI                                   |

## Network configuration
| Parameter   | Value             |
|-------------|-------------------|
| IP          | 192.168.50.10/24  |
| Gateway     | 192.168.50.1      |
| DNS primary | 127.0.0.1 (self)  |
| Hostname    | DC01              |
| Domain      | (not joined yet — pending Day 3 promotion) |

## Install log
1. Base install of Windows Server 2022 Standard with Desktop Experience.
2. Spanish keyboard layout, English OS interface.
3. VMware Tools installed for clipboard/network/display integration.
4. Disabled Floppy, Sound and Printer virtual devices for performance.
5. Static IP configured via PowerShell:
   - Removed APIPA address.
   - Assigned 192.168.50.10/24, GW 192.168.50.1, DNS 127.0.0.1.
6. Renamed host to DC01 (PowerShell `Rename-Computer`).
7. Windows Update skipped — VM intentionally isolated from Internet
   on VMnet10. Patching deferred until controlled session via NAT.

## Commands used (key)
```powershell
$ifAlias = (Get-NetAdapter | Where-Object Status -eq 'Up').Name
New-NetIPAddress -InterfaceAlias $ifAlias `
                 -IPAddress 192.168.50.10 -PrefixLength 24 `
                 -DefaultGateway 192.168.50.1
Set-DnsClientServerAddress -InterfaceAlias $ifAlias -ServerAddresses 127.0.0.1
Rename-Computer -NewName "DC01" -Force
```

## Next steps (Day 3)
- Reboot to apply hostname change.
- Install AD DS role.
- Promote server as the first DC of new forest `acme.local`.
- Run dcdiag and verify health.

---

## Day 3 — AD DS role install and forest promotion

### What was done
1. Verified prerequisites: hostname=DC01, static IP=192.168.50.10/24,
   DNS=127.0.0.1, no extra roles installed.
2. Installed AD DS role with management tools:
   `Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools`
3. Promoted DC01 as first DC of new forest `acme.local`:
   - Forest mode: Windows2016Forest (`WinThreshold`)
   - Domain mode: Windows2016Domain (`WinThreshold`)
   - NetBIOS name: ACME
   - Integrated DNS installed at the same time
   - DSRM password stored in personal password manager
4. Automatic reboot after promotion.
5. Post-promotion validation:
   - `Get-ADDomainController` and `Get-ADDomain` returned expected values
   - `dcdiag /v`: all critical tests pass (FrsEvent ignored — DFSR is used now)
   - DNS SRV records verified: `_ldap`, `_kerberos`, `_gc`
   - `repadmin /replsummary`: no failures (single DC environment)

### Functional level rationale
Chose `WinThreshold` (Windows Server 2016 functional level) — the highest available.
Microsoft did not introduce 2019 or 2022 functional levels. WinThreshold remains
the modern baseline and is backward-compatible with any DC from 2016 onwards.

### Domain name rationale (`acme.local`)
Used `.local` for clarity and ease of identification as internal-only.
Modern Microsoft recommendation is `corp.<public_domain>` (subdomain of a real
public DNS namespace owned by the org), but `.local` is acceptable for an
isolated lab and historically widespread in Spanish SMBs.

### Why static IP and DNS=self were prerequisites
A DC must have a stable IP because AD's database references it directly.
DNS pointing to self (127.0.0.1) is the Microsoft-recommended pattern for
the first DC: it must resolve its own zone immediately upon DNS service start.

### Validation commands
```powershell
Get-ADDomainController
Get-ADDomain
Get-ADForest
dcdiag /v
nslookup -type=SRV _ldap._tcp.acme.local
repadmin /replsummary
```

### Next steps (Day 4)
- Install DHCP role on DC01.
- Create scope 192.168.50.100–200, options 3/6/15.
- Authorize the DHCP server in Active Directory (critical step).