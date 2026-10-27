# 變更紀錄

## [未發行]

### 新增
- 新增 `.gitattributes` 統一行尾格式（LF）
- 修正目錄雙重巢狀（agents/plans/skills）
- 歸檔專案層 `.kilo/` 設定與技能（kilo.jsonc、opencode.json、tui.json、agent-manager.json、.gitignore、skills/、agents/、plans/）
- 參數化 `kilo.jsonc` 絕對路徑，改為 `%USERPROFILE%` 環境變數
- 加入參考文件：WORKSPACE_CHARTER.md、SHARED_STANDARDS.md、Wellfit AGENTS.md（docs/）
- 加入全域個人設定備份（personal-reference/config/kilo/、personal-reference/kilo/skills/）
- 撰寫 README.md（安裝、同步、路徑調整說明）與 CHANGELOG.md
- 撰寫 .gitignore（排除 node_modules/target/.env/金鑰/個資）

## [1.0.0] - 2026-10-27

### 初始版本
- 建立 Kilo 設定與技能歸檔儲存庫，供同事 clone 與協作。
