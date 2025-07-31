# Email 登入功能測試指南

## 功能概述

我們已經成功為 StrikeTrack 應用新增了 Email 登入功能，讓你可以使用測試帳號來測試需要認證的功能（如收藏功能）。

## 實作內容

### 1. 後端認證邏輯
- **AuthRepository** (`lib/features/auth/data/auth_repository.dart`)
  - 新增 `signInWithEmailAndPassword()` 方法
  - 新增 `signUpWithEmailAndPassword()` 方法
  - 新增 `signOut()` 方法

### 2. 狀態管理
- **AuthController** (`lib/features/auth/logic/auth_controller.dart`)
  - 使用 Riverpod 管理認證狀態
  - 監聽認證狀態變化
  - 提供登入、註冊、登出功能

### 3. 使用者介面
- **LoginPage** (`lib/shared/views/login_page.dart`)
  - 新增「使用 Email 登入（測試用）」切換按鈕
  - Email 和密碼輸入表單
  - 表單驗證（Email 格式、密碼長度）
  - 測試帳號提示資訊

### 4. 路由管理
- **Router Configuration** (`lib/routing/app_router_config.dart`)
  - 啟用認證守衛 (AuthGuard)
  - 根據認證狀態自動重導向
  - 監聽認證狀態變化

## 測試步驟

### 1. 啟動應用
```bash
# 在專案根目錄執行
flutter run -d windows  # Windows 版本
# 或
flutter run -d chrome   # Chrome 瀏覽器版本
```

### 2. 使用 Email 登入
1. **進入登入頁面**
   - 應用啟動後會自動導向登入頁面 (`/login`)

2. **開啟 Email 登入表單**
   - 點擊「使用 Email 登入（測試用）」按鈕
   - 表單會展開顯示 Email 和密碼輸入欄位

3. **輸入測試帳號資訊**
   - Email: `test@bowlingarsenal.com`
   - 密碼: `TestPassword123!`
   - （表單已內建提示文字）

4. **執行登入**
   - 點擊「登入」按鈕
   - 系統會顯示載入狀態
   - 登入成功後會顯示「登入成功！」提示
   - 自動導向主頁 (`/`)

### 3. 測試收藏功能
登入成功後，可以測試之前實作的收藏功能：

1. **前往 Ball Library 頁面**
   - 點擊底部導航的「Library」
   - 瀏覽球具列表

2. **測試愛心按鈕**
   - 點擊任意球具卡片上的愛心按鈕
   - 觀察控制台輸出：
     ```
     💖 Compact Favorite button tapped for ball: [球名] (ID: [ID])
     🔍 isFavorite - User ID: [UUID], Ball ID: [ID]
     📝 Attempting to insert into favorite_balls...
     ✅ Successfully added to favorites
     ```

3. **驗證收藏狀態**
   - 愛心應該變成紅色（已收藏狀態）
   - 再次點擊可以取消收藏
   - 前往 Favorites 頁面查看收藏列表

## 故障排除

### 常見問題

1. **「登入失敗：User not authenticated」**
   - 確認測試帳號已在 Supabase Dashboard 中正確創建
   - 檢查 Email 和密碼是否正確輸入

2. **「登入失敗：Exception: 登入失敗」**
   - 檢查網路連接
   - 確認 Supabase 連接設定正確
   - 查看詳細錯誤訊息

3. **路由問題**
   - 如果登入後沒有自動導向主頁，檢查控制台是否有路由錯誤
   - 確認 AuthGuard 邏輯正常運作

### 除錯步驟

1. **查看控制台輸出**
   ```bash
   flutter run -d windows --debug --verbose
   ```

2. **檢查認證狀態**
   - 在登入過程中觀察控制台的認證相關日誌
   - 確認 User ID 正確顯示

3. **資料庫驗證**
   - 在 Supabase Dashboard 中檢查 `favorite_balls` 表
   - 確認收藏記錄正確創建

## 開發模式進入方法

如果需要繞過登入進入開發模式：
1. 在登入頁面的 "StrikeTrack" 標題上快速點擊 7 次
2. 系統會顯示「進入開發者通道」提示
3. 自動導向主頁

---

**注意事項：**
- 測試帳號僅供開發使用
- Email 登入功能標記為「測試用」，提醒這是開發功能
- 生產環境應使用適當的用戶管理和認證流程