# Especificación Técnica de Seguridad: Hardening Base de Endpoints vía GPO
**Documento de Configuración de Infraestructura (`gpo-config.md`)**

---

## 1. Resumen Ejecutivo y Alineación Estratégica

Este documento detalla la configuración, despliegue y validación del Objeto de Política de Grupo (GPO) **"Acme - Hardening Base Estaciones"**. El objetivo fundamental es establecer una línea base de seguridad (*security baseline*) homogénea y auditable en todas las estaciones de trabajo del dominio corporativo `acme.local`.

La estrategia de implementación se rige bajo el modelo mental de **Defensa en Profundidad (Defense in Depth)**, atacando la superficie de riesgo en tres capas críticas:
1. **Visibilidad (Capa de Auditoría):** Garantizar la generación de telemetría necesaria para la detección de anomalías y respuestas ante incidentes (SIEM-ready).
2. **Control de Red Host-Based (Capa de Firewall):** Mitigar movimientos laterales bloqueando vectores de ataque entrantes no autorizados.
3. **Restricción de Ejecución (Capa de Aplicación):** Prevenir la ejecución de malware corporativo e hilos de ejecución no firmados transmitidos mediante PowerShell.

---

## 2. Aprovisionamiento y Arquitectura de Enlaces

El aprovisionamiento del objeto GPO y su vinculación estructural se realiza a nivel del Directorio Activo utilizando comandos nativos de automatización para evitar discrepancias operativas.

### 2.1. Script de Despliegue (Ejecutado en DC01)

```powershell
# ==============================================================================
# PROYECTO: Hardening de Endpoints de Dominio
# SCRIPT: Creación y Vinculación de GPO de Seguridad Base
# OBJETO: Acme - Hardening Base Estaciones
# TARGET: OU=Equipos,OU=Acme,DC=acme,DC=local
# ==============================================================================

Import-Module GroupPolicy

$gpoName = "Acme - Hardening Base Estaciones"
$ouTarget = "OU=Equipos,OU=Acme,DC=acme,DC=local"

# 1. Creación del Objeto GPO con metadatos descriptivos
Write-Host "[+] Creando GPO: $gpoName..." -ForegroundColor Cyan
$gpo = New-GPO -Name $gpoName -Comment "Configuraciones de seguridad base críticas para estaciones de trabajo del dominio."

# 2. Vinculación a la Unidad Organizativa (OU) objetivo
Write-Host "[+] Vinculando GPO a la Unidad Organizativa: $ouTarget..." -ForegroundColor Cyan
New-GPLink -Name $gpoName -Target $ouTarget -LinkEnabled Yes

Write-Host "[✓] Proceso completado exitosamente." -ForegroundColor Green