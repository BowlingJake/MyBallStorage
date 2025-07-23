# StrikeTrack 🎳

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Platform](https://img.shields.io/badge/platform-Flutter-blue)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

專為保齡球愛好者設計的個人化球具管理與訓練追蹤 App。StrikeTrack 幫助您記錄、管理您的保齡球武器庫 (Arsenal)，並追蹤您在訓練與比賽中的表現。

---

## ✨ 主要功能 (Key Features)

* **使用者驗證:**
    * 支援 Email/密碼註冊與登入。
    * 計畫支援 Google & Apple 快速登入。
* **個人化主控台:**
    * 一目了然的使用者資訊卡。
    * 快速預覽個人球櫃中的球具。
* **我的球櫃 (My Arsenal):**
    * 建立並管理您擁有的所有保齡球。
    * (未來) 記錄每顆球的詳細規格與鑽孔配置。
* **球具資料庫 (Ball Library):**
    * 瀏覽市面上的各種保齡球資料。
* **訓練與比賽追蹤 (規劃中):**
    * 記錄您的訓練局數、分數與球路筆記。
    * 建立比賽場次，追蹤競賽表現。
* **主題切換:**
    * 支援深色與淺色模式，提供舒適的視覺體驗。

---

## 🛠️ 技術棧與架構 (Tech Stack & Architecture)

本專案採用現代化的 Flutter 開發實踐，注重程式碼的模組化、可維護性與可擴展性。

| 類別                  | 技術/套件                                                               |
| -------------------- | ----------------------------------------------------------------------- |
| **核心框架**          | `Flutter`                                                               |
| **架構**              | **功能驅動 (Feature-Driven)** 的模組化架構                               |
| **狀態管理**          | `Riverpod` (搭配 `riverpod_generator` 進行程式碼生成)                     |
| **路由管理**          | `GoRouter`                                                              |
| **後端 & 驗證**       | `Supabase` (Auth, Database, Storage)                                    |
| **數據模型**          | `Freezed` / `json_serializable`                                         |
| **本地儲存**          | `shared_preferences`                                                    |
| **環境變數**          | `flutter_dotenv`                                                        |
| **UI**                | 自訂 `core_theme` 套件, `google_fonts`, `lottie`, `fl_chart` 等         |

詳細的技術與架構決策，請參考 [`docs/TECHNICAL_SPEC.md`](docs/TECHNICAL_SPEC.md)。

---

## 🚀 開始使用 (Getting Started)

請依照以下步驟在本機端運行此專案：

1.  **Clone 專案**
    ```bash
    git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
    cd StrikeTrack
    ```

2.  **設定環境變數**
    * 在專案根目錄建立一個 `.env` 檔案。
    * 填入您的 Supabase 專案金鑰：
        ```
        SUPABASE_URL=YOUR_SUPABASE_URL
        SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
        ```

3.  **安裝依賴套件**
    ```bash
    flutter pub get
    ```

4.  **執行程式碼生成**
    * 由於專案使用 `freezed` 與 `riverpod_generator`，在修改相關檔案後需執行以下指令來產生程式碼：
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **運行 App**
    ```bash
    flutter run
    ```

---

## 🗺️ 專案藍圖 (Roadmap)

* [ ] **清理技術債:** 移除專案中未使用的 `Firebase` 相關依賴。
* [ ] **完善「我的球櫃」:** 開發球具的新增、編輯、刪除功能，並與 Supabase 資料庫對接。
* [ ] **開發「訓練」頁面:** 設計並實作訓練記錄功能。
* [ ] **完善使用者個人資料頁面。**

---

*This README was co-authored with Google's Gemini AI.*