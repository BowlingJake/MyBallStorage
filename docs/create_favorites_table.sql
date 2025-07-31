-- 創建 favorite_balls 表
-- 用於存儲用戶收藏的球具

CREATE TABLE IF NOT EXISTS favorite_balls (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    ball_id INTEGER NOT NULL REFERENCES ball_data(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 確保同一用戶不會重複收藏同一個球
    UNIQUE(user_id, ball_id)
);

-- 創建索引以提高查詢性能
CREATE INDEX IF NOT EXISTS idx_favorite_balls_user_id ON favorite_balls(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_balls_ball_id ON favorite_balls(ball_id);
CREATE INDEX IF NOT EXISTS idx_favorite_balls_created_at ON favorite_balls(created_at);

-- 啟用 Row Level Security (RLS)
ALTER TABLE favorite_balls ENABLE ROW LEVEL SECURITY;

-- 創建 RLS 政策：用戶只能看到和操作自己的收藏
CREATE POLICY "Users can view their own favorites" ON favorite_balls
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own favorites" ON favorite_balls
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" ON favorite_balls
    FOR DELETE USING (auth.uid() = user_id);

-- 可選：創建一個函數來獲取用戶收藏數量
CREATE OR REPLACE FUNCTION get_user_favorite_count(user_uuid UUID DEFAULT auth.uid())
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)::INTEGER 
        FROM favorite_balls 
        WHERE user_id = user_uuid
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;