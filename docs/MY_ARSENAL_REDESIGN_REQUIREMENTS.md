# My Arsenal 頁面重新設計需求文件

**文件版本:** 1.0  
**創建日期:** 2025-08-01  
**專案階段:** 需求分析與規劃  
**預估複雜度:** 高 (大型功能重構)

---

## 📋 功能概述

My Arsenal 是使用者個人保齡球收藏管理系統，提供從球庫選擇、自定義新增、分類管理、佈局規劃到數據分析的完整解決方案。

### 🎯 核心價值主張
- **個人化管理** - 打造專屬的球袋管理系統
- **靈活分類** - 支援多種使用情境的球袋分類
- **視覺化分析** - 提供球具特性的圖表分析
- **實用鑽法** - 記錄保齡球的鑽法佈局(Layout)

---

## 🔍 需求分析

### 利害關係人分析
| 角色 | 需求重點 | 使用情境 |
|------|---------|----------|
| **保齡球愛好者** | 管理個人球具收藏 | 記錄、整理、分析個人球具 |
| **競技選手** | 戰術球具配置 | 比賽前球具選擇和佈局規劃 |
| **球具收藏家** | 詳細記錄管理 | 追蹤購買時間、使用狀況 |
| **教練/顧問** | 球具分析建議 | 根據球具特性給予建議 |

### 使用情境 (User Stories)

#### 🎲 基礎管理情境
```
作為一個保齡球愛好者
我想要從球庫中選擇球具加入我的球袋
以便管理我實際擁有的球具
```

```
作為一個球具收藏家  
我想要新增球庫中沒有的球具到我的球袋
以便記錄我的完整收藏
```

#### 🗂️ 分類管理情境
```
作為一個競技選手
我想要創建不同的球袋分類（比賽用、練習用、收藏用）
以便根據不同場合快速找到合適的球具
```

#### 📐 鑽法管理情境
```
作為一個選手
我想要記錄每顆球的鑽法佈局(Layout)
以便快速確認這顆球的特性和行為
```

#### 📊 分析情境
```
作為一個想要改善技術的選手
我想要看到我球具的RG/Diff分佈圖
以便了解我的球具配置是否平衡
```

---

## 🏗️ 功能需求規格

### 1. 球具管理功能 (Core Management)

#### 1.1 從球庫加入球具
**功能描述:** 使用者可以從 Ball Library 選擇球具加入個人球袋

**詳細需求:**
- 瀏覽 Ball Library 中的所有球具
- 支援搜尋和篩選功能
- 一鍵加入到指定球袋分類
- 加入時可設定鑽法資訊
- 支援批量加入功能

**驗收標準:**
- ✅ 可以成功從 Library 加入球具
- ✅ 加入的球具資料完整同步
- ✅ 支援選擇目標球袋分類
- ✅ 提供加入成功的視覺回饋

#### 1.2 自定義新增球具
**功能描述:** 當 Ball Library 中沒有使用者需要的球具時，支援手動新增

**詳細需求:**
- 表單式新增介面，欄位與 Library 一致
- 必填欄位：名稱、品牌
- 選填欄位：圖片、核心、球皮、RG、Diff、描述等
- 圖片支援本地上傳或網路連結
- 新增後自動歸類到指定球袋

**數據模型:**
```dart
class CustomBall extends BowlingBall {
  final String userId;           // 所屬使用者
  final DateTime createdAt;      // 創建時間
  final String? localImagePath;  // 本地圖片路徑
  final bool isCustom;           // 標記為自定義球具
}
```

**驗收標準:**
- ✅ 新增表單驗證正確
- ✅ 自定義球具與 Library 球具格式一致
- ✅ 圖片上傳和顯示正常
- ✅ 數據持久化正確

#### 1.3 同球多次加入
**功能描述:** 支援同一顆球多次加入球袋，並提供備註區分

**詳細需求:**
- 同一球種可以多次加入
- 每次加入都有獨立的 ID
- 提供備註欄位標記差異
- 支援購買日期記錄
- 顯示該球的加入次數

**數據模型:**
```dart
class ArsenalBallInstance {
  final String instanceId;      // 實例 ID
  final String ballId;          // 原始球具 ID  
  final String nickname;        // 暱稱/備註
  final DateTime addedDate;     // 加入日期
  final DateTime? purchaseDate; // 購買日期
  final String bagCategory;     // 球袋分類
  final BallLayout? layout;     // 鑽法佈局
  final int instanceNumber;     // 第幾顆
}
```

### 2. 球袋分類系統 (Bag Category System)

#### 2.1 預設分類
**系統預設分類:**
- 🏆 **比賽球袋** (Competition Bag)
- 🎯 **練習球袋** (Practice Bag)  
- 💎 **收藏球袋** (Collection Bag)
- 🆕 **新球測試** (New Ball Testing)

#### 2.2 自定義分類
**功能描述:** 使用者可以創建自定義球袋分類

**詳細需求:**
- 創建、編輯、刪除分類
- 每個分類可設定圖示和顏色
- 支援分類重新排序
- 分類間可以移動球具
- 每個分類顯示球具數量

**數據模型:**
```dart
class BagCategory {
  final String categoryId;
  final String name;
  final IconData icon;
  final Color themeColor;
  final int displayOrder;
  final bool isDefault;
  final DateTime createdAt;
}
```

### 3. 鑽法佈局系統 (Ball Layout System)

#### 3.1 鑽法記錄功能
**功能描述:** 記錄每顆球的鑽法佈局資訊

**詳細需求:**
- PAP (Positive Axis Point) 距離記錄
- Pin到PAP距離 (Pin-to-PAP)
- PSA (Preferred Spin Axis) 角度
- 質量偏心位置 (MB Position)
- 鑽法類型標記 (強勾、控制、直球等)
- 鑽法圖示或照片上傳

**數據模型:**
```dart
class BallLayout {
  final String layoutId;
  final double pinToPap;        // Pin到PAP距離 (英吋)
  final double papToMb;         // PAP到MB距離 (英吋)
  final double psaAngle;        // PSA角度 (度)
  final LayoutType layoutType;  // 鑽法類型
  final String? layoutImage;    // 鑽法圖片
  final String? notes;          // 備註
  final DateTime createdAt;
}

enum LayoutType {
  aggressive,    // 強勾型
  control,       // 控制型  
  straight,      // 直球型
  skid_flip,     // 滑行翻轉型
  smooth_arc,    // 平滑弧線型
}
```

#### 3.2 鑽法管理介面
**功能需求:**
- 視覺化鑽法編輯器
- 預設鑽法模板
- 鑽法效果預測
- 鑽法比較功能

### 4. 視覺展示系統 (Display System)

#### 4.1 Grid View (網格視圖)
**設計特色:**
- 每個球具顯示為卡片
- 支援鑽法類型標記
- 品牌色彩主題
- 快速操作按鈕

**卡片資訊包含:**
- 球具圖片
- 球具名稱和品牌
- 鑽法類型標記
- RG/Diff 數值 (可選)
- 加入日期標記

#### 4.2 List View (列表視圖)  
**設計特色:**
- 與 Ball Library 差異化設計
- 更詳細的球具資訊
- 支援備註顯示
- 操作功能更豐富

**視覺差異化:**
| 特徵 | Ball Library | My Arsenal |
|------|-------------|------------|
| **主色調** | 品牌色為主 | 個人化色調 |
| **圖示** | 搜尋/篩選 | 編輯/管理 |
| **操作** | 加入球袋 | 移動/編輯/刪除 |
| **資訊** | 技術規格 | 鑽法資訊/個人備註 |

### 5. 球具分析系統 (Analysis System)

#### 5.1 十字象限圖 (RG vs Diff)
**分析維度:**
```
        高 Diff
           │
           │  Hook Monster  │  Length + Hook
           │  (強勾球)      │  (長距離強勾)
───────────┼─────────────────┼───────────
 低 RG     │                │     高 RG  
           │  Control        │  Straight
           │  (控制型)       │  (直球型)
           │
        低 Diff
```

**功能需求:**
- 動態生成散點圖
- 每個點代表一顆球具
- 支援點擊查看詳細資訊
- 象限說明和建議
- 支援匯出圖表

#### 5.2 球具分佈分析
**分析項目:**
- RG 分佈直方圖
- Diff 分佈直方圖  
- 品牌分佈圓餅圖
- 球皮類型分佈
- 購買時間軸

#### 5.3 推薦系統 (未來功能)
**基於現有球具推薦:**
- 分析球具配置缺口
- 推薦補強球種
- 建議淘汰老舊球具
- 預算規劃建議

---

## 🎨 UI/UX 設計需求

### 色彩系統
```dart
// My Arsenal 專用色彩
class ArsenalColors {
  static const primary = Color(0xFF2E7D32);      // 深綠色 (個人收藏感)
  static const secondary = Color(0xFFFF8F00);    // 橘色 (活力感)
  static const accent = Color(0xFF1976D2);       // 藍色 (分析色)
  static const background = Color(0xFF121212);   // 深色背景
}
```

### 導航結構
```
My Arsenal 主頁
├── 球袋分類標籤
│   ├── 比賽球袋
│   ├── 練習球袋  
│   └── 收藏球袋
├── 視圖切換 (Grid/List)  
├── 佈局管理
├── 分析報告
└── 設定管理
```

### 響應式設計
- **手機版**: 主要功能，簡化介面
- **平板版**: 增強佈局管理，更好的分析視圖
- **桌面版**: 完整功能，專業分析工具

---

## 🏗️ 技術架構需求

### 數據層架構
```
lib/features/arsenal/
├── data/
│   ├── models/
│   │   ├── arsenal_ball.dart          # 球袋中的球具
│   │   ├── bag_category.dart          # 球袋分類
│   │   ├── bag_layout.dart            # 佈局管理
│   │   └── arsenal_analytics.dart     # 分析數據
│   ├── repositories/
│   │   ├── arsenal_repository.dart    # 數據倉庫介面
│   │   └── supabase_arsenal_repo.dart # Supabase 實作
│   └── services/
│       ├── image_upload_service.dart  # 圖片上傳
│       └── analytics_service.dart     # 分析服務
├── logic/
│   ├── arsenal_controller.dart        # 主控制器
│   ├── category_controller.dart       # 分類控制器
│   ├── layout_controller.dart         # 佈局控制器
│   └── analytics_controller.dart      # 分析控制器
└── presentation/
    ├── pages/
    │   ├── my_arsenal_page.dart       # 主頁面
    │   ├── add_ball_page.dart         # 新增球具
    │   ├── layout_manager_page.dart   # 佈局管理
    │   └── analytics_page.dart        # 分析頁面
    └── widgets/
        ├── arsenal_ball_card.dart     # 球具卡片
        ├── bag_layout_widget.dart     # 佈局視圖
        ├── analytics_charts.dart      # 分析圖表
        └── category_selector.dart     # 分類選擇器
```

### 第三方套件需求
```yaml
dependencies:
  # 圖表分析
  fl_chart: ^0.68.0              # 圖表庫
  
  # 圖片處理
  image_picker: ^1.0.4           # 圖片選擇
  cached_network_image: ^3.3.0   # 圖片快取
  
  # 拖拽功能
  flutter_reorderable_list: ^1.3.1
  
  # 動畫效果
  animations: ^2.0.8
  
  # 數據處理
  collection: ^1.17.2
```

---

## 📊 階段性開發計劃

### 🚀 第一階段：核心功能 (4-5 週)
**目標:** 建立基礎的球具管理功能

#### Week 1-2: 數據層建設
- [ ] **任務 1.1:** 設計並實作 Arsenal 數據模型
  - ArsenalBall, BagCategory, BagLayout 模型
  - Freezed 代碼生成設定
  - 數據庫 Schema 設計

- [ ] **任務 1.2:** Repository 層實作
  - ArsenalRepository 抽象介面
  - SupabaseArsenalRepository 實作
  - 基礎 CRUD 操作

- [ ] **任務 1.3:** Riverpod Controller 設定
  - ArsenalController 基礎架構
  - 狀態管理設計
  - 錯誤處理機制

#### Week 3-4: UI 基礎建設
- [ ] **任務 1.4:** 主頁面架構
  - MyArsenalPage 基礎 UI
  - 導航結構
  - 響應式布局

- [ ] **任務 1.5:** 球具卡片元件
  - ArsenalBallCard 設計
  - Grid View 實作
  - 品牌色彩系統整合

- [ ] **任務 1.6:** 從 Library 加入功能
  - Ball Library 整合
  - 加入球具 UI 流程
  - 成功回饋機制

#### Week 5: 分類系統
- [ ] **任務 1.7:** 球袋分類功能
  - 預設分類建立
  - 自定義分類 CRUD
  - 分類切換 UI

**第一階段交付物:**
- ✅ 基礎的球具管理系統
- ✅ 從 Ball Library 加入球具
- ✅ 球袋分類管理
- ✅ Grid View 顯示

---

### 🎯 第二階段：進階功能 (3-4 週)

#### Week 6-7: 自定義新增功能
- [ ] **任務 2.1:** 自定義球具新增表單
  - 完整的球具資訊表單
  - 表單驗證機制
  - 圖片上傳功能

- [ ] **任務 2.2:** 同球多次加入
  - 球具實例管理
  - 備註和標記系統
  - 實例編號自動生成

#### Week 8: List View 實作
- [ ] **任務 2.3:** Arsenal 專用 List View
  - 差異化設計實作
  - 詳細資訊顯示
  - 操作功能整合

#### Week 9: 佈局管理基礎
- [ ] **任務 2.4:** 佈局系統基礎
  - BagLayout 模型完善
  - 位置標記系統
  - 基礎佈局 UI

**第二階段交付物:**
- ✅ 自定義球具新增
- ✅ 同球多次加入功能  
- ✅ List View 實作
- ✅ 基礎佈局管理

---

### 📐 第三階段：佈局管理 (2-3 週)

#### Week 10-11: 進階佈局功能
- [ ] **任務 3.1:** 視覺化佈局介面
  - 拖拽式佈局調整
  - 多種球袋規格支援
  - 位置衝突檢測

- [ ] **任務 3.2:** 佈局模板系統
  - 模板保存和載入
  - 預設佈局模板
  - 模板分享機制

#### Week 12: 佈局管理完善
- [ ] **任務 3.3:** 佈局管理頁面
  - 專用佈局管理介面
  - 批量位置調整
  - 佈局預覽功能

**第三階段交付物:**
- ✅ 完整的佈局管理系統
- ✅ 拖拽式介面
- ✅ 佈局模板功能

---

### 📊 第四階段：分析系統 (3-4 週)

#### Week 13-14: 基礎分析功能
- [ ] **任務 4.1:** 數據分析服務
  - AnalyticsService 實作
  - 基礎統計計算
  - 數據聚合邏輯

- [ ] **任務 4.2:** 十字象限圖
  - RG vs Diff 散點圖
  - 互動式圖表
  - 象限說明系統

#### Week 15-16: 進階分析
- [ ] **任務 4.3:** 分佈分析圖表
  - 直方圖實作
  - 圓餅圖實作
  - 時間軸分析

- [ ] **任務 4.4:** 分析報告頁面
  - 完整的分析介面
  - 報告匯出功能
  - 分析建議系統

**第四階段交付物:**
- ✅ 完整的分析系統
- ✅ 多種圖表類型
- ✅ 分析報告功能

---

### 🎨 第五階段：UI/UX 優化 (2 週)

#### Week 17-18: 視覺優化
- [ ] **任務 5.1:** 動畫和過渡效果
  - 頁面切換動畫
  - 卡片互動動畫
  - 載入狀態動畫

- [ ] **任務 5.2:** 響應式設計完善
  - 平板版本適配
  - 桌面版本優化
  - 不同螢幕尺寸適配

- [ ] **任務 5.3:** 可用性測試和優化
  - 使用者體驗測試
  - 效能優化
  - 錯誤處理改善

**第五階段交付物:**
- ✅ 流暢的使用者體驗
- ✅ 完善的響應式設計
- ✅ 高品質的視覺效果

---

## 🎯 成功指標 (KPIs)

### 功能完整性指標
- [ ] **100%** 核心功能實作完成
- [ ] **95%+** 自動化測試覆蓋率
- [ ] **零** 嚴重 Bug
- [ ] **完整** API 文件

### 使用者體驗指標  
- [ ] **<2秒** 頁面載入時間
- [ ] **>4.5/5** 使用者滿意度評分
- [ ] **<0.1%** 崩潰率
- [ ] **100%** 響應式設計支援

### 技術品質指標
- [ ] **A 級** 架構規範符合度
- [ ] **完整** 錯誤處理機制
- [ ] **高效** 數據快取策略
- [ ] **安全** 數據存取控制

---

## ⚠️ 風險評估與緩解策略

### 高風險項目

#### 🔴 數據遷移風險
**風險:** 現有 Arsenal 數據與新系統不相容
**影響:** 使用者數據丟失，功能無法正常使用
**緩解策略:**
- 設計向後相容的數據結構
- 實作數據遷移腳本
- 建立完整的備份機制
- 階段性遷移測試

#### 🔴 複雜度管理風險  
**風險:** 功能過於複雜，開發時程延誤
**影響:** 交付延期，品質下降
**緩解策略:**
- 嚴格按階段開發
- 定期功能檢視和簡化
- MVP 思維，優先核心功能
- 充分的原型驗證

### 中風險項目

#### 🟡 效能風險
**風險:** 大量球具數據影響應用效能
**緩解策略:**
- 實作分頁載入
- 建立適當的快取機制
- 數據庫查詢優化
- 定期效能測試

#### 🟡 圖表分析複雜度
**風險:** 分析功能實作複雜度超出預期
**緩解策略:**
- 選用成熟的圖表庫
- 分階段實作分析功能
- 專注核心分析需求
- 建立分析數據快取

---

## 📝 附錄

### A. 競品分析參考
- **PBA League App** - 專業保齡球聯盟應用
- **My Bowling 3D+** - 保齡球計分和統計
- **Sport Ngin** - 運動數據分析平台

### B. 技術參考資源
- [FL Chart Documentation](https://github.com/imaNNeo/fl_chart)
- [Flutter Animations Guide](https://docs.flutter.dev/development/ui/animations)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/reading)

### C. 設計參考
- Material Design 3 運動應用設計規範
- iOS 健康應用的數據視覺化設計
- Nike Run Club 的個人數據展示

---

**文件維護者:** 開發團隊  
**最後更新:** 2025-08-01  
**下次檢視:** 開始開發前進行需求最終確認