acme.local
└── Acme                 (root OU, protected from accidental deletion)
├── Usuarios         (employee accounts)
├── Grupos           (security groups)
├── Equipos          (domain workstations)
└── Servidores       (member servers)

## Why a custom OU structure (not the default Users container)
GPOs apply at OU level. The default `Users` container is NOT an OU and cannot
have GPOs linked granularly. A custom OU tree enables targeted policy application
and scales with the organization.

## Objects created (Day 4)
### Group
- RRHH (Global Security group) — Recursos Humanos department.

### User
- Laura García (laura.garcia@acme.local)
  - Department: Recursos Humanos
  - Member of: RRHH
  - ChangePasswordAtLogon: enabled (admin never knows final password)

## Best practices applied
- OUs protected against accidental deletion.
- UPN in email format (laura.garcia@acme.local).
- Force password change at first logon.
- AD attributes populated (Department, Title, Company) for realism and reporting.

## Reference: AGDLP
Group nesting best practice: Accounts → Global → Domain Local → Permissions.