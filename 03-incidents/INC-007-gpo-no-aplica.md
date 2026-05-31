# INC-007 — GPO not applying to workstation

| Field        | Value                            |
|--------------|----------------------------------|
| Incident ID  | INC-007                          |
| Severity     | Medium (security policy bypassed)|
| Affected     | CLIENT01                         |
| Category     | Active Directory / GPO           |
| Status       | Resolved                         |

## Symptom
User reports that USB storage works on their workstation, despite a
domain-wide policy ("Acme - Bloqueo USB") that should block it.

## Diagnosis (step by step)
1. Ran `gpresult /r` on the affected workstation. The Computer Settings
   section listed all applied GPOs but **did not include** "Acme - Bloqueo USB".
2. Generated an HTML report with `gpresult /h C:\gpreport.html /f`.
   In the report, the missing GPO did not appear at all (not even Denied),
   suggesting the workstation was not in the scope of the GPO link.
3. Queried the computer object location:
   `Get-ADComputer CLIENT01 | Select DistinguishedName`
   Result: `CN=CLIENT01,CN=Computers,DC=acme,DC=local`.
4. The GPO is linked to `OU=Equipos,OU=Acme,DC=acme,DC=local`.
   The default container `CN=Computers` is **not** the same as `OU=Equipos`
   and does not receive policies linked to OUs underneath the Acme tree.

## Root cause
The computer object was located in the default `CN=Computers` container
instead of the dedicated `OU=Equipos`. GPOs are scoped by the OU they are
linked to; objects outside that scope do not receive them.

## Resolution
1. On DC01: moved the computer object to the correct OU:
   `Get-ADComputer CLIENT01 | Move-ADObject -TargetPath "OU=Equipos,OU=Acme,DC=acme,DC=local"`
2. On CLIENT01: `gpupdate /force` to refresh.
3. Rebooted the workstation (computer-side GPO settings apply at boot).
4. Validated with `gpresult /r` that the "Acme - Bloqueo USB" GPO now appears
   under Applied Group Policy Objects.
5. Verified by attempting to use a USB drive — access denied as expected.

## Junior pitfall
Believing that "every computer in the domain receives every GPO". GPOs apply
by **scope**: an object only receives GPOs linked to its OU (or to OUs above
it in the hierarchy, by inheritance). The default `CN=Computers` container
is not part of the custom OU tree and is a classic blind spot.

## The five most common reasons a GPO does not apply
1. The object is in the wrong OU.
2. Security Filtering excludes the user/computer.
3. A WMI Filter narrows the scope and excludes the object.
4. Block Inheritance is set on an intermediate OU.
5. The GPO link itself is disabled.

## How I would explain this in an interview
"For 'a GPO does not apply' I follow a fixed checklist. First `gpresult /r`
on the target — if the GPO doesn't appear at all, it's a scope problem,
likely OU mismatch. If it appears as Denied, I check Security Filtering and
WMI Filters. I also verify the link is enabled and not blocked by inheritance.
The single most common cause I've seen is the object in the wrong OU."

## Prevention
- Automate placement of new computer objects into the correct OU
  (`redircmp` to redirect default computer creation, or a join script).
- Periodic AD audit script flagging objects still in `CN=Computers`.
- Document the OU structure clearly so the support team knows where things go.