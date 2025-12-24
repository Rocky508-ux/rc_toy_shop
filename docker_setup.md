# Docker 環境安裝三部曲 (Windows)

## 第一步：開啟虛擬化功能 (Virtualization)
1. 進入 BIOS 確認開啟 **VT-x** 或 **Virtualization Technology**。
2. 在 Windows 搜尋欄輸入「開啟或關閉 Windows 功能」。
3. 勾選以下兩個項目：
   - [x] **虛擬機器平台 (Virtual Machine Platform)**
   - [x] **Windows 子系統 Linux 版 (Windows Subsystem for Linux)**
4. 按確定，安裝完畢後請 **重新啟動電腦**。

## 第二步：安裝 WSL 2 與 Ubuntu
1. 以「系統管理員」身分開啟 **PowerShell**。
2. 輸入指令：`wsl --install`
   - 系統會自動下載 WSL 核心組件並安裝預設的 **Ubuntu** 系統。
3. 如果出現提示，請再次 **重新啟動電腦**。
4. 重開後 Ubuntu視窗會自動跳出，請依照指示設定一組簡單的帳號密碼 (例如 user / 123456)。

## 第三步：安裝 Docker Desktop
1. 前往 Docker 官網下載 **Docker Desktop for Windows**。
2. 執行安裝檔，安裝過程中確認有勾選 **"Use WSL 2 instead of Hyper-V"** (這是建議選項)。
3. 安裝完成後，最後一次 **重新啟動電腦**。
4. 開啟 Docker Desktop，等待左下角的鯨魚圖示或狀態燈變為 **綠色 (Running)**。
5. 完成！

## 常見排錯 (Troubleshooting)
- **卡住不動？** 如果終端機執行 `wsl` 卡住，請去「服務 (Services)」搜尋 `LxssManager` 並將其重新啟動。
- **WSL 核心版本過舊？** 如果 `wsl --install` 失敗，可前往微軟官網下載「WSL2 Linux 核心更新套件 (x64)」手動安裝。
