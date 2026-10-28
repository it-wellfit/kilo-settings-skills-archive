# skills-activate.ps1 - 技能啟動腳本
# 將指定技能載入當前開發工作階段，寫入 ACTIVE_SKILLS.md 記錄。
#
# 用法：
#   powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -Skills '06-tdd-and-implementation','08-code-review'
#   powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -List
#   powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -Clear
#
# 參數：
#   -Skills   要啟動的技能 ID 陣列（例如 06-tdd-and-implementation）
#   -List     列出目前已啟動的技能
#   -Clear    清除目前的啟動記錄

param(
    [string[]]$Skills,
    [switch]$List,
    [switch]$Clear
)

$ErrorActionPreference = 'Stop'
# Split comma-separated skills
if ($Skills -and $Skills.Count -eq 1 -and $Skills[0] -match ',') {
    $Skills = $Skills[0] -split ',' | ForEach-Object { $_.Trim() }
}
$scriptDir = Split-Path -Parent $PSScriptRoot
$root = $scriptDir
$kiloSkillsDir = Join-Path $root '.kilo\skills'
$packRoot = Join-Path $kiloSkillsDir 'rigorous-skill-pack'
$activeFile = Join-Path $packRoot 'ACTIVE_SKILLS.md'
$skillsDir = Join-Path $packRoot 'skills'

$allSkills = @(
    '00-orchestration', '01-product-discovery', '02-requirements-specification',
    '03-ux-and-accessibility', '04-architecture-and-adr', '05-task-planning',
    '06-tdd-and-implementation', '07-systematic-debugging', '08-code-review',
    '09-testing-and-quality', '10-security-and-privacy', '11-ai-evaluation-and-governance',
    '12-ci-cd-and-release', '13-observability-and-reliability', '14-retrospective-and-evolution'
)

function Test-SkillId {
    param([string]$Id)
    return $allSkills -contains $Id
}

function Test-SkillFile {
    param([string]$Id)
    $f = Join-Path $skillsDir ($Id + '\SKILL.md')
    return Test-Path -LiteralPath $f
}

function Read-ActiveSkills {
    if (-not (Test-Path -LiteralPath $activeFile)) { return @() }
    $content = Get-Content -LiteralPath $activeFile -Raw
    $matches = [regex]::Matches($content, '-\s*\[( |x)\]\s+(.+)$', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    $result = @()
    foreach ($m in $matches) {
        if ($m.Groups[1].Value -eq 'x') {
            $result += $m.Groups[2].Value.Trim()
        }
    }
    return $result
}

function Write-ActiveSkills {
    param([string[]]$Active)
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $out = @()
    $out += '# ACTIVE_SKILLS.md - 目前啟動的技能'
    $out += ''
    $out += '> 更新時間：' + $now
    $out += '> 此檔由 skills-activate.ps1 管理，記錄本開發工作階段已啟動的技能。'
    $out += '> 只有標記 [x] 的技能才會在開發流程中被主動套用與檢查。'
    $out += ''
    $out += '## 已啟動技能'
    $out += ''
    if ($Active.Count -eq 0) {
        $out += '_(尚未啟動任何技能。請使用 skills-activate.ps1 -Skills 啟動。）_'
        $out += ''
        $out += '---'
        $out += '## 可用技能清單'
        $out += ''
        foreach ($s in $allSkills) {
            $out += ('- [ ] ' + $s)
        }
    } else {
        foreach ($s in $Active) {
            $out += ('- [x] ' + $s)
        }
        $out += ''
        $out += '---'
        $out += '## 未啟動技能'
        $out += ''
        $inactive = $allSkills | Where-Object { $_ -notin $Active }
        foreach ($s in $inactive) {
            $out += ('- [ ] ' + $s)
        }
    }
    $out += ''
    $out += '---'
    $out += '## 如何啟動'
    $out += ''
    $out += '```powershell'
    $out += '# 啟動單一技能（例如準備實作時啟動 TDD）'
    $out += 'powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -Skills 06-tdd-and-implementation'
    $out += ''
    $out += '# 啟動多個技能（例如實作+審查+品質驗證）'
    $out += 'powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -Skills 06-tdd-and-implementation,08-code-review,09-testing-and-quality'
    $out += ''
    $out += '# 查看目前已啟動的技能'
    $out += 'powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -List'
    $out += ''
    $out += '# 清除所有記錄（換任務時使用）'
    $out += 'powershell -ExecutionPolicy Bypass -File scripts\skills-activate.ps1 -Clear'
    $out += '```'
    $out += ''
    $out += '---'
    $out += '## 技能與開發階段對應'
    $out += ''
    $out += '| 開發階段 | 建議啟動技能 | 對應 MASTER-WORKFLOW |'
    $out += '|----------|-------------|---------------------|'
    $out += '| 需求分析 | 01-product-discovery, 02-requirements-specification | G1-G2 |'
    $out += '| 架構設計 | 04-architecture-and-adr, 05-task-planning | G4-G5 |'
    $out += '| 程式實作 | 06-tdd-and-implementation, 09-testing-and-quality | G6 |'
    $out += '| 除錯修 Bug | 07-systematic-debugging | G7 |'
    $out += '| 代碼審查 | 08-code-review | G8 |'
    $out += '| 品質驗證 | 09-testing-and-quality, 10-security-and-privacy | G9 |'
    $out += '| 發布部署 | 12-ci-cd-and-release, 13-observability-and-reliability | G10 |'
    $out += '| 發布回顧 | 14-retrospective-and-evolution | G10 之後 |'
    $out += ''
    ($out -join [char]10) | Set-Content -LiteralPath $activeFile -Encoding UTF8
}

# --- Main ---

if ($Clear) {
    if (Test-Path -LiteralPath $activeFile) { Remove-Item -LiteralPath $activeFile -Force }
    Write-Host '已清除所有啟動記錄。' -ForegroundColor Green
    exit 0
}

if ($List) {
    $active = Read-ActiveSkills
    if ($active.Count -eq 0) {
        Write-Host '目前未啟動任何技能。' -ForegroundColor Yellow
    } else {
        Write-Host '目前已啟動的技能：' -ForegroundColor Cyan
        foreach ($s in $active) { Write-Host ('  [x] ' + $s) -ForegroundColor Green }
    }
    Write-Host ''
    Write-Host ("可用技能（共 " + $allSkills.Count + " 個）：") -ForegroundColor Cyan
    foreach ($s in $allSkills) {
        $marker = if ($active -contains $s) { '[x]' } else { '[ ]' }
        Write-Host ('  ' + $marker + ' ' + $s)
    }
    exit 0
}

if ($Skills -and $Skills.Count -gt 0) {
    $invalid = $Skills | Where-Object { -not (Test-SkillId $_) }
    if ($invalid.Count -gt 0) {
        Write-Host ('錯誤：下列技能 ID 無效：' + ($invalid -join ', ')) -ForegroundColor Red
        exit 1
    }

    $missing = $Skills | Where-Object { -not (Test-SkillFile $_) }
    if ($missing.Count -gt 0) {
        Write-Host ('錯誤：下列技能檔案不存在：' + ($missing -join ', ')) -ForegroundColor Red
        exit 1
    }

    $existing = Read-ActiveSkills
    $merged = ($existing + $Skills) | Sort-Object -Unique
    Write-ActiveSkills -Active $merged
    Write-Host ('已啟動技能：' + ($Skills -join ', ')) -ForegroundColor Green
    Write-Host ('總計已啟動：' + $merged.Count + ' 個') -ForegroundColor Green
    exit 0
}

# 無參數：顯示說明
Write-Host '技能啟動腳本 (skills-activate.ps1)' -ForegroundColor Cyan
Write-Host ''
Write-Host '用法範例：'
Write-Host '  啟動單一技能：  .\skills-activate.ps1 -Skills ''06-tdd-and-implementation'''
Write-Host '  啟動多個技能： .\skills-activate.ps1 -Skills ''06-tdd-and-implementation'',''08-code-review'''
Write-Host '  列出目前狀態： .\skills-activate.ps1 -List'
Write-Host '  清除記錄：     .\skills-activate.ps1 -Clear'
Write-Host ''
Write-Host '目前已啟動：'
$active = Read-ActiveSkills
if ($active.Count -eq 0) { Write-Host '  (無)' -ForegroundColor Yellow }
else { foreach ($s in $active) { Write-Host ('  [x] ' + $s) -ForegroundColor Green } }
