# SISTEMAS OPERATIVOS
Windows Server 2022 · Windows 10/11 · Ubuntu Server (Linux)

# DIRECTORIO Y AUTENTICACIÓN
Active Directory (AD DS) · Group Policy (GPO) · DNS · Gestión de usuarios y permisos

# REDES
TCP/IP · DHCP · DNS · Configuración y diagnóstico de red · Subnetting básico

# VIRTUALIZACIÓN
VMware Workstation Pro · Snapshots · Diseño de entornos multi-VM

# AUTOMATIZACIÓN Y SCRIPTING
PowerShell (administración de AD, red y servicios) · Bash básico

# HERRAMIENTAS Y METODOLOGÍA
Git / GitHub · Documentación técnica · Diagnóstico de incidencias · Control de versiones

# DIRECTORIO Y POLÍTICAS
Active Directory (AD DS) · Group Policy (GPO) · DNS · OUs · Grupos de seguridad
Política de contraseñas · Lockout policy

# SERVICIOS DE ARCHIVOS
File Server (SMB) · Permisos NTFS · Permisos de Compartido · Mapeo de unidades por GPO

# CIBERSEGURIDAD BÁSICA
Auditoría de cuentas privilegiadas · Principio de mínimo privilegio
Respuesta a incidentes (detección/contención/investigación/remediación)
Análisis de eventos de seguridad (4624, 4625, 4740) · Hardening por GPO

# SISTEMAS LINUX
Ubuntu Server 22.04 · systemctl · gestión de servicios y logs (journalctl)
Configuración de red por CLI · Permisos POSIX (chmod, chown)

# AUTOMATIZACIÓN
PowerShell: gestión masiva de usuarios desde CSV, health checks,
auditoría de cuentas privilegiadas con export a CSV

# PROYECTO: Laboratorio de Infraestructura IT Empresarial (Acme Solutions)
Entorno empresarial simulado de 25 usuarios sobre VMware Workstation Pro.
Repositorio público documentado: github.com/TU-USUARIO/homelab-acme-it-support

- Desplegué y configuré un controlador de dominio Active Directory sobre
  Windows Server 2022 (bosque acme.local), incluyendo DNS integrado y DHCP
  autorizado en AD, validando la salud del servicio con dcdiag y repadmin.

- Diseñé el direccionamiento de red de la infraestructura (segmentación de
  rangos estáticos y pool DHCP) aplicando aislamiento de red por seguridad,
  con el controlador de dominio fuera del rango DHCP para evitar conflictos de IP.

- Automaticé la configuración de red, roles de servidor y altas de usuarios
  mediante PowerShell, y documenté cada decisión técnica en formato ADR
  (Architecture Decision Records) en un repositorio Git público.

- Diseñé y apliqué 5 políticas de grupo (GPO) cubriendo aviso legal,
  bloqueo de almacenamiento USB, bloqueo de pantalla por inactividad,
  política de contraseñas y baseline de auditoría, validando su
  aplicación mediante gpresult.

- Configuré un servidor de archivos (File Server) con recursos
  compartidos, aplicando permisos NTFS granulares por grupo de seguridad
  y permisos de Compartido permisivos, siguiendo la mejor práctica de
  la industria de control vía NTFS.

- Documenté 7 incidencias simuladas (DHCP, DNS, permisos, servicios,
  conectividad intermitente, GPO, cuenta comprometida) como casos de
  service desk con diagnóstico paso a paso, causa raíz y prevención.

- Desplegué un servidor Ubuntu 22.04 LTS gestionado por línea de
  comandos, aplicando comandos de administración de servicios,
  diagnóstico de red y análisis de logs.

- Automaticé tareas administrativas con PowerShell: alta masiva de
  usuarios desde CSV con manejo de errores, health check del controlador
  de dominio, y auditoría periódica de cuentas privilegiadas con
  exportación a CSV para cumplimiento.

