# 04-scripts/powershell/Get-PrivilegedAccountsAudit.ps1
<#
.SYNOPSIS
    Audits membership of privileged AD groups.
.DESCRIPTION
    Lists members of Domain Admins, Enterprise Admins, Schema Admins
    and Administrators. Designed for periodic least-privilege reviews.
#>

$privilegedGroups = @("Domain Admins", "Enterprise Admins", "Schema Admins", "Administrators")

$report = foreach ($group in $privilegedGroups) {
    try {
        $members = Get-ADGroupMember -Identity $group -ErrorAction Stop
        if ($members.Count -eq 0) {
            [PSCustomObject]@{
                Group  = $group
                Member = "(empty)"
                Type   = "-"
            }
        } else {
            foreach ($m in $members) {
                [PSCustomObject]@{
                    Group  = $group
                    Member = $m.SamAccountName
                    Type   = $m.objectClass
                }
            }
        }
    } catch {
        Write-Warning "Could not query $group : $_"
    }
}

$report | Format-Table -AutoSize

# Export to CSV for evidence/compliance
$reportPath = "C:\Reports\privileged-audit-$(Get-Date -Format 'yyyyMMdd').csv"
New-Item -Path "C:\Reports" -ItemType Directory -Force | Out-Null
$report | Export-Csv -Path $reportPath -NoTypeInformation
Write-Host "`nReport saved to: $reportPath" -ForegroundColor Green