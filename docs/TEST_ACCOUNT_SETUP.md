# 測試帳號設置指南

本指南說明如何為開發和測試創建測試帳號，特別是用於測試需要用戶認證的功能（如收藏功能）。

## 方法1：使用 Supabase Dashboard 創建測試用戶（推薦）

### 步驟：

1. **登入 Supabase Dashboard**
   - 前往 [supabase.com](https://supabase.com)
   - 登入你的帳號並選擇專案

2. **前往 Authentication 頁面**
   - 點擊左側導航的 **"Authentication"**
   - 點擊 **"Users"** 標籤

3. **創建新用戶**
   - 點擊 **"Add user"** 按鈕
   - 選擇 **"Create a new user"**
   - 填寫以下資訊：
     ```
     Email: test@bowlingarsenal.com
     Password: TestPassword123!
     Email Confirm: ✅ (勾選)
     Auto Confirm User: ✅ (勾選)
     ```
   - 點擊 **"Create user"**

4. **驗證用戶創建成功**
   - 確認用戶出現在用戶列表中
   - 記下 **User ID (UUID)** 供後續測試使用

## 方法2：在應用中註冊（如果有註冊功能）

如果應用已實現註冊功能：

1. **啟動應用**
   ```bash
   flutter run
   ```

2. **前往註冊頁面**
   - 找到註冊/登入按鈕
   - 填寫測試帳號資訊

3. **註冊測試帳號**
   ```
   Email: test@bowlingarsenal.com
   Password: TestPassword123!
   ```

## 方法3：使用 SQL 直接創建（進階）

### 在 Supabase SQL Editor 中執行：

```sql
-- 創建測試用戶
-- 注意：這種方法需要手動處理密碼加密，不推薦

-- 方法3A: 使用 auth.users 插入（需要額外設置）
-- 這通常需要更複雜的設置，建議使用方法1

-- 方法3B: 創建一個用於開發的臨時用戶記錄
-- 僅供測試 favorite_balls 表的關聯，不是真正的認證用戶
INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    confirmation_token,
    email_change_token_new,
    recovery_token
) VALUES (
    gen_random_uuid(),
    'test@bowlingarsenal.com',
    crypt('TestPassword123!', gen_salt('bf')),
    now(),
    now(),
    now(),
    '',
    '',
    ''
);
```

⚠️ **注意：方法3不推薦，容易出錯，建議使用方法1**

## 測試帳號資訊

創建完成後，請記錄以下資訊：

```
測試帳號資訊：
- Email: test@bowlingarsenal.com
- Password: TestPassword123!
- 用途: 開發測試用，測試收藏、個人資料等需要認證的功能
```

## 在應用中使用測試帳號

### 登入測試：

1. **啟動應用**
   ```bash
   flutter run --debug
   ```

2. **前往登入頁面**
   - 找到登入按鈕或頁面

3. **使用測試帳號登入**
   - Email: `test@bowlingarsenal.com`
   - Password: `TestPassword123!`

4. **驗證登入成功**
   - 檢查控制台是否有用戶ID輸出
   - 確認應用狀態顯示已登入

### 測試收藏功能：

1. **前往 Ball Library**
2. **點擊任意球具的愛心按鈕**
3. **查看控制台輸出**：
   ```
   🔍 isFavorite - User ID: [uuid], Ball ID: [number]
   💖 Compact Favorite button tapped for ball: [name] (ID: [id])
   📝 Attempting to insert into favorite_balls...
   ✅ Successfully added to favorites
   ```

## 驗證數據庫記錄

### 檢查收藏記錄：

在 Supabase SQL Editor 中執行：

```sql
-- 查看所有收藏記錄
SELECT 
    fb.*,
    u.email as user_email,
    bb.name as ball_name
FROM favorite_balls fb
JOIN auth.users u ON fb.user_id = u.id
JOIN bowling_balls bb ON fb.ball_id = bb.id
ORDER BY fb.created_at DESC;

-- 查看特定用戶的收藏
SELECT 
    fb.*,
    bb.name as ball_name
FROM favorite_balls fb
JOIN bowling_balls bb ON fb.ball_id = bb.id
WHERE fb.user_id = '[你的測試用戶UUID]'
ORDER BY fb.created_at DESC;
```

## 清理測試資料

### 清除測試收藏記錄：

```sql
-- 刪除特定測試用戶的所有收藏
DELETE FROM favorite_balls 
WHERE user_id = '[測試用戶UUID]';

-- 或刪除所有收藏記錄（謹慎使用）
DELETE FROM favorite_balls;
```

### 刪除測試用戶：

在 Supabase Dashboard > Authentication > Users 中：
- 找到測試用戶
- 點擊刪除按鈕

## 故障排除

### 常見問題：

1. **"User not authenticated"**
   - 確認已正確登入
   - 檢查 Supabase 連接是否正常

2. **"Failed to add ball to favorites"**
   - 檢查 favorite_balls 表是否存在
   - 確認 RLS 政策是否正確設置

3. **愛心按鈕沒反應**
   - 確認控制台有日誌輸出
   - 檢查是否有 Flutter 編譯錯誤

### 除錯命令：

```bash
# 查看 Flutter 詳細日誌
flutter run --debug --verbose

# 清理並重新建構
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**記住：** 
- 測試帳號僅供開發使用
- 生產環境中請使用適當的用戶管理流程
- 定期清理測試資料以保持開發環境整潔