# 🎳 StrikeTrack 訓練模組後端設定指南

**版本**: 1.0  
**最後更新**: 2025-01-15  
**難度**: 初學者友善 👶

---

## 📋 這個指南會教你什麼

這個指南會一步一步教你設定 Supabase 資料庫，讓你的保齡球 App 可以：
- ✅ 儲存用戶的訓練記錄
- ✅ 記住用戶選擇的設定（油圖、計分方式等）
- ✅ 保護用戶資料安全（只有本人能看到自己的記錄）
- ✅ 處理大量資料而不會變慢

**完全不懂 SQL？沒關係！** 這份指南會告訴你每一行程式碼是做什麼的，只要複製貼上就行了。

## 🚀 開始前的準備

### 1. 確認你有這些東西：
- [ ] 一個 Supabase 帳號（免費的就夠用）
- [ ] 已經建立好的 Supabase 專案
- [ ] 能夠登入 Supabase Dashboard

### 2. 找到 SQL Editor
1. 登入 [supabase.com](https://supabase.com)
2. 點擊你的專案
3. 在左邊找到 "SQL Editor"（像一個資料庫圖示）
4. 點進去，你會看到一個可以輸入程式碼的地方

**重要提醒**: 我們會在這個 SQL Editor 裡面輸入一些程式碼來建立資料表。就像在 Word 裡打字一樣簡單！

---

## 📊 第一步：建立主要資料表

### 🗂️ 什麼是資料表？
想像一下 Excel 試算表，每一行是一筆記錄，每一欄是不同的資訊。我們要建立兩個「試算表」：
1. **訓練會話表** - 記錄每次去保齡球館的基本資訊
2. **比賽記錄表** - 記錄每一局的詳細分數

### 📝 第一個表：training_sessions（訓練會話）

**這個表要存什麼？**
- 用戶是誰
- 訓練標題（例如：「週末練習」）
- 訓練日期
- 保齡球館名稱
- 油圖設定（House Pattern 還是 Sport Pattern）
- 計分方式選擇

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立訓練會話主表
-- 這就像建立一個 Excel 試算表，有很多欄位來存放不同的資訊
CREATE TABLE training_sessions (
  -- id: 每筆記錄的獨特編號（系統自動產生）
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- user_id: 記錄這是哪個用戶的資料
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- === 第一步的資訊 ===
  -- title: 訓練標題，例如「週末練習」（必填）
  title TEXT NOT NULL CHECK (length(title) > 0),
  
  -- date: 訓練日期（必填）
  date DATE NOT NULL,
  
  -- center: 保齡球館名稱（必填）
  center TEXT NOT NULL CHECK (length(center) > 0),
  
  -- === 第二步的資訊 ===
  -- is_house_pattern: 是 House Pattern 還是 Sport Pattern
  -- true = House Pattern, false = Sport Pattern
  is_house_pattern BOOLEAN NOT NULL DEFAULT true,
  
  -- oil_pattern_name: 如果是 Sport Pattern，油圖叫什麼名字
  oil_pattern_name TEXT NULL,
  
  -- oil_pattern_length: 如果是 Sport Pattern，長度是多少（只能 20-60）
  oil_pattern_length INTEGER NULL CHECK (oil_pattern_length >= 20 AND oil_pattern_length <= 60),
  
  -- === 第三步的資訊 ===
  -- scoring_method: 計分方式，只能是 'traditional' 或 'current'
  scoring_method TEXT NOT NULL DEFAULT 'traditional' CHECK (scoring_method IN ('traditional', 'current')),
  
  -- input_method: 輸入方式，只能是 'quick' 或 'detailed'
  input_method TEXT NOT NULL DEFAULT 'quick' CHECK (input_method IN ('quick', 'detailed')),
  
  -- === 系統自動產生的資訊 ===
  -- created_at: 記錄建立時間（系統自動填入）
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- updated_at: 記錄最後修改時間（系統自動填入）
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- === 智慧檢查規則 ===
  -- 如果選擇 Sport Pattern，一定要填寫油圖名稱
  CONSTRAINT valid_sport_pattern CHECK (
    is_house_pattern = true OR 
    (is_house_pattern = false AND oil_pattern_name IS NOT NULL AND length(oil_pattern_name) > 0)
  )
);
```

**看到 "Success. No rows returned" 就代表成功了！** ✅

### 📝 第二個表：games（單局比賽記錄）

**這個表要存什麼？**
- 屬於哪個訓練會話
- 第幾局（第1局、第2局...）
- 總分
- 全倒數、補中數
- 使用的球具
- 備註

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立比賽記錄表
-- 這個表記錄每一局保齡球的詳細資訊
CREATE TABLE games (
  -- id: 每局比賽的獨特編號（系統自動產生）
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- training_session_id: 這局比賽屬於哪個訓練會話
  -- 如果訓練會話被刪除，相關的比賽記錄也會自動刪除
  training_session_id UUID REFERENCES training_sessions(id) ON DELETE CASCADE,
  
  -- === 比賽基本資訊 ===
  -- game_number: 第幾局（1, 2, 3...）
  game_number INTEGER NOT NULL CHECK (game_number > 0),
  
  -- total_score: 這局的總分（0-300分）
  total_score INTEGER NOT NULL DEFAULT 0 CHECK (total_score >= 0 AND total_score <= 300),
  
  -- === 詳細計分資訊 ===
  -- frame_scores: 每一格的分數（存成一個清單）
  frame_scores INTEGER[] DEFAULT '{}',
  
  -- strikes: 這局有幾個全倒（最多12個）
  strikes INTEGER DEFAULT 0 CHECK (strikes >= 0 AND strikes <= 12),
  
  -- spares: 這局有幾個補中（最多10個）
  spares INTEGER DEFAULT 0 CHECK (spares >= 0 AND spares <= 10),
  
  -- === 額外資訊 ===
  -- notes: 這局的備註或心得
  notes TEXT NULL,
  
  -- balls_used: 用了哪些球具（以 JSON 格式儲存，可以存多個球具）
  balls_used JSONB DEFAULT '[]',
  
  -- detailed_rolls: 詳細的投球記錄（當選擇 Frame by Frame 時使用）
  detailed_rolls JSONB DEFAULT '[]',
  
  -- === 系統資訊 ===
  -- timestamp: 這局比賽的時間
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  
  -- === 防止重複規則 ===
  -- 確保在同一個訓練會話中，不會有兩個「第1局」
  UNIQUE(training_session_id, game_number)
);
```

**看到 "Success. No rows returned" 就代表成功了！** ✅

---

## 🔍 第二步：建立搜尋加速器（索引）

### 🤔 什麼是索引？
想像你有一本很厚的字典，如果沒有目錄，你要找一個字就要從第一頁翻到最後一頁。索引就像是字典的目錄，讓電腦可以很快找到資料。

### 📝 建立索引

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立搜尋加速器（索引）
-- 這些會讓 App 查詢資料時變得超級快

-- 1. 讓「查詢某用戶的訓練記錄」變快
-- 依照日期由新到舊排列
CREATE INDEX idx_training_sessions_user_date ON training_sessions(user_id, date DESC);

-- 2. 讓「查詢某用戶最近的訓練」變快  
-- 依照建立時間由新到舊排列
CREATE INDEX idx_training_sessions_user_created ON training_sessions(user_id, created_at DESC);

-- 3. 讓「查詢特定日期的訓練」變快
CREATE INDEX idx_training_sessions_date ON training_sessions(date DESC);

-- 4. 讓「查詢某訓練會話的所有比賽」變快
CREATE INDEX idx_games_session ON games(training_session_id, game_number);

-- 5. 讓「查詢比賽時間」變快
CREATE INDEX idx_games_timestamp ON games(timestamp DESC);

-- 6. 讓「查詢高分記錄」變快
CREATE INDEX idx_games_score ON games(total_score DESC);
```

**看到一堆 "Success. No rows returned" 就代表成功了！** ✅

---

## 🔐 第三步：設定資料安全保護

### 🤔 什麼是 RLS（Row Level Security）？
想像你住在公寓大樓，每個人都有自己的房間鑰匙，只能進入自己的房間。RLS 就是這樣的概念，確保每個用戶只能看到和修改自己的資料。

### 📝 第一部分：保護訓練會話資料

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 啟動資料保護功能
-- 這會確保每個用戶只能看到自己的訓練記錄
ALTER TABLE training_sessions ENABLE ROW LEVEL SECURITY;

-- 規則 1：用戶只能看到自己的訓練記錄
-- 就像只能看到自己的日記，不能看別人的
CREATE POLICY "Users can view own training sessions" ON training_sessions
  FOR SELECT USING (auth.uid() = user_id);

-- 規則 2：用戶只能建立自己的訓練記錄  
-- 不能幫別人建立記錄
CREATE POLICY "Users can create own training sessions" ON training_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 規則 3：用戶只能修改自己的訓練記錄
-- 不能修改別人的記錄
CREATE POLICY "Users can update own training sessions" ON training_sessions
  FOR UPDATE USING (auth.uid() = user_id);

-- 規則 4：用戶只能刪除自己的訓練記錄
-- 不能刪除別人的記錄
CREATE POLICY "Users can delete own training sessions" ON training_sessions
  FOR DELETE USING (auth.uid() = user_id);
```

### 📝 第二部分：保護比賽記錄資料

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 保護比賽記錄
-- 確保用戶只能操作自己訓練會話下的比賽記錄
ALTER TABLE games ENABLE ROW LEVEL SECURITY;

-- 規則 1：只能看到自己訓練會話下的比賽
-- 檢查這個比賽是否屬於用戶自己的訓練會話
CREATE POLICY "Users can view own games" ON games
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM training_sessions 
      WHERE id = games.training_session_id 
      AND user_id = auth.uid()
    )
  );

-- 規則 2：只能在自己的訓練會話下新增比賽
CREATE POLICY "Users can create games in own sessions" ON games
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM training_sessions 
      WHERE id = games.training_session_id 
      AND user_id = auth.uid()
    )
  );

-- 規則 3：只能修改自己的比賽記錄
CREATE POLICY "Users can update own games" ON games
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM training_sessions 
      WHERE id = games.training_session_id 
      AND user_id = auth.uid()
    )
  );

-- 規則 4：只能刪除自己的比賽記錄
CREATE POLICY "Users can delete own games" ON games
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM training_sessions 
      WHERE id = games.training_session_id 
      AND user_id = auth.uid()
    )
  );
```

---

## ⚙️ 第四步：建立自動化功能

### 🤔 什麼是自動化功能？
就像手機會自動顯示現在幾點一樣，我們要讓資料庫自動幫我們做一些事情，例如記錄「最後修改時間」。

### 📝 第一部分：自動更新修改時間

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立一個「自動更新時間」的功能
-- 每次有人修改訓練記錄時，系統會自動記錄現在的時間
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  -- 把修改時間設定為現在
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- 讓訓練會話表使用這個自動更新功能
CREATE TRIGGER update_training_sessions_updated_at 
  BEFORE UPDATE ON training_sessions 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 📝 第二部分：自動檢查資料正確性

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立一個「智慧檢查」功能
-- 確保油圖設定的邏輯是對的
CREATE OR REPLACE FUNCTION validate_oil_pattern_settings()
RETURNS TRIGGER AS $$
BEGIN
  -- 檢查：如果選 Sport Pattern，一定要填寫油圖名稱
  IF NEW.is_house_pattern = false AND (NEW.oil_pattern_name IS NULL OR length(NEW.oil_pattern_name) = 0) THEN
    RAISE EXCEPTION 'Sport pattern must have a name';
  END IF;
  
  -- 檢查：如果選 House Pattern，就清空油圖相關欄位
  IF NEW.is_house_pattern = true THEN
    NEW.oil_pattern_name = NULL;
    NEW.oil_pattern_length = NULL;
  END IF;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

-- 讓系統在新增或修改訓練記錄時，自動執行這個檢查
CREATE TRIGGER validate_oil_pattern_before_insert_or_update
  BEFORE INSERT OR UPDATE ON training_sessions
  FOR EACH ROW EXECUTE FUNCTION validate_oil_pattern_settings();
```

---

## 🧪 第五步：測試是否設定成功

### 📝 測試 1：建立一筆測試資料

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 建立一筆測試的訓練記錄
-- 注意：auth.uid() 會自動填入目前登入用戶的 ID
INSERT INTO training_sessions (
  user_id,           -- 用戶 ID
  title,            -- 訓練標題  
  date,             -- 日期
  center,           -- 保齡球館
  is_house_pattern, -- 是否為 House Pattern
  scoring_method,   -- 計分方式
  input_method      -- 輸入方式
) VALUES (
  auth.uid(),               -- 自動填入目前用戶
  'Test Training Session',  -- 測試標題
  CURRENT_DATE,             -- 今天的日期
  'Test Bowling Center',    -- 測試保齡球館名稱
  true,                     -- 選擇 House Pattern
  'traditional',            -- 選擇傳統計分
  'quick'                   -- 選擇快速輸入
);
```

**如果成功，你會看到 "Success. 1 row" 或類似的訊息** ✅

### 📝 測試 2：建立一筆 Sport Pattern 的測試資料

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 測試 Sport Pattern 的訓練記錄
INSERT INTO training_sessions (
  user_id,
  title,
  date,
  center,
  is_house_pattern,  -- 這次選 false（Sport Pattern）
  oil_pattern_name,  -- 油圖名稱（必填）
  oil_pattern_length, -- 油圖長度
  scoring_method,
  input_method
) VALUES (
  auth.uid(),
  'Sport Pattern Test',     -- 測試標題
  CURRENT_DATE,             -- 今天
  'Elite Bowling Center',   -- 測試保齡球館
  false,                    -- Sport Pattern
  'Chameleon',              -- 油圖名稱
  42,                       -- 油圖長度
  'current',                -- 現代計分
  'detailed'                -- 詳細輸入
);
```

### 📝 測試 3：檢查資料是否正確儲存

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 查看我們剛剛建立的測試資料
-- 只會顯示目前登入用戶的資料（感謝 RLS 保護）
SELECT 
  title AS "訓練標題",
  date AS "日期", 
  center AS "保齡球館",
  CASE 
    WHEN is_house_pattern = true THEN 'House Pattern'
    ELSE 'Sport Pattern' 
  END AS "油圖類型",
  oil_pattern_name AS "油圖名稱",
  oil_pattern_length AS "油圖長度",
  scoring_method AS "計分方式",
  input_method AS "輸入方式",
  created_at AS "建立時間"
FROM training_sessions 
ORDER BY created_at DESC;
```

**你應該會看到兩筆測試記錄，就像一個表格一樣顯示** ✅

---

## 🧼 第六步：清理測試資料

**測試完成後，把測試資料刪除：**

```sql
-- 刪除測試資料
-- 只會刪除標題包含 'Test' 的記錄
DELETE FROM training_sessions 
WHERE user_id = auth.uid() 
AND title LIKE '%Test%';
```

---

## ❌ 第七步：測試錯誤檢查（這個應該要失敗）

### 📝 測試錯誤情況 1：Sport Pattern 但沒填油圖名稱

**複製下面這段程式碼，貼到 SQL Editor，然後按 RUN：**

```sql
-- 這個應該要失敗！因為選了 Sport Pattern 但沒填油圖名稱
INSERT INTO training_sessions (
  user_id,
  title,
  date,
  center,
  is_house_pattern,  -- false (Sport Pattern)
  oil_pattern_name,  -- NULL（沒填）
  scoring_method,
  input_method
) VALUES (
  auth.uid(),
  'This Should Fail',
  CURRENT_DATE,
  'Test Center',
  false,             -- Sport Pattern
  NULL,              -- 沒填油圖名稱（應該失敗）
  'traditional',
  'quick'
);
```

**你應該會看到錯誤訊息，這是正常的！** ❌ 表示我們的檢查功能有在工作

### 📝 測試錯誤情況 2：無效的油圖長度

```sql
-- 這個也應該要失敗！因為油圖長度超出範圍
INSERT INTO training_sessions (
  user_id,
  title, 
  date,
  center,
  is_house_pattern,
  oil_pattern_name,
  oil_pattern_length, -- 15（小於 20，應該失敗）
  scoring_method,
  input_method
) VALUES (
  auth.uid(),
  'This Should Also Fail',
  CURRENT_DATE,
  'Test Center', 
  false,
  'Test Pattern',
  15,                -- 無效長度（應該失敗）
  'traditional',
  'quick'
);
```

**又看到錯誤訊息？太好了！** ❌ 代表資料驗證功能正常工作

---

## ✅ 第八步：最終驗證

### 📝 建立一筆正確的資料來確認一切正常

```sql
-- 最後測試：建立一筆完全正確的資料
INSERT INTO training_sessions (
  user_id,
  title,
  date,
  center,
  is_house_pattern,
  oil_pattern_name,
  oil_pattern_length,
  scoring_method,
  input_method
) VALUES (
  auth.uid(),
  'Final Test Session',
  CURRENT_DATE,
  'Perfect Bowling Center',
  false,              -- Sport Pattern
  'Wolf',             -- 有效的油圖名稱
  39,                 -- 有效的油圖長度（20-60之間）
  'current',          -- 有效的計分方式
  'detailed'          -- 有效的輸入方式
);

-- 立刻查看是否成功建立
SELECT 
  title,
  is_house_pattern,
  oil_pattern_name,
  oil_pattern_length
FROM training_sessions 
WHERE title = 'Final Test Session';
```

**你應該會看到剛剛建立的記錄** ✅

### 📝 測試比賽記錄

```sql
-- 測試在剛剛建立的訓練會話下新增一局比賽
INSERT INTO games (
  training_session_id,  -- 比賽屬於哪個訓練會話
  game_number,          -- 第幾局
  total_score,          -- 總分
  strikes,              -- 全倒數
  spares                -- 補中數
) VALUES (
  -- 找到剛剛建立的訓練會話 ID
  (SELECT id FROM training_sessions WHERE title = 'Final Test Session' LIMIT 1),
  1,                    -- 第1局
  156,                  -- 總分 156
  3,                    -- 3個全倒
  4                     -- 4個補中
);

-- 查看比賽記錄是否正確儲存
SELECT 
  ts.title AS "訓練會話",
  g.game_number AS "第幾局",
  g.total_score AS "總分",
  g.strikes AS "全倒數",
  g.spares AS "補中數"
FROM games g
JOIN training_sessions ts ON ts.id = g.training_session_id
WHERE ts.title = 'Final Test Session';
```

---

## 🧹 第九步：清理測試資料

**測試完成後，把所有測試資料清除：**

```sql
-- 清除所有測試資料
-- 因為設定了 CASCADE，刪除訓練會話時會自動刪除相關的比賽記錄
DELETE FROM training_sessions 
WHERE user_id = auth.uid() 
AND title LIKE '%Test%';
```

---

## 🎯 設定完成檢查清單

### ✅ 確認這些都完成了：

#### 📊 資料表建立
- [ ] `training_sessions` 表已建立（沒有錯誤訊息）
- [ ] `games` 表已建立（沒有錯誤訊息）

#### 🔍 搜尋加速
- [ ] 所有索引都建立成功（6個 "Success" 訊息）

#### 🔐 安全保護  
- [ ] `training_sessions` 的 4 個安全規則都建立成功
- [ ] `games` 的 4 個安全規則都建立成功

#### 🧪 測試驗證
- [ ] 正確的資料可以成功新增
- [ ] 錯誤的資料會被拒絕（看到錯誤訊息是正常的）
- [ ] 查詢資料時只能看到自己的記錄

---

## 🆘 出問題了怎麼辦？

### 常見問題 1：看不到 SQL Editor
**解決方法：**
1. 確認你有專案的管理權限
2. 重新整理網頁
3. 檢查是否選對專案

### 常見問題 2：執行 SQL 時出現權限錯誤
**解決方法：**
1. 確認你是專案擁有者或管理員
2. 檢查 Supabase 專案是否正常運作

### 常見問題 3：RLS 政策無法建立
**解決方法：**
1. 確認資料表已經建立成功
2. 按照順序執行，不要跳步驟

### 常見問題 4：想要重新開始
**完全重置的程式碼：**
```sql
-- 如果想要重新開始，執行這個會清除所有東西
DROP TABLE IF EXISTS games CASCADE;
DROP TABLE IF EXISTS training_sessions CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS validate_oil_pattern_settings() CASCADE;

-- 然後重新從第一步開始
```

---

## 🎉 恭喜！設定完成

如果你完成了所有步驟，你的 Supabase 後端現在已經準備好了！

### 接下來會發生什麼：
1. ✅ 你的 App 可以儲存用戶的訓練記錄
2. ✅ 每個用戶只能看到自己的資料
3. ✅ 系統會自動檢查資料是否正確
4. ✅ 即使有很多用戶，查詢速度也會很快

### 準備對接前端：
你的 Supabase 後端已經設定完成，現在可以告訴開發者「後端準備好了！」，開始連接前端的訓練建立流程。

---

## 📚 小知識：為什麼這樣設計？

### 🔢 關於資料量
- **千萬筆資料對 PostgreSQL 來說很正常**
- Instagram 每天處理 **數十億** 筆資料
- 你的保齡球 App 就算有 10 萬用戶也不會有問題

### 🏗️ 關於架構設計
這個設計遵循「關聯式資料庫」的最佳實踐：
- **主表**（training_sessions）存放基本資訊
- **子表**（games）存放詳細記錄
- **一對多關係**：一個訓練會話可以有多局比賽

這就像一個資料夾（訓練會話）裡面可以放很多文件（比賽記錄）一樣自然！