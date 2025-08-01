# 修正 Color 值範圍問題

## 問題說明
出現錯誤：`value 4294956800 is out of range for type integer code 22003`

這是因為 Dart 的 Color.value 是 32 位無符號整數（0 到 4,294,967,295），但 PostgreSQL 的 INTEGER 類型是有符號 32 位整數（-2,147,483,648 到 2,147,483,647）。

## 解決方案

### 方案一：修改資料庫欄位類型（推薦）

在 Supabase SQL Editor 中執行：

```sql
-- 修改 bag_categories 表的 theme_color 欄位為 BIGINT
ALTER TABLE public.bag_categories 
ALTER COLUMN theme_color TYPE BIGINT;
```

### 方案二：使用程式碼轉換（已實現）

如果不想修改資料庫，程式碼中的 ColorConverter 已經修改為處理這個問題：
- 將無符號整數轉換為有符號整數儲存
- 讀取時再轉換回無符號整數

## 建議
**建議使用方案一**，因為：
1. 更直接和清晰
2. 避免複雜的數值轉換
3. 未來維護更簡單

## 執行步驟

1. 登入 Supabase Dashboard
2. 進入 SQL Editor
3. 執行上述 ALTER TABLE 語句
4. 確認修改成功

完成後，Arsenal 系統就能正常處理所有 Color 值了！