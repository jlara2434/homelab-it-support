# DC01 — DHCP configuration

## Role
DHCP server for the Acme internal LAN, running on DC01.
Authorized in Active Directory.

## Why DHCP runs authorized in AD
In a domain environment, a DHCP server must be authorized in AD before it
will lease addresses. This is a security control against rogue DHCP servers
(unauthorized devices handing out IPs to perform man-in-the-middle attacks).
A DHCP service can show "Running" yet refuse to lease IPs if it is not
authorized. Always verify with `Get-DhcpServerInDC`.

## Scope
| Parameter      | Value                     |
|----------------|---------------------------|
| Scope name     | Acme-LAN-50               |
| Range          | 192.168.50.100 – .200     |
| Subnet mask    | 255.255.255.0             |
| Lease duration | 8 days                    |
| State          | Active                    |

## Scope design rationale
- Range starts at .100 to leave .1–.99 for static assignments
  (servers, printers, network gear). Never lease the full subnet.
- DC itself (.10) is intentionally OUTSIDE the DHCP range to avoid
  an IP conflict that would knock the DC offline.

## Scope options
| Option | ID | Value          | Purpose                |
|--------|----|----------------|------------------------|
| Router | 3  | 192.168.50.1   | Default gateway        |
| DNS    | 6  | 192.168.50.10  | Internal DNS (the DC)  |
| Domain | 15 | acme.local     | DNS suffix             |

## Critical note on DNS option
Option 6 points to the internal DC (192.168.50.10), NOT a public DNS.
Domain clients must use internal DNS to resolve AD SRV records, otherwise
Kerberos authentication and domain join will fail.

## Key commands
```powershell
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerSecurityGroup
Add-DhcpServerInDC -DnsName "dc01.acme.local" -IPAddress 192.168.50.10
Add-DhcpServerv4Scope -Name "Acme-LAN-50" -StartRange 192.168.50.100 `
    -EndRange 192.168.50.200 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.50.0 -OptionId 3 -Value 192.168.50.1
Set-DhcpServerv4OptionValue -ScopeId 192.168.50.0 -OptionId 6 -Value 192.168.50.10
Set-DhcpServerv4OptionValue -ScopeId 192.168.50.0 -OptionId 15 -Value "acme.local"
```

## Validation
- Get-DhcpServerInDC: server authorized
- Get-DhcpServerv4Scope: scope active
- Get-DhcpServerv4ScopeStatistics: 101 free, 0 in use (no clients yet)
- End-to-end test (client receives IP) deferred to client deployment day.