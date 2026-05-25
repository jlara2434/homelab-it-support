# INC-002 — Equipment does not obtain an IP address

| Field      | Value                                  |
|------------|----------------------------------------|
| Severity   | High                                   |
| Affected   | CLIENT01 / user                        |
| Category   | Network / IP Configuration             |

## Symptoms
- User reports no access to anything (no network or Internet).
- Complete loss of connectivity to domain resources.

## Diagnosis (step by step)
1. `ipconfig /all` → shows IP 10.0.0.50, on a different network (10.0.0.0/24) than the domain (192.168.50.0/24).
2. `ping 192.168.50.10` → fails → the client is on another network, cannot reach the DC.
3. Technician identifies: incorrect network IP, does not match the LAN.

## Root cause
The client adapter was manually configured with an incorrect static IP address (10.0.0.50) outside the correct LAN subnet. Because the machine was placed in a different network segment, it lost all routing capabilities and could not communicate with the Domain Controller or the internal network.

## Resolution
```powershell
# Revert to DHCP (the correct setting for a client endpoint)
$ifAlias = (Get-NetAdapter | Where-Object Status -eq 'Up').Name

# Remove the incorrect static IP and routing
Remove-NetIPAddress -InterfaceAlias $ifAlias -IPAddress 10.0.0.50 -Confirm:$false -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceAlias $ifAlias -Confirm:$false -ErrorAction SilentlyContinue

# Re-enable DHCP for IP and DNS
Set-NetIPInterface -InterfaceAlias $ifAlias -Dhcp Enabled
Set-DnsClientServerAddress -InterfaceAlias $ifAlias -ResetServerAddresses

# Renew IP lease
ipconfig /renew

# Validate network configuration
ipconfig /all   # should return to 192.168.50.1xx via DHCP
ping 192.168.50.10
```

## Typical junior mistake
Assuming "the equipment doesn't get an IP" or "no Internet" means a physical connectivity issue, a bad cable, or a broken switch port. Another mistake: restarting the router blindly instead of checking `ipconfig /all` to realize that a static IP was hardcoded in the wrong subnet.

## How to explain it in an interview
"A user reported a total loss of connectivity. Using `ipconfig /all`, I identified that the machine had an incorrect static IP assigned from a completely different subnet than our domain LAN. I used PowerShell to strip the wrong static IP and routing, re-enabled DHCP on the adapter, and renewed the lease. Once it pulled a valid IP, I verified connectivity by pinging the DC. Root cause: manual IP misconfiguration, not a network outage."