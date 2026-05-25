# Network topology — Acme Homelab

## Logical diagram

┌─────────────────────────────────────┐
                │  HOST: Windows + VMware Workstation  │
                │  Pro 17  ·  32 GB RAM  ·  NVMe SSD    │
                └──────────────────┬───────────────────┘
                                   │
                      VMnet10 (Host-Only)
                      192.168.50.0/24
                      DHCP: provided by DC01
                      DNS:  provided by DC01
                                   │
   ┌───────────────┬───────────────┼───────────────┬───────────────┐
   │               │               │               │               │
┌────▼─────┐   ┌─────▼─────┐   ┌─────▼──────┐  ┌──────▼─────┐
│  DC01    │   │  FILE01   │   │ CLIENT01   │  │ UBUNTU01   │
│ (static) │   │ (static)  │   │  (DHCP)    │  │ (static)   │
│.50.10    │   │.50.20     │   │.100-.200   │  │.50.30      │
│          │   │ [pending] │   │ [pending]  │  │ [pending]  │
│ AD DS    │   │ File srv  │   │ Win 11     │  │ Ubuntu     │
│ DNS      │   │ Shares    │   │ Domain-    │  │ Server     │
│ DHCP     │   │ GPOs      │   │ joined     │  │ 22.04      │
└──────────┘   └───────────┘   └────────────┘  └────────────┘ 

## Addressing plan

| Range            | Purpose                          | Assignment |
|------------------|----------------------------------|------------|
| .1               | Default gateway (logical)        | Reserved   |
| .2  – .99        | Static: servers, printers, gear  | Manual     |
| .10              | DC01 (AD DS / DNS / DHCP)        | Static     |
| .20              | FILE01 (file server)             | Static     |
| .30              | UBUNTU01 (Linux services)        | Static     |
| .100 – .200      | DHCP pool for clients            | DHCP       |
| .201 – .254      | Reserved for growth              | —          |

## Core services (current state)

| Service | Host  | Status   |
|---------|-------|----------|
| AD DS   | DC01  | ✅ Live   |
| DNS     | DC01  | ✅ Live   |
| DHCP    | DC01  | ✅ Live (authorized in AD) |
| File    | FILE01| ⏳ Pending |

## Design principles
- Single authoritative DHCP and DNS (the DC), as in production SMBs.
- DC IP intentionally outside the DHCP pool to prevent IP conflicts.
- Static range reserved below the DHCP pool for infrastructure devices.
- Domain segment isolated from Internet by default (security by design).

> 🚧 To be populated on Day 5.
