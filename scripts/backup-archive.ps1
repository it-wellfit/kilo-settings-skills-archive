# backup-archive.ps1 - Kilo settings and skills auto-backup script
# Auto-executes Git push, ZIP snapshot, Git Bundle offline backup, and cleans up old backups.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts\backup-archive.ps1
#   powershell -ExecutionPolicy Bypass -File scripts\backup-archive.ps1 -SkipGitPush
#   powershell -ExecutionPolicy Bypass -File scripts\backup-archive.ps1 -SkipZip
#   powershell -ExecutionPolicy Bypass -File scripts\backup-archive.ps1 -SkipBundle
#
# Schedule recommendation:
#   - Every Friday 18:00: full backup (Git push + ZIP + Bundle)
#   - After major changes: manual execution
#
# Parameters:
#   -SkipGitPush   Skip Git push (offline environment)
#   -SkipZip       Skip ZIP snapshot
#   -SkipBundle    Skip Git Bundle
#   -BackupDir     Backup output directory (default: Desktop)
#   -KeepWeekly    Keep last N weekly ZIP snapshots (default: 4)
#   -KeepMonthly   Keep last N monthly ZIP archives (default: 3)

param(
    [switch]$SkipGitPush,
    [switch]$SkipZip,
    [switch]$SkipBundle,
    [string]$BackupDir = "$env:USERPROFILE\Desktop",
    [int]$KeepWeekly = 4,
    [int]$KeepMonthly = 3
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $PSScriptRoot
$root = $scriptDir
$archiveName = "kilo-settings-skills-archive"
$logFile = Join-Path $BackupDir "backup-log-$(Get-Date -Format 'yyyyMMdd').txt"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$ts] [$Level] $Message"
    Write-Host $line
    Add-Content -LiteralPath $logFile -Value $line -Encoding UTF8
}

function Run-Step {
    param([string]$Name, [scriptblock]$Action)
    Write-Log "=== $Name ==="
    try {
        & $Action
        Write-Log "[OK] $Name" "SUCCESS"
        return $true
    } catch {
        Write-Log "[FAIL] $Name : $_" "ERROR"
        return $false
    }
}

$failures = 0
$timestamp = Get-Date -Format 'yyyyMMdd'

Write-Log "Starting backup: $archiveName"
Write-Log "Backup dir: $BackupDir"

# --- 1. Git Push ---
if (-not $SkipGitPush) {
    $ok = Run-Step "Git push to origin/master" {
        Set-Location -LiteralPath $root
        $status = git status --porcelain
        if ($status) {
            Write-Log "Uncommitted changes detected, auto-committing..." "WARN"
            git add -A
            git commit -m "chore: auto-backup commit $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        }
        git push origin master
        if ($LASTEXITCODE -ne 0) { throw "git push failed, exit code $LASTEXITCODE" }
    }
    if (-not $ok) { $failures++ }
} else {
    Write-Log "Skipping Git push (-SkipGitPush)" "WARN"
}

# --- 2. ZIP Snapshot ---
if (-not $SkipZip) {
    $zipName = "$archiveName-$timestamp.zip"
    $zipPath = Join-Path $BackupDir $zipName
    $ok = Run-Step "ZIP snapshot: $zipName" {
        if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
        Compress-Archive -Path "$root\*" -DestinationPath $zipPath -Force
        $size = [math]::Round((Get-Item -LiteralPath $zipPath).Length / 1MB, 2)
        Write-Log "ZIP created: $zipPath ($size MB)"
    }
    if (-not $ok) { $failures++ }

    Run-Step "Clean up old ZIP snapshots" {
        $allZips = Get-ChildItem -LiteralPath $BackupDir -Filter "$archiveName-*.zip" |
            Sort-Object LastWriteTime -Descending
        $toKeep = @()
        $toKeep += $allZips | Select-Object -First $KeepWeekly
        $monthly = $allZips | Group-Object { $_.LastWriteTime.ToString('yyyy-MM') } |
            ForEach-Object { $_.Group | Select-Object -Last 1 } |
            Select-Object -First $KeepMonthly
        $toKeep += $monthly
        $toKeep = $toKeep | Sort-Object FullName -Unique
        $toDelete = $allZips | Where-Object { $_.FullName -notin $toKeep.FullName }
        foreach ($f in $toDelete) {
            Remove-Item -LiteralPath $f.FullName -Force
            Write-Log "Deleted old backup: $($f.Name)"
        }
        Write-Log "Kept $($toKeep.Count), deleted $($toDelete.Count)"
    }
} else {
    Write-Log "Skipping ZIP snapshot (-SkipZip)" "WARN"
}

# --- 3. Git Bundle Offline Backup ---
if (-not $SkipBundle) {
    $bundleName = "$archiveName-$timestamp.bundle"
    $bundlePath = Join-Path $BackupDir $bundleName
    $ok = Run-Step "Git Bundle offline backup: $bundleName" {
        Set-Location -LiteralPath $root
        if (Test-Path -LiteralPath $bundlePath) { Remove-Item -LiteralPath $bundlePath -Force }
        git bundle create $bundlePath --branches --tags
        if ($LASTEXITCODE -ne 0) { throw "git bundle failed, exit code $LASTEXITCODE" }
        $size = [math]::Round((Get-Item -LiteralPath $bundlePath).Length / 1MB, 2)
        Write-Log "Bundle created: $bundlePath ($size MB)"
        git bundle verify $bundlePath | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Bundle verification failed" }
        Write-Log "Bundle verification passed"
    }
    if (-not $ok) { $failures++ }

    Run-Step "Clean up old Bundles" {
        $allBundles = Get-ChildItem -LiteralPath $BackupDir -Filter "$archiveName-*.bundle" |
            Sort-Object LastWriteTime -Descending
        $toDelete = $allBundles | Select-Object -Skip 4
        foreach ($f in $toDelete) {
            Remove-Item -LiteralPath $f.FullName -Force
            Write-Log "Deleted old Bundle: $($f.Name)"
        }
    }
} else {
    Write-Log "Skipping Git Bundle (-SkipBundle)" "WARN"
}

# --- Summary ---
Write-Log ""
Write-Log "========== Backup Summary =========="
Write-Log "Git push: $(if ($SkipGitPush) { 'Skipped' } else { 'Done' })"
Write-Log "ZIP snapshot: $(if ($SkipZip) { 'Skipped' } else { 'Done' })"
Write-Log "Git Bundle: $(if ($SkipBundle) { 'Skipped' } else { 'Done' })"
Write-Log "Failed steps: $failures"
Write-Log "Log file: $logFile"
Write-Log "===================================="

if ($failures -gt 0) {
    Write-Log "Backup completed with $failures failed step(s). Check log." "WARN"
    exit 1
} else {
    Write-Log "All backup steps completed successfully." "SUCCESS"
    exit 0
}