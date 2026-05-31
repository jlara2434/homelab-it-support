# INC-006 — Intermittent network connectivity

| Field        | Value                              |
|--------------|------------------------------------|
| Incident ID  | INC-006                            |
| Severity     | High (intermittent service loss)   |
| Affected     | CLIENT01                           |
| Category     | Network / L1-L2                    |
| Status       | Resolved                           |

## Symptom
End user reports that network access "comes and goes" — works for periods,
then drops, then recovers. Application-level errors are inconsistent.

## Why intermittent issues are special
Intermittent faults cannot be diagnosed by snapshot commands. Required tools
are **continuous measurement** and **historical logs**, not point-in-time checks.

## Diagnosis (step by step)
1. Established a baseline with continuous ping: 60 attempts, 18 failed,
   30% packet loss. Confirmed intermittence, not a misperception.
2. Verified adapter status in real time:
   `Get-NetAdapter` — saw the adapter transitioning between Up and Disabled.
3. Reviewed System log filtered by NDIS provider:
   recurring state-change events matched the ping pattern.
4. Ruled out IP conflict (DHCP log on DC showed normal lease behavior).
5. Conclusion: physical/datalink layer flapping (Layer 1/2 OSI).

## Method applied: bottom-up by OSI layer
Intermittent symptoms require methodical layer-by-layer diagnosis,
starting at the lowest layer (physical/datalink) because failures there
manifest as random higher-layer issues.

## Root cause
Repeated adapter state transitions (link flapping). In a real environment
this is typically caused by:
- A faulty patch cable or RJ45 connector
- Defective switch port
- Outdated NIC driver

## Resolution
1. Forced the adapter up: `Enable-NetAdapter -Name "Ethernet0"`.
2. Renewed DHCP lease (`ipconfig /release` + `/renew`) to ensure clean state.
3. Validated 30 seconds of stable connectivity before considering resolved.
4. In production, next step would be physical inspection of cable and port.

## Junior pitfall
Diagnosing intermittent faults with snapshot commands. If you ping once and
it works, you conclude "the network is fine" and miss the real problem.
**Intermittent faults require continuous measurement** — at least 60 samples
to establish a packet-loss baseline.

## How I would explain this in an interview
"For intermittent network issues I never trust a single command. I start a
continuous ping for at least a minute to quantify packet loss, then check
adapter status in real time, and finally review system logs filtered by the
network provider to find state-change patterns. Bottom-up by OSI layer:
physical/datalink first, then network, then application. Intermittence is
almost always Layer 1 or 2 until proven otherwise."

## Prevention
- Centralized monitoring (e.g. PRTG, Zabbix) with continuous availability checks.
- Cable certification policy: cables with >X errors/min get replaced.
- Switch port error-rate alerting.