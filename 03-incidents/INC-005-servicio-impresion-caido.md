# INC-005 — Print Spooler service stopped

| Field        | Value                          |
|--------------|--------------------------------|
| Incident ID  | INC-005                        |
| Severity     | Medium (users cannot print)    |
| Affected     | CLIENT01 (single workstation)  |
| Category     | Services / Print               |
| Status       | Resolved                       |

## Symptom
Users report inability to print. The "Devices and Printers" panel returns
the error "The print spooler service is not running".

## Diagnosis (step by step)
1. Confirmed service state: `Get-Service Spooler` → Status: Stopped.
2. Checked System log for the stop event:
   `Get-WinEvent -FilterHashtable @{LogName='System'; Id=7036}` filtered by Spooler.
   Found the exact timestamp the service transitioned to Stopped, with no
   prior failure event — suggesting manual stop or external action.
3. No signs of underlying corruption (no Application log errors related to Spooler).

## Root cause
Print Spooler service stopped (manually or by another process). No persistent
fault detected.

## Resolution
1. `Start-Service Spooler` to restart the service.
2. `Set-Service Spooler -StartupType Automatic` to ensure it starts on boot.
3. Configured recovery actions to auto-restart on failure:
   `sc.exe failure Spooler reset= 86400 actions= restart/5000/restart/5000/restart/5000`
4. Validated by reopening the Devices and Printers panel — no error.

## Junior pitfall
Restarting the whole machine when a service restart would have sufficed.
Reboots hide root causes and waste user time. Always identify the failing
component first.

## How I would explain this in an interview
"For a print failure I check the Spooler service first — it's the single most
common point of failure in Windows printing. `Get-Service Spooler` shows
state. If stopped, I check the System log filtered by event 7036 to see when
and why. I restart the service, set startup type to Automatic, and configure
recovery actions so it auto-restarts on future failures. Reboots are the last
resort, never the first."

## Prevention
- Service set to Automatic startup.
- Recovery actions configured (3 retries, 5s interval).
- Consider centralized monitoring (SCOM, Zabbix, PRTG) to alert on service stops.