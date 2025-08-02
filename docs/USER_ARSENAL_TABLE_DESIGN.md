# User Arsenal Table 設計文檔 (簡化版)

## 表名：`user_arsenal`

這個表是 Arsenal 功能的核心，記錄用戶添加到個人球庫中的所有球實例。

## 表結構設計

### 主要欄位

| 欄位名 | 類型 | 約束 | 說明 |
|--------|------|------|------|
| `id` | SERIAL | PRIMARY KEY | 主鍵，自動遞增（唯一的球實例ID） |
| `user_id` | UUID | NOT NULL | 用戶ID，關聯到 auth.users |
| `ball_id` | INTEGER | NOT NULL | 球的ID，關聯到 ball_data 表 |
| `notes` | TEXT | NULL | 用戶對這顆球的備註 |
| `added_date` | TIMESTAMP | DEFAULT NOW() | 添加到Arsenal的日期 |
| `games_used` | INTEGER | DEFAULT 0 | 使用局數 |

### 球袋分類欄位 (最多9個)

| 欄位名 | 類型 | 約束 | 說明 |
|--------|------|------|------|
| `bag_category_1` | VARCHAR(50) | NULL | 球袋分類1名稱 |
| `bag_category_2` | VARCHAR(50) | NULL | 球袋分類2名稱 |
| `bag_category_3` | VARCHAR(50) | NULL | 球袋分類3名稱 |
| `bag_category_4` | VARCHAR(50) | NULL | 球袋分類4名稱 (付費會員) |
| `bag_category_5` | VARCHAR(50) | NULL | 球袋分類5名稱 (付費會員) |
| `bag_category_6` | VARCHAR(50) | NULL | 球袋分類6名稱 (付費會員) |
| `bag_category_7` | VARCHAR(50) | NULL | 球袋分類7名稱 (付費會員) |
| `bag_category_8` | VARCHAR(50) | NULL | 球袋分類8名稱 (付費會員) |
| `bag_category_9` | VARCHAR(50) | NULL | 球袋分類9名稱 (付費會員) |

### Layout 信息欄位 (簡化)

| 欄位名 | 類型 | 約束 | 說明 |
|--------|------|------|------|
| `has_layout` | BOOLEAN | DEFAULT FALSE | 是否設定了Layout |
| `layout_type` | VARCHAR(20) | NULL | Layout類型: 'VLS' 或 'DUAL_ANGLE' |
| `layout_value_1` | DECIMAL(4,1) | NULL | 第一個數值 (VLS: Pin-PAP, Dual: 角度1) |
| `layout_value_2` | DECIMAL(4,1) | NULL | 第二個數值 (VLS: PAP-MB, Dual: Pin-PAP) |
| `layout_value_3` | DECIMAL(4,1) | NULL | 第三個數值 (VLS: PSA角度, Dual: 角度2) |

### 索引設計

```sql
-- 查詢索引：提升用戶Arsenal查詢效能
CREATE INDEX idx_user_arsenal_user_id ON user_arsenal (user_id);

-- 日期索引：用於排序
CREATE INDEX idx_user_arsenal_added_date ON user_arsenal (added_date DESC);
```

## 業務邏輯說明

### 🎯 **重複球處理邏輯**
- **允許重複**：用戶可以添加相同的球多次（不同實例）
- **唯一標識**：每個實例都有獨立的 `id`（SERIAL主鍵）
- **區別方式**：通過 `notes` 欄位讓用戶區分（如 "新球"、"備用球"）

### 球袋分類邏輯
1. **免費會員**：只能使用 `bag_category_1` 到 `bag_category_3`
2. **付費會員**：可以使用全部9個分類
3. **分類名稱**：由用戶自定義，如 "比賽球袋"、"練習球袋"、"重油球" 等
4. **多重分類**：一顆球實例可以同時屬於多個分類

### Layout系統 (簡化)
1. **兩種格式**：
   - **VLS**：`5 x 5 x 5` (Pin-PAP x PAP-MB x PSA角度)
   - **Dual Angle**：`35° x 5 x 38°` (角度1 x Pin-PAP x 角度2)
2. **統一存儲**：使用3個 `layout_value` 欄位存儲數值
3. **Dialog輸入**：用戶選擇類型後輸入3個數值

### "All My Arsenal" 虛擬分類
- **虛擬概念**：不存儲在數據庫中
- **顯示邏輯**：前端顯示該用戶的所有球實例
- **篩選邏輯**：選擇具體分類時篩選對應球袋欄位

## 範例數據

```
-- 用戶的第一顆 Storm球
id: 1
user_id: 546cb535-57da-48fb-bb70-56f843a5faec
ball_id: 123
notes: "新購入的比賽球"
bag_category_1: "比賽球袋"
bag_category_2: "重油球"
has_layout: TRUE
layout_type: "VLS"
layout_value_1: 5.0    -- Pin-PAP
layout_value_2: 5.0    -- PAP-MB  
layout_value_3: 5.0    -- PSA角度
games_used: 25
added_date: 2025-08-03 10:30:00

-- 用戶的第二顆相同Storm球
id: 2
user_id: 546cb535-57da-48fb-bb70-56f843a5faec
ball_id: 123          -- 相同球ID
notes: "備用球，較舊"
bag_category_1: "練習球袋"
has_layout: TRUE
layout_type: "DUAL_ANGLE"
layout_value_1: 35.0   -- 角度1
layout_value_2: 5.0    -- Pin-PAP
layout_value_3: 38.0   -- 角度2
games_used: 150
added_date: 2025-08-03 11:00:00
```

## 簡化的創建SQL

```sql
CREATE TABLE user_arsenal (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  ball_id INTEGER NOT NULL,
  
  -- 基本信息
  notes TEXT,
  added_date TIMESTAMP DEFAULT NOW(),
  games_used INTEGER DEFAULT 0,
  
  -- 球袋分類 (最多9個)
  bag_category_1 VARCHAR(50),
  bag_category_2 VARCHAR(50),
  bag_category_3 VARCHAR(50),
  bag_category_4 VARCHAR(50),
  bag_category_5 VARCHAR(50),
  bag_category_6 VARCHAR(50),
  bag_category_7 VARCHAR(50),
  bag_category_8 VARCHAR(50),
  bag_category_9 VARCHAR(50),
  
  -- Layout 簡化信息
  has_layout BOOLEAN DEFAULT FALSE,
  layout_type VARCHAR(20), -- 'VLS' 或 'DUAL_ANGLE'
  layout_value_1 DECIMAL(4,1),
  layout_value_2 DECIMAL(4,1),
  layout_value_3 DECIMAL(4,1)
);
```

## 關鍵改進

1. ✅ **移除不必要欄位**：nickname、購買日期、鑽球師等
2. ✅ **簡化Layout**：只需3個數值欄位
3. ✅ **允許重複球**：移除唯一約束，用主鍵區分實例
4. ✅ **專注核心功能**：球袋分類 + Layout + 使用追蹤