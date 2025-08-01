# StrikeTrack - 技術規格書 (Technical Specification)

**文件版本:** 1.0
**最後更新:** 2025-07-23

## 1. 總覽

本文件定義了 StrikeTrack App 的技術架構、核心依賴、程式碼風格和設計模式。所有貢獻者（包括人類與 AI）在開發新功能或進行重構時，都必須嚴格遵守此文件中定義的規範，以確保專案的長期健康與可維護性。

---

## 2. 核心技術棧 (Core Tech Stack)

| 類別                 | 技術/套件                                        | 用途與規範  |
| -------------------- | ------------------------------------------------ | -------------------------------------------------------------------------- |
| **核心框架** | `Flutter`                                        | 跨平台應用程式開發框架。|
| **狀態管理** | `Riverpod` (`flutter_riverpod`)                  | 負責管理 App 的所有狀態。**必須**使用 `@riverpod` 註解進行程式碼生成。 |
| **路由管理** | `GoRouter`                                       | 負責 App 內的所有頁面導航。應採用宣告式、基於路徑的路由表。|
| **後端服務** | `Supabase` (`supabase_flutter`)                  | 處理使用者驗證、資料庫、檔案儲存等所有後端需求。|
| **數據模型** | `Freezed`                                        | 用於建立不可變 (immutable) 的資料模型與狀態類別。**必須**搭配程式碼生成。    |
| **JSON序列化** | `json_serializable`                            | 搭配 `Freezed` 自動生成 `toJson`/`fromJson` 方法。                         |
| **本地儲存** | `shared_preferences`                             | 用於儲存輕量的、非敏感性的鍵值對資料（例如：主題偏好設定）。               |
| **環境變數** | `flutter_dotenv`                                 | 負責管理 Supabase 的 API 金鑰等敏感資訊。                                  |

---

## 3. 專案架構 (Project Architecture)

本專案採用**功能驅動 (Feature-Driven)** 的分層架構，旨在實現高內聚、低耦合。

### 3.1. 資料夾結構 (`lib/`)

```
lib/
├── main.dart                 # App 入口
├── features/                 # 功能模組目錄
│   ├── auth/                 #   - 身份驗證模組
│   ├── arsenal/              #   - 我的球櫃模組
│   │   ├── data/             #     - 資料層 (Repository)
│   │   ├── logic/            #     - 邏輯層 (Provider)
│   │   └── presentation/     #     - 表現層 (View, Widgets)
│   └── ...                   #   - 其他功能模組...
├── core/                     # 核心服務與工具 (與特定功能無關)
│   ├── error/                #   - 錯誤處理機制
│   └── providers/            #   - 全域 Provider (e.g., Supabase Client)
├── shared/                   # 跨功能共用的元件
│   ├── widgets/              #   - 共用 Widget (e.g., CustomButton)
│   ├── models/               #   - 共用資料模型
│   └── ...
├── routing/                  # GoRouter 的路由設定
└── theme/                    # App 的主題與樣式
```

### 3.2. 分層職責

- **表現層 (Presentation Layer):**
    - **位置:** `features/**/presentation/`
    - **內容:** 畫面 (Screens/Views) 和獨立的小元件 (Widgets)。
    - **職責:** 專注於 UI 的建構與佈局。UI 元件應從 Riverpod **讀取 (watch/read)** 狀態來顯示資料，並在需要時**呼叫 (call)** 邏輯層的方法來觸發操作。**不應**包含任何業務邏輯。

- **邏輯層 (Logic Layer):**
    - **位置:** `features/**/logic/`
    - **內容:** Riverpod 的 Providers (例如：`Notifier`, `AsyncNotifier`)。
    - **職責:** 處理使用者的操作、管理畫面的狀態、並向資料層請求數據。這是業務邏輯的核心。

- **資料層 (Data Layer):**
    - **位置:** `features/**/data/`
    - **內容:** 儲存庫 (Repositories)。
    - **職責:** 封裝與外部資料來源（主要是 Supabase）的所有互動細節。表現層和邏輯層**不應**直接存取 Supabase Client，而必須透過 Repository 來進行。

---

## 4. 程式碼規範 (Coding Style & Conventions)

- **狀態管理:** 嚴格遵循 Riverpod 的最佳實踐。優先使用 `AsyncNotifierProvider` 來處理非同步操作。Provider 應盡可能保持小而專一。
- **數據模型:** 所有自定義的資料模型或複雜的狀態，都**必須**使用 `Freezed` 來建立，以確保其不可變性。
- **錯誤處理:** Repository 層在與 Supabase 互動時，必須妥善處理可能發生的錯誤（例如：網路錯誤、資料不存在），並將其轉換為定義好的錯誤類型，回傳給邏輯層。
- **命名規範:**
    - 檔案：使用 `snake_case` (小寫蛇形命名法)，例如：`my_arsenal_screen.dart`。
    - 類別/Provider：使用 `PascalCase` (大駝峰命名法)，例如：`MyArsenalRepository`。
    - 變數/函式：使用 `camelCase` (小駝峰命名法)，例如：`fetchBalls()`。

    另外，如果要新增按鈕，應優先使用app_standard_button.dart，如果要使用下拉式選單，應優先使用custom_dropdown.dart

---