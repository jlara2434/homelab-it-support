# Architecture Decision Records — Acme Homelab

This file collects every significant technical decision made for this lab.
Format: ADR (Context, Decision, Alternatives, Consequences).

Formal record of every significant technical decision in this lab.
Format: Context · Decision · Alternatives considered · Consequences.

---

## ADR-001 — Active Directory domain instead of Workgroup

### Context
The lab simulates a 25-employee SMB needing centralized management of
users, permissions and policies.

### Decision
Deploy Active Directory Domain Services. The whole environment is
domain-joined from the start.

### Alternatives considered
- **Workgroup:** rejected — no centralized auth, no GPOs, does not scale.
- **Entra ID (Azure AD) only:** rejected — the target job market asks for
  on-premise AD skills (L1/L2 support), not cloud-only identity.

### Consequences
- (+) Enables GPOs, centralized management, Kerberos authentication.
- (+) Mirrors ~80% of real SMB environments.
- (–) Requires a DC always available and internal DNS as hard dependency.

---

## ADR-002 — Host-Only network (VMnet10), DC-provided DHCP

### Context
The lab must be isolated from the host's real home network to avoid
contaminating it with a second DHCP server or DNS authority.

### Decision
Use a custom VMnet10 (Host-Only), subnet 192.168.50.0/24, with VMware's
own DHCP disabled. The domain controller provides DHCP.

### Alternatives considered
- **Bridged:** rejected — the lab DC's DHCP would hand out IPs on the real
  LAN, potentially breaking home connectivity (rogue DHCP).
- **NAT default:** rejected for the domain segment — less control over
  addressing; reserved as a temporary adapter only for patching.

### Consequences
- (+) Domain fully isolated; safe to break and rebuild.
- (+) Realistic: a single authoritative DHCP/DNS, as in production.
- (–) No direct Internet on the domain segment (intentional; patch via
  temporary NAT adapter when needed).

---

## ADR-003 — Naming convention

### Context
Screenshots and documentation should look like a production environment,
not a sandbox.

### Decision
Adopt corporate naming from day one: domain `acme.local`, hosts `DC01`,
`FILE01`, `CLIENT01`, `UBUNTU01`; root OU `Acme`; NetBIOS `ACME`.

### Alternatives considered
- **Ad-hoc names (test1, server-new):** rejected — unprofessional, hard to scale.

### Consequences
- (+) Documentation and screenshots read as production-grade.
- (+) Easy mental mapping of role → hostname.
- (–) None significant.

---

## ADR-004 — Snapshot strategy

### Context
The lab is meant to be broken on purpose (incident simulation) and rebuilt.
Snapshots must allow fast recovery without disk bloat.

### Decision
Named snapshots at clean milestones only: EMPTY-VM, BASE-CLEAN,
ROLES-INSTALLED, DOMAIN-READY, plus PRE-INCIDENT before each simulated fault.
Maximum ~5 live snapshots per VM; consolidate older ones.

### Alternatives considered
- **No snapshots:** rejected — rebuilding from scratch wastes hours.
- **Snapshot before every tiny change:** rejected — disk bloat, performance hit.

### Consequences
- (+) Fast rollback to known-good states.
- (+) Safe environment to experiment with faults.
- (–) Disk overhead (mitigated by the 5-snapshot cap).

---

## ADR-005 — Documentation-first, public GitHub repo

### Context
The lab's value as a portfolio depends on visible, professional documentation
produced as work happens, not retro-fitted at the end.

### Decision
Public GitHub repo from day one. Document each milestone the same day.
Conventional Commits format. English-language documentation.

### Alternatives considered
- **Document at the end:** rejected — context is lost; documentation never happens.
- **Private repo:** rejected — defeats the portfolio purpose.

### Consequences
- (+) Portfolio builds itself incrementally.
- (+) English docs double as a passive English-skill signal.
- (–) Requires discipline (a daily commit habit).

---

## ADR-006 — Upgrade to VMware Workstation Pro 17

### Context
Workstation 16 hid pure Host-Only VMnets in the New VM wizard, blocking
the intended network design. Outdated tooling introduced friction.

### Decision
Upgrade to Workstation Pro 17 (free for personal use since May 2024).

### Alternatives considered
- **Stay on 16, bind a host adapter to the VMnet:** rejected — compromises
  isolation; works around the symptom, not the cause.
- **Use VMnet1 default Host-Only:** rejected — random subnet, breaks the
  documented addressing plan.

### Consequences
- (+) Custom VMnet selection works (via Customize Hardware in WS17).
- (+) Better performance and Hyper-V coexistence.
- (–) ~40 min one-time upgrade cost.

### Lesson
Outdated software hides working configuration behind UI bugs. When a
documented option is missing, verify product/version/edition before
assuming a defect — and check whether the option simply moved.

---
| Parámetro | Valor | Significado |
| :--- | :--- | :--- |
| `-DomainName` | `acme.local` | FQDN del nuevo dominio raíz |
| `-DomainNetbiosName` | `ACME` | Nombre corto (legacy, usado en logins como `ACME\usuario`). Máx 15 chars |
| `-ForestMode` | `WinThreshold` | Functional level Windows Server 2016+. Compatible con todo lo moderno |
| `-DomainMode` | `WinThreshold` | Mismo nivel que el bosque |
| `-InstallDns` | `$true` | Instala el rol DNS y crea zonas integradas en AD |
| `-DatabasePath` | `C:\Windows\NTDS` | Ubicación de NTDS.dit (base de datos de AD). Default OK para lab |
| `-LogPath` | `C:\Windows\NTDS` | Logs de transacciones de AD |
| `-SysvolPath` | `C:\Windows\SYSVOL` | Ubicación de SYSVOL (GPOs replicadas, scripts) |
| `-SafeModeAdministratorPassword` | `$dsrmPassword` | Contraseña DSRM |
| `-NoRebootOnCompletion:$false` | (reinicia automático) | Tras completar, reinicia. Necesario para que AD arranque |
| `-Force:$true` | (sin confirmar) | Salta los prompts interactivos |
> 🚧 To be populated on Day 5.
