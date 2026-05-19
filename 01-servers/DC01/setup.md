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