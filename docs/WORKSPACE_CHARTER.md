# 工作區憲章與導航 (Workspace Charter & Navigation)

**版本**: v1.0.0  
**生效日期**: 2026-10-25  
**適用範圍**: `C:\Users\stephanie.huang\Desktop\新人訓練\Projects\2026\Dev` 及所有子專案  
**狀態**: Active

---

## 1. 宗旨與範圍

本工作區包含三個獨立軟體產品，各自為一個 Rust 專案，採乾淨室原則與單向依賴正交運行：

| 子專案 | 路徑 | 產品定位 | 技術棧 | 狀態 |
|--------|------|----------|--------|------|
| ekpi-platform | `ekpi-platform/` | 可追溯・可驗證的企業知識與流程智慧平台 | Rust (axum + maud), 零 JS 展示層 | Phase A 未核准 / Phase B 受阻 |
| Wellfit | `Wellfit/` | 大前實業 輔翼 ERP 整合與三大產品自動化引擎 | Rust (6-crate workspace) | v1.0.6 發布 |
| SyncMesh | `SyncMesh/` | 跨平台裝置同步解決方案 (CRDT + 編譯證) | Rust (4-crate workspace) | v1.0.0 完成 |

三專案互不依賴原始碼，僅透過本工作區憲章與共享開發標準保持一致。

---

## 2. 工作區剛性不變量 (Rigid Invariants)

以下守則適用於所有子專案、所有程式語言、所有代理人操作，絕對不可逾越：

### 2.1 反過早固化
嚴禁在缺乏數學形式化證明或物理剛性界限下，將啟發式門檻硬編碼為固化不變量。僅宇宙大定理（李雅普諾夫收斂、熱力學矽結溫極限、密碼學單向雜湊）與局部封閉問題的可決定性最佳解始得固化。

### 2.2 Rust 記憶體安全與編譯零容忍
- 所有 Rust 原始碼與測試代碼第一行強制宣告 `#![forbid(unsafe_code)]`，零 `unsafe` 區塊容忍。
- `cargo clippy --all-targets -- -D warnings` 編譯期絕對零警告。
- 禁止 `assert!(true)` 偽斷言，必須綁定具名變數。

### 2.3 表現層 100% JavaScript-Free
客戶端展示層優先採用語義化 HTML5 與現代 CSS，全站 `<script>` 數量恆等於 0。

### 2.4 Windows PowerShell 執行邊界
- 多指令串接必須使用分號 (`;`)，嚴禁 `&&`。
- 執行 `cargo build --release` 前必須先終止殘留之後台守護程序。
- 優先調用 Windows 原生 `curl.exe`，避免未加 `-UseBasicParsing` 的 `Invoke-WebRequest`。

### 2.5 絕對反模擬
嚴禁偽造或硬編碼掃描結果、漏洞證明或固定金額損失。探針失敗必須如實回報，`UNKNOWN != PASS` 且 `UNKNOWN != FAIL`。

### 2.6 規則包容壓縮協議 (≤ 20 條)
本工作區規章條款總數嚴格限制 ≤ 20 條。新增規則時必須強制執行包容性合併，向上抽象為更高階的正向模式。

---

## 3. 開發工作流 (Universal Development Workflow)

所有工作項目均遵循以下標準生命週期：

1. **任務探索與評估** — 使用檢視文件與既有規格評估複雜度與影響半徑。
2. **需求拷問與消歧** — 消除規格歧義，形成決策共識，記錄未解決項目而非臆測。
3. **規格合成與工單切分** — 合成規格，切分 DAG 工單 (1 Ticket = 1 Context Window)。
4. **實作與紅綠重構** — 循序落實代碼，保持 100% 測試通過與零警告。
5. **雙軸代碼審查與驗證 PR** — 行為與架構雙盲審查，附帶形式化回滾證明。
6. **大一統全生命週期** — 重大里程碑啟用 8 大主門禁綠燈閉環。

---

## 4. 文件位置索引 (Documentation Index)

### 工作區層級
| 文件 | 路徑 | 用途 |
|------|------|------|
| 工作區憲章與導航 | `WORKSPACE_CHARTER.md` | 本文件，全工作區憲政與導航 |
| 共享開發標準 | `docs/standards/SHARED_STANDARDS.md` | 跨專案共享編碼、建置、測試標準 |
| 品質門檻與風險分級 | `docs/standards/SHARED_STANDARDS.md` | 風險分級、品質門檻、定義完成 (DoD) |
| 技術決策登錄 | `docs/standards/SHARED_STANDARDS.md` | 跨專案工程決策記錄 (ADR 標準) |

### ekpi-platform
| 文件 | 路徑 | 用途 |
|------|------|------|
| 專案憲章 | `ekpi-platform/PROJECT_CHARTER.md` | 專案概覽、目標、範圍、非目標 |
| 系統架構 | `ekpi-platform/docs/ARCHITECTURE.md` | 系統架構、資料流、元件關係 |
| API 規格 | `ekpi-platform/docs/API_SPEC.md` | CLI/HTML/JSON/XML 契約與介面 |
| 開發指南 | `ekpi-platform/docs/DEVELOPMENT_GUIDE.md` | 建置、測試、部署、本機檢查入口 |
| 品質標準 | `ekpi-platform/docs/QUALITY_STANDARDS.md` | 風險分級、品質門檻、定義完成 |
| 運維手冊 | `ekpi-platform/docs/OPERATIONS_RUNBOOK.md` | 備份、還原、監控、疑難排解 |
| 安全文件 | `ekpi-platform/docs/SECURITY.md` | 安全強化、機密管理、權限模型 |
| ADR 登錄 | `ekpi-platform/docs/ADR_REGISTER.md` | 架構決策記錄 |
| 追溯矩陣 | `ekpi-platform/docs/TRACEABILITY.md` | 需求追溯與驗證證據 |
| 疑難排解 | `ekpi-platform/docs/TROUBLESHOOTING.md` | 常見問題與解決方案 |

### Wellfit
| 文件 | 路徑 | 用途 |
|------|------|------|
| 專案憲章 | `Wellfit/PROJECT_CHARTER.md` | 專案概覽、目標、範圍、非目標 |
| 系統架構 | `Wellfit/docs/ARCHITECTURE.md` | 系統架構、資料流、元件關係 |
| API 規格 | `Wellfit/docs/API_SPEC.md` | CLI 契約與介面 |
| 開發指南 | `Wellfit/docs/DEVELOPMENT_GUIDE.md` | 建置、測試、部署、本機檢查入口 |
| 品質標準 | `Wellfit/docs/QUALITY_STANDARDS.md` | 風險分級、品質門檻、定義完成 |
| 運維手冊 | `Wellfit/docs/OPERATIONS_RUNBOOK.md` | 備份、還原、監控、疑難排解 |
| 安全文件 | `Wellfit/docs/SECURITY.md` | 安全強化、機密管理、權限模型 |
| ADR 登錄 | `Wellfit/docs/ADR_REGISTER.md` | 架構決策記錄 |
| 追溯矩陣 | `Wellfit/docs/TRACEABILITY.md` | 需求追溯與驗證證據 |
| 疑難排解 | `Wellfit/docs/TROUBLESHOOTING.md` | 常見問題與解決方案 |

### SyncMesh
| 文件 | 路徑 | 用途 |
|------|------|------|
| 專案憲章 | `SyncMesh/PROJECT_CHARTER.md` | 專案概覽、目標、範圍、非目標 |
| 系統架構 | `SyncMesh/docs/ARCHITECTURE.md` | 系統架構、資料流、元件關係 |
| API 規格 | `SyncMesh/docs/API_SPEC.md` | CLI 契約與介面 |
| 開發指南 | `SyncMesh/docs/DEVELOPMENT_GUIDE.md` | 建置、測試、部署、本機檢查入口 |
| 品質標準 | `SyncMesh/docs/QUALITY_STANDARDS.md` | 風險分級、品質門檻、定義完成 |
| 運維手冊 | `SyncMesh/docs/OPERATIONS_RUNBOOK.md` | 備份、還原、監控、疑難排解 |
| 安全文件 | `SyncMesh/docs/SECURITY.md` | 安全強化、機密管理、權限模型 |
| ADR 登錄 | `SyncMesh/docs/ADR_REGISTER.md` | 架構決策記錄 |
| 追溯矩陣 | `SyncMesh/docs/TRACEABILITY.md` | 需求追溯與驗證證據 |
| 疑難排解 | `SyncMesh/docs/TROUBLESHOOTING.md` | 常見問題與解決方案 |

---

## 5. 環境與工具鏈

| 工具 | 版本 | 用途 | 狀態 |
|------|------|------|------|
| Rust / cargo | 1.99.1 | 主要建置工具鏈 | 已安裝 |
| Git | 2.56.0.windows.3 | 版本控制 | 已安裝 |
| GitHub CLI (gh) | 2.103.2 | Issue/PR 操作 | 已安裝，未驗證 |
| Node.js / npm | — | 未安裝 | 缺失 |
| codex CLI | — | 未安裝 | 缺失 |

Rust 工具鏈固定於 `rust-toolchain.toml` (channel 1.99.1, minimal, clippy+rustfmt)。

---

## 6. Git 狀態總覽

| 專案 | 是否 git repo | 分支 | Remote origin | 說明 |
|------|--------------|------|--------------|------|
| ekpi-platform | 是 | main | 無 | 需連接現有儲存庫 |
| Wellfit | 是 | main | 無 | 需連接現有儲存庫 |
| SyncMesh | 否 | — | 無 | 需初始化 git repo |

---

## 7. 技能輸出說明

Kilo Code 內建僅 `kilo-config` 技能，無外部技能組安裝機制。本文件體系即為「強大開發產品技能」的完整產出，涵蓋：

- 架構設計與系統規格
- 開發、建置、測試、部署全流程
- 品質門檻與風險分級
- 運維、備份、災難復原
- 安全強化與機密管理
- 架構決策記錄 (ADR)
- 需求追溯與驗證證據
- 疑難排解與常見問題

所有文件均採專業開發文件標準編寫，可直接作為開發型 Agent 與人類開發者的執行依據。

### 工作區技能包：AI 時代嚴謹軟體工程技能包 v1.0.0

安裝位置：`.kilo/skills/rigorous-skill-pack/`

- 15 個獨立技能：`00-orchestration`（總控層）、`01-product-discovery`、`02-requirements-specification`、`03-ux-and-accessibility`、`04-architecture-and-adr`、`05-task-planning`、`06-tdd-and-implementation`、`07-systematic-debugging`、`08-code-review`、`09-testing-and-quality`、`10-security-and-privacy`、`11-ai-evaluation-and-governance`、`12-ci-cd-and-release`、`13-observability-and-reliability`、`14-retrospective-and-evolution`
- 12 個評估案例：`evals/workflow-evals/cases.json`
- 驗證腳本：`scripts/validate_pack.py`
- 來源登記：`docs/source-registry.md`
- 原則：不覆蓋現有 `AGENTS.md`；證據優先於 AI 自稱；停止條件優先；最小權限

整合方式：在各子專案 `AGENTS.md` 新增「技能參考」小節，僅以連結方式指向 `.kilo/skills/rigorous-skill-pack/`，不直接覆寫任何現有規則。

---

## 8. 文件更新規則

- 任何跨專案變更必須同步更新 `WORKSPACE_CHARTER.md` 與 `docs/standards/SHARED_STANDARDS.md`。
- 子專案專屬變更僅更新該專案對應文件，並記錄於 ADR 登錄。
- 文件變更必須與代碼變更在同一提交中完成，保持文件與代碼同步。
- 過期文件標記為 `[Deprecated]`，並註明替代文件與日期。

---

*本文件為工作區最高導航與憲政文件，與子專案 AGENTS.md 互補，不取代子專案專屬規範。*
