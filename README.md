# Kilo 設定與技能歸檔儲存庫

本儲存庫歸檔 Kilo 設定與技能，供同事 clone、協作與持續維護。

## 目錄結構

| 路徑 | 說明 |
|------|------|
| `.kilo/` | 專案層 Kilo 設定（協作基礎） |
| `.kilo/kilo.jsonc` | MCP 伺服器設定（絕對路徑已改為 `%USERPROFILE%`） |
| `.kilo/opencode.json` | Opencode 外掛設定 |
| `.kilo/tui.json` | TUI 外掛設定 |
| `.kilo/agent-manager.json` | Agent Manager 工作階段狀態 |
| `.kilo/.gitignore` | 專案層 .kilo 忽略規則 |
| `.kilo/skills/` | 專案層技能包（含 rigorous-skill-pack 等） |
| `.kilo/agents/` | 專案層自訂代理人（architect、code-reviewer 等） |
| `.kilo/plans/` | 專案層規劃檔 |
| `docs/` | 參考文件：工作區憲章、共享開發標準、Wellfit AGENTS.md |
| `personal-reference/` | 全域個人設定（非協作基礎，路徑需自行調整） |
| `personal-reference/config/kilo/` | `~/.config/kilo/` 內容 |
| `personal-reference/kilo/skills/` | `~/.kilo/skills/` 內容 |
| `README.md` | 本檔 |
| `CHANGELOG.md` | 變更紀錄 |
| `.gitignore` | 儲存庫層級忽略規則 |

## 同事安裝與同步步驟

1. **clone 儲存庫**

   ```powershell
   git clone <儲存庫 URL> kilo-settings-skills-archive
   cd kilo-settings-skills-archive
   ```

2. **調整 `.kilo/kilo.jsonc` 路徑**

   本檔已將絕對路徑替換為 `%USERPROFILE%`。若 Kilo 不自動展開環境變數，請自行以編輯器開啟 `.kilo/kilo.jsonc`，將 `%USERPROFILE%` 替換為你機器上的實際使用者設定檔路徑（例如 `C:\Users\你的帳號`）。

   需檢查的項目：
   - `sequentialthinking.command[0]`：`%USERPROFILE%\.bun\bin\bunx.exe`
   - `playwright.command[0]`：`%USERPROFILE%\.bun\bin\bunx.exe`
   - `crates-io.command[0]`：`%USERPROFILE%\.cargo\bin\cratesio-mcp.exe`
   - `rust-analyzer.command[0]`：`%USERPROFILE%\.cargo\bin\rust-analyzer-mcp.exe`
   - `narsil.command[0]`：`%USERPROFILE%\.bun\bin\narsil-mcp.exe`

3. **安裝專案層設定**

   將 `.kilo/` 內容複製到你專案根目錄的 `.kilo/`（或覆蓋既有 `.kilo/`）：

   ```powershell
   Copy-Item -LiteralPath ".kilo\*" -Destination "<你的專案根目錄>\.kilo\" -Recurse -Force
   ```

4. **安裝個人參考設定（選擇性）**

   `personal-reference/` 為全域個人設定備份，非協作基礎。若需套用，將 `personal-reference/config/kilo/` 內容複製到 `~/.config\kilo/`，並自行調整路徑。

5. **敏感檔案檢查**

   提交前務必確認 `.gitignore` 已排除 `.env`、金鑰、個資、客戶資料，且工作目錄 `git status` 乾淨。

## 路徑可攜性說明

- MCP 本地伺服器命令使用 `%USERPROFILE%` 環境變數，可在不同 Windows 使用者帳號間通用。
- 所有文件中的專案內部路徑使用相對路徑，避免絕對路徑。
- 如需跨平台（macOS/Linux）使用，請將 `%USERPROFILE%` 替換為 `$HOME`，並調整 `.exe` 副檔名與路徑分隔符。

## 貢獻與維護

- 任何設定或技能變更，請先建立功能分支，再提交 Pull Request。
- 變更必須同時更新 `CHANGELOG.md` 與相關說明文件。
- 提交訊息格式：`<type>: <subject>`（例如 `feat: add new mcp server`）。
- 敏感資訊嚴禁提交至版本控制。

## 授權

本儲存庫內容隨原專案授權，技能包中的 LICENSE 檔請參閱各技能子目錄。
