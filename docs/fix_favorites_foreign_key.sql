-- 修正 favorite_balls 表的外鍵關係
-- 這個腳本解決 PostgrestException 關於找不到外鍵關係的問題

-- 首先檢查現有的外鍵約束
SELECT 
    tc.table_name, 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND (tc.table_name = 'favorite_balls' OR ccu.table_name = 'bowling_balls');

-- 如果外鍵不存在，則創建它們

-- 刪除舊的外鍵約束（如果存在）
DO $$ 
BEGIN
    -- 刪除 ball_id 外鍵約束（如果存在）
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'favorite_balls_ball_id_fkey' 
        AND table_name = 'favorite_balls'
    ) THEN
        ALTER TABLE favorite_balls DROP CONSTRAINT favorite_balls_ball_id_fkey;
    END IF;
    
    -- 刪除 user_id 外鍵約束（如果存在）
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'favorite_balls_user_id_fkey' 
        AND table_name = 'favorite_balls'
    ) THEN
        ALTER TABLE favorite_balls DROP CONSTRAINT favorite_balls_user_id_fkey;
    END IF;
END $$;

-- 重新創建正確的外鍵約束
ALTER TABLE favorite_balls 
ADD CONSTRAINT favorite_balls_ball_id_fkey 
FOREIGN KEY (ball_id) REFERENCES bowling_balls(id) ON DELETE CASCADE;

ALTER TABLE favorite_balls 
ADD CONSTRAINT favorite_balls_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- 驗證外鍵關係是否正確創建
SELECT 
    tc.table_name, 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = 'favorite_balls';

-- 測試聯合查詢是否現在能正常工作
-- 這個查詢應該不再拋出 PGRST200 錯誤
SELECT 
    fb.ball_id,
    fb.created_at,
    bb.*
FROM favorite_balls fb
INNER JOIN bowling_balls bb ON fb.ball_id = bb.id
WHERE fb.user_id = auth.uid()
ORDER BY fb.created_at DESC
LIMIT 5;

-- 如果你想恢復原來的 Supabase 查詢方式，可以使用：
-- .select('ball_id, created_at, bowling_balls!inner(*)')
-- 這應該在外鍵關係修正後正常工作