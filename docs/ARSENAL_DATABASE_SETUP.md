# Arsenal 資料庫設定指南

## 概述
為了讓 Arsenal 系統正常運作，需要在 Supabase 資料庫中建立以下表格和關聯。請依照順序執行下列 SQL 語句。

## 📋 建立步驟

### 1. 登入 Supabase Dashboard
- 進入你的 Supabase 專案
- 點選左側選單的 "SQL Editor"

### 2. 建立資料表
請依照以下順序執行 SQL 語句：

---

## 🏗️ 第一步：建立公用函數

```sql
-- 建立更新時間觸發器函數
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';
```

---

## 🏗️ 第二步：建立球袋分類表 (bag_categories)

```sql
-- 建立 bag_categories 表
CREATE TABLE public.bag_categories (
    category_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    icon_code_point INTEGER NOT NULL DEFAULT 57669, -- Iconsax.bag 的 codePoint
    icon_font_family TEXT DEFAULT 'Iconsax',
    icon_font_package TEXT DEFAULT 'iconsax',
    theme_color INTEGER NOT NULL DEFAULT -16537838, -- Color(0xFF2E7D32).value
    display_order INTEGER NOT NULL DEFAULT 0,
    is_default BOOLEAN NOT NULL DEFAULT false,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 建立索引
CREATE INDEX idx_bag_categories_user_id ON public.bag_categories(user_id);
CREATE INDEX idx_bag_categories_display_order ON public.bag_categories(display_order);

-- 建立更新時間觸發器
CREATE TRIGGER update_bag_categories_updated_at 
    BEFORE UPDATE ON public.bag_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 設定 RLS (Row Level Security)
ALTER TABLE public.bag_categories ENABLE ROW LEVEL SECURITY;

-- 建立 RLS 政策
CREATE POLICY "Users can view own categories" ON public.bag_categories
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own categories" ON public.bag_categories
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own categories" ON public.bag_categories
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own categories" ON public.bag_categories
    FOR DELETE USING (auth.uid() = user_id);
```

---

## 🏗️ 第三步：建立球具鑽法表 (ball_layouts)

```sql
-- 建立 ball_layouts 表
CREATE TABLE public.ball_layouts (
    layout_id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    layout_name TEXT NOT NULL,
    pin_pap_distance DECIMAL(4,2),
    pap_pin_angle INTEGER,
    pin_buffer_distance DECIMAL(4,2),
    psa_angle INTEGER,
    layout_type TEXT NOT NULL DEFAULT 'balanced',
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 建立索引
CREATE INDEX idx_ball_layouts_user_id ON public.ball_layouts(user_id);

-- 建立更新時間觸發器
CREATE TRIGGER update_ball_layouts_updated_at 
    BEFORE UPDATE ON public.ball_layouts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 設定 RLS
ALTER TABLE public.ball_layouts ENABLE ROW LEVEL SECURITY;

-- 建立 RLS 政策
CREATE POLICY "Users can view own layouts" ON public.ball_layouts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own layouts" ON public.ball_layouts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own layouts" ON public.ball_layouts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own layouts" ON public.ball_layouts
    FOR DELETE USING (auth.uid() = user_id);
```

---

## 🏗️ 第四步：建立球具實例表 (arsenal_ball_instances)

```sql
-- 建立 arsenal_ball_instances 表
CREATE TABLE public.arsenal_ball_instances (
    instance_id TEXT PRIMARY KEY,
    ball_id TEXT NOT NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    nickname TEXT DEFAULT '',
    added_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    purchase_date DATE,
    bag_category_id TEXT,
    layout_id TEXT,
    instance_number INTEGER NOT NULL DEFAULT 1,
    is_custom_ball BOOLEAN NOT NULL DEFAULT false,
    local_image_path TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 建立外鍵關聯
ALTER TABLE public.arsenal_ball_instances 
ADD CONSTRAINT fk_ball_data 
FOREIGN KEY (ball_id) REFERENCES public.ball_data(id) ON DELETE CASCADE;

ALTER TABLE public.arsenal_ball_instances 
ADD CONSTRAINT fk_bag_category 
FOREIGN KEY (bag_category_id) REFERENCES public.bag_categories(category_id) ON DELETE SET NULL;

ALTER TABLE public.arsenal_ball_instances 
ADD CONSTRAINT fk_ball_layout 
FOREIGN KEY (layout_id) REFERENCES public.ball_layouts(layout_id) ON DELETE SET NULL;

-- 建立索引提升查詢效能
CREATE INDEX idx_arsenal_user_id ON public.arsenal_ball_instances(user_id);
CREATE INDEX idx_arsenal_ball_id ON public.arsenal_ball_instances(ball_id);
CREATE INDEX idx_arsenal_category ON public.arsenal_ball_instances(bag_category_id);
CREATE INDEX idx_arsenal_added_date ON public.arsenal_ball_instances(added_date DESC);

-- 建立更新時間觸發器
CREATE TRIGGER update_arsenal_ball_instances_updated_at 
    BEFORE UPDATE ON public.arsenal_ball_instances 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 設定 RLS (Row Level Security)
ALTER TABLE public.arsenal_ball_instances ENABLE ROW LEVEL SECURITY;

-- 建立 RLS 政策：用戶只能存取自己的資料
CREATE POLICY "Users can view own arsenal instances" ON public.arsenal_ball_instances
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own arsenal instances" ON public.arsenal_ball_instances
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own arsenal instances" ON public.arsenal_ball_instances
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own arsenal instances" ON public.arsenal_ball_instances
    FOR DELETE USING (auth.uid() = user_id);
```

---

## 🏗️ 第五步：插入預設分類資料

```sql
-- 為每個用戶插入預設分類的函數
CREATE OR REPLACE FUNCTION create_default_categories_for_user(user_uuid UUID)
RETURNS void AS $$
BEGIN
    INSERT INTO public.bag_categories (
        category_id, name, user_id, icon_code_point, icon_font_family, 
        theme_color, display_order, is_default, description
    ) VALUES 
    (
        'competition_' || user_uuid::text,
        '比賽球袋',
        user_uuid,
        58394, -- Iconsax.medal_star
        'Iconsax',
        -16743936, -- Color(0xFFFFD700) Gold
        0,
        true,
        '比賽時使用的球具'
    ),
    (
        'practice_' || user_uuid::text,
        '練習球袋',
        user_uuid,
        57669, -- Iconsax.bag
        'Iconsax',
        -14043654, -- Color(0xFF1976D2) Blue
        1,
        true,
        '練習時使用的球具'
    ),
    (
        'collection_' || user_uuid::text,
        '收藏球袋',
        user_uuid,
        58155, -- Iconsax.heart
        'Iconsax',
        -6633046, -- Color(0xFF9C27B0) Purple
        2,
        true,
        '收藏的球具'
    ),
    (
        'testing_' || user_uuid::text,
        '新球測試',
        user_uuid,
        58108, -- Iconsax.game
        'Iconsax',
        -32256, -- Color(0xFFFF8F00) Orange
        3,
        true,
        '測試中的新球具'
    );
END;
$$ LANGUAGE plpgsql;

-- 為現有用戶創建預設分類的觸發器
CREATE OR REPLACE FUNCTION trigger_create_default_categories()
RETURNS trigger AS $$
BEGIN
    PERFORM create_default_categories_for_user(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 在用戶註冊時自動創建預設分類
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION trigger_create_default_categories();
```

---

## ✅ 驗證設定

執行完成後，請檢查以下項目：

### 1. 確認表格建立成功
在 Supabase Dashboard 的 "Table Editor" 中應該能看到：
- ✅ `bag_categories`
- ✅ `ball_layouts` 
- ✅ `arsenal_ball_instances`

### 2. 確認外鍵關聯
- ✅ `arsenal_ball_instances.ball_id` → `ball_data.id`
- ✅ `arsenal_ball_instances.bag_category_id` → `bag_categories.category_id`
- ✅ `arsenal_ball_instances.layout_id` → `ball_layouts.layout_id`

### 3. 確認 RLS 政策
每個表都應該有對應的 RLS 政策確保用戶只能存取自己的資料。

---

## 🚀 完成後

設定完成後，Arsenal 系統將能夠：
- ✅ 管理用戶的球袋分類
- ✅ 儲存球具實例（支援多實例）
- ✅ 管理球具鑽法配置
- ✅ 提供完整的 CRUD 操作
- ✅ 確保資料安全性

如有任何問題，請檢查 Supabase 的錯誤日誌或聯繫開發團隊。

---

## 📝 注意事項

1. **確保 ball_data 表已存在**：Arsenal 系統依賴現有的 `ball_data` 表
2. **RLS 設定**：所有表都啟用了 Row Level Security 確保用戶資料隔離
3. **索引優化**：已建立必要的索引提升查詢效能
4. **自動更新時間**：使用觸發器自動更新 `updated_at` 欄位
5. **預設分類**：新用戶註冊時會自動建立四個預設球袋分類