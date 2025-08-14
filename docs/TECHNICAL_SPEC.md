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
└── docs/                     # 專案文件
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

    另外，如果要新增按鈕，應優先使用app_standard_button.dart

### 4.1. Mobile-First UI/UX 設計原則

本專案為**手機應用程式**，所有 UI/UX 設計決策必須以手機使用者體驗為優先考量：

#### 4.1.1. 觸控優先互動設計
- **滾動體驗:** 所有可滾動內容必須支持觸控滾動，並使用 `BouncingScrollPhysics` 提供自然的回彈效果
- **列表效能:** 長列表必須使用 `ListView.builder` 確保流暢的滾動效能
- **觸控目標:** 最小觸控區域為 44px，確保手指操作的準確性
- **手勢支持:** 在適當的地方實作滑動手勢功能

#### 4.1.2. 對話框與彈窗設計
- **可滾動性:** 所有對話框內容超過螢幕高度時必須可滾動
- **高度限制:** 使用 `ConstrainedBox` 限制對話框最大高度為螢幕的 60%-80%
- **滾動配置:** 實作 `ScrollConfiguration` 支持觸控和滑鼠裝置
- **隱藏滾動條:** 設定 `scrollbars: false` 隱藏滾動條，但保持滾動功能
- **彈性佈局:** 在對話框中使用 `Flexible` 元件防止溢出

#### 4.1.3. 手機版面配置模式
- **直向優先:** 以直向螢幕為主要設計目標
- **響應式佈局:** 適應不同螢幕尺寸的響應式設計
- **底部選單:** 次要操作適合使用底部選單 (Bottom Sheet)
- **拇指可達:** 主要操作按鈕應放在拇指容易觸及的區域

#### 4.1.4. 手機效能優化
- **列表建構:** 使用 `ListView.builder` 而非包含大量子元件的 `Column`
- **懶載入:** 為大型資料集實作懶載入
- **圖片優化:** 優化圖片載入與快取機制
- **重建最小化:** 透過適當的狀態管理減少不必要的重建

#### 4.1.5. 無障礙設計
- **語意標籤:** 為螢幕閱讀器提供語意標籤
- **色彩對比:** 確保足夠的色彩對比度
- **字體縮放:** 支持系統字體縮放功能
- **無障礙測試:** 在啟用無障礙功能的情況下進行測試

#### 4.1.6. 避免使用的 UI 模式
- **滾動條:** 不使用可見的滾動條，不符合手機使用模式
- **下拉式選單:** 避免傳統下拉式選單，手機使用者不習慣此互動模式，改用底部選單或列表選擇
- **懸停效果:** 不依賴滑鼠懸停效果，因手機無此互動方式
- **右鍵選單:** 不使用右鍵選單，改用長按手勢或操作按鈕

---

## 5. 效能優化 (Performance Optimization)

### 5.1. 分層資料載入策略

本應用實施了先進的效能優化策略以解決資料載入延遲問題：

#### 5.1.1. 本地快取機制 (SharedPreferences)
- **Arsenal 資料:** 30分鐘快取有效期
- **Ball Library 基本資料:** 24小時快取有效期  
- **使用者檔案:** 1小時快取有效期

#### 5.1.2. 雙層初始化架構
1. **第一層:** 立即顯示快取資料 (如果可用)
2. **第二層:** 背景刷新最新資料庫資料

#### 5.1.3. 背景預載入機制
- **應用啟動:** 3秒後開始預載入 Arsenal 資料
- **首頁停留:** 停留5秒後預載入 Ball Library 資料
- **智慧預載入:** 基於使用者導航模式的策略性預載入

#### 5.1.4. 資料分段載入
- **Ball Library:** 基本資料 (前50個球) → 完整資料 (所有球)
- **Arsenal:** 必要資料 → 完整資料含類別

### 5.2. 傳統優化技術
- 大型資料集的懶載入
- 圖片快取與優化
- Riverpod 高效狀態管理
- 資料庫連線池

---

## 6. 使用者通知標準 (User Notification Standards)

**重要:** 所有使用者通知必須嚴格遵循以下標準：

### 6.1. ✅ 正確用法 - 僅使用 TopNotification

```dart
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

// 成功通知 (綠色)
TopNotification.showSuccess(context, 'Layout updated successfully');

// 錯誤通知 (紅色)
TopNotification.showError(context, 'Failed to complete operation');
```

### 6.2. ❌ 禁止使用

```dart
// 絕對不要使用 SnackBar 或 ScaffoldMessenger
ScaffoldMessenger.of(context).showSnackBar(SnackBar(...));

// 絕對不要使用底部通知
showBottomSheet(...);

// 絕對不要使用第三方 toast 庫
Fluttertoast.showToast(...);
```

### 6.3. TopNotification 的優勢
- **一致性 UX:** 所有通知都出現在頂部
- **手機優化:** 不干擾鍵盤或底部導航
- **品牌一致:** 符合應用設計語言
- **無障礙友善:** 對螢幕閱讀器和無障礙功能更友善

---