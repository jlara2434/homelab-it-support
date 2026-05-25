# INC-001 — User cannot access company resources or internal sites

| Field      | Value                          |
|------------|--------------------------------|
| Severity   | Medium                         |
| Affected   | CLIENT01 / user laura.garcia   |
| Category   | Network / DNS                  |

## Symptoms
- User reports no access to internal resources.
- Browsing to internal hostnames fails.
- Ping to the DC by IP works; ping by name fails.

## Diagnosis (step by step)
1. `ping 192.168.50.10` → success → physical/IP connectivity is fine.
2. `ping dc01.acme.local` → fails → name resolution problem.
3. `nslookup acme.local` → does not resolve the internal record.
4. `ipconfig /all` → DNS server set to 8.8.8.8 (public DNS).

## Root cause
The client was using a public DNS server (8.8.8.8). Domain clients must use
the internal DNS (the DC) to resolve AD SRV records and internal hostnames.
A public DNS has no knowledge of the internal `acme.local` zone.

## Resolution
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 192.168.50.10
Clear-DnsClientCache
```

## Typical junior mistake
Assuming "no Internet/no resources" means a connectivity or cable issue, and
restarting the router. The cable was fine — DNS resolution was the problem.
Another mistake: setting 8.8.8.8 "to fix Internet", which breaks domain resolution.

## How to explain it in an interview
"Ping by IP worked but by name failed, which isolates the problem to name
resolution. The client had a public DNS configured; domain clients must use
the internal DNS to resolve AD records. I restored the internal DNS and
flushed the cache. Root cause: incorrect DNS assignment, not connectivity."