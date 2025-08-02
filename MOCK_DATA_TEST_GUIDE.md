# Mock Data 測試指南

## 📋 測試 Arsenal 頁面 UI

### 🎯 測試目的
驗證新設計的 Arsenal 頁面三區域布局和 Grid/List View 功能是否正常運作。

### 🔧 測試設定
當前應用程式已設定為使用 Mock 數據模式，無需真實的後端連接即可測試 UI。

**位置:** `lib/features/arsenal/presentation/pages/my_arsenal_page.dart`
```dart
// 第37行 - 開發模式設定
const bool useMockData = true; // 設為 false 來使用真實數據
```

### 📊 Mock 數據內容
創建了三個測試用的保齡球數據：

#### 1. Storm PhAZE II (競技用球)
- **類型:** Reactive Pearl
- **Layout:** 4.5" x 3.25" (Aggressive)
- **使用次數:** 45場
- **品牌色彩:** Storm 藍色 (#1E88E5)
- **特色:** 有暱稱 "My Go-To Strike Ball"

#### 2. Motiv Jackal Ghost (競技用球)  
- **類型:** Reactive Solid
- **Layout:** 5.0" x 4.0" (Control)
- **使用次數:** 32場
- **品牌色彩:** Motiv 綠色 (#7CB342)
- **特色:** 無暱稱，顯示原始球名

#### 3. Roto Grip Hustle Ink (練習用球)
- **類型:** Reactive Solid  
- **Layout:** 4.0" x 3.5" (Straight)
- **使用次數:** 78場
- **品牌色彩:** Roto Grip 紅色 (#E53935)
- **特色:** 有暱稱 "Practice Partner"，實例編號 #2

### 🎨 UI 測試重點

#### A區：頂部操作區 ✅
- [x] 搜尋框顯示正常
- [x] 篩選按鈕可點擊（顯示"即將推出"訊息）
- [x] 排序按鈕可點擊（顯示"即將推出"訊息）

#### B區：球袋管理區 ✅
- [x] 球袋下拉選單顯示當前選中的分類
- [x] 新增球袋按鈕開啟分類管理對話框
- [x] 顯示對應分類的圖示和顏色

#### C區：內容顯示區 ✅
- [x] Grid/List 切換按鈕正常運作
- [x] "Add balls to my arsenal" 按鈕導航到 Library
- [x] 響應式容器正確顯示內容

### 📱 Grid View 測試
- [x] 2列網格布局
- [x] 球具圖片佔卡片上半部
- [x] 球具名稱、品牌、RG/Diff 資訊正確顯示
- [x] 品牌色彩主題正確應用
- [x] 實例編號標記（#2 for Hustle Ink）
- [x] Layout 類型圖示顯示

### 📋 List View 測試 (水晶樣式)
- [x] 水晶外框樣式（左右尖角）
- [x] 水平布局：左側圖片 + 右側資訊
- [x] 三行資訊：Ball Name (最大字體)、Brand、Core & Cover type
- [x] 下方兩行：Layout 資訊、Games Used
- [x] 品牌色彩漸變背景
- [x] 實例編號標記正確顯示

### 🎯 品牌色彩測試
確認以下品牌色彩正確顯示：
- [x] **Storm:** 藍色 (#1E88E5)
- [x] **Motiv:** 綠色 (#7CB342)  
- [x] **Roto Grip:** 紅色 (#E53935)

### 📦 分類切換測試
- [x] Competition (比賽) - 顯示 Storm PhAZE II, Motiv Jackal Ghost
- [x] Practice (練習) - 顯示 Roto Grip Hustle Ink
- [x] Collection (收藏) - 空的分類

### 🔄 如何切換到真實數據
當準備測試真實後端時：
1. 打開 `lib/features/arsenal/presentation/pages/my_arsenal_page.dart`
2. 將第37行改為 `const bool useMockData = false;`
3. 確保有有效的用戶登入和 Supabase 連接

### 🎨 UI 元件檔案位置
- **主頁面:** `lib/features/arsenal/presentation/pages/my_arsenal_page.dart`
- **球具卡片:** `lib/features/arsenal/presentation/widgets/arsenal_ball_card.dart`
- **Mock 數據:** `lib/features/arsenal/data/repositories/mock_arsenal_test_data.dart`
- **狀態管理:** `lib/features/arsenal/logic/arsenal_controller.dart`

### ⚡ 快速測試步驟
1. 確保 `useMockData = true`
2. 運行應用程式：`flutter run`
3. 導航到 My Arsenal 頁面
4. 測試 Grid/List 切換功能
5. 驗證球具資訊顯示正確
6. 檢查品牌色彩和 Layout 資訊
7. 測試分類切換功能

---

## 🔧 已修正的問題

### ✅ 修正內容 (最新版本)
1. **BagCategory 工廠方法錯誤**
   - ❌ 之前：`BagCategory.competition()` 等不存在的工廠方法
   - ✅ 修正：使用 `DefaultBagCategories.createForUser(userId)` 創建標準分類

2. **BallLayout 參數錯誤**
   - ❌ 之前：缺少必要的 `userId` 參數
   - ✅ 修正：添加 `userId: mockUserId` 參數

3. **用戶ID 一致性問題**
   - ❌ 之前：使用不一致的字符串 `'test_user'`
   - ✅ 修正：統一使用 `mockUserId = 'test_user_123'`

4. **分類ID 對應錯誤**
   - ❌ 之前：使用簡單的分類ID如 `'competition'`
   - ✅ 修正：使用完整的分類ID如 `'competition_test_user_123'`

### 📊 現在包含的測試數據
- **3個球具實例** - 完整欄位，正確關聯
- **4個預設分類** - Competition, Practice, Collection, Testing
- **完整的Layout資訊** - 包含正確的鑽法參數
- **品牌色彩支援** - Storm藍、Motiv綠、Roto Grip紅

### 🎯 測試確認項目
- [x] Mock 數據編譯無錯誤
- [x] 所有必要欄位都已包含
- [x] 分類ID與球具正確對應
- [x] Layout 參數格式正確
- [x] 品牌色彩系統正常運作

---
✅ **所有 Mock 數據錯誤已修正，現在可以正常測試！**