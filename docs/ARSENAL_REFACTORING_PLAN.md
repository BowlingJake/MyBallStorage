# Arsenal 功能重構計畫

**文件版本:** 1.0  
**建立日期:** 2025-01-11  
**分析範圍:** My Arsenal Page 及相關組件

## 1. 現況分析摘要

### 1.1 檔案規模分析
經過程式碼行數統計，發現以下問題：
- **my_arsenal_page.dart**: 1002 行 - 嚴重超標
- **new_arsenal_controller.dart**: 610 行 - 偏長但可接受
- **arsenal_actions.dart**: 431 行 - 適中

### 1.2 架構遵循度評估
根據 CLAUDE.md 和 TECHNICAL_SPEC.md 的規範檢查：

#### ✅ 已遵循的良好實踐
1. **三層架構基本結構** - 有區分 data/logic/presentation 層
2. **Riverpod 使用** - 正確使用 @riverpod 註解和程式碼生成
3. **Freezed 模型** - 所有狀態類別使用 Freezed 保證不可變性
4. **Repository 模式** - 所有 Supabase 操作透過 Repository 層
5. **共用元件使用** - 正確使用 AppStandardButton、TopNotification 等

#### ❌ 需要改善的問題
1. **表現層職責過重** - my_arsenal_page.dart 包含過多業務邏輯
2. **程式碼過長** - 單一檔案超過 1000 行，違反可維護性原則
3. **方法過於龐大** - 部分方法超過 50 行，責任不明確
4. **狀態管理分散** - 部分狀態邏輯直接在 UI 層處理
5. **重複程式碼** - 多處類似的錯誤處理和通知邏輯

## 2. 具體問題識別

### 2.1 my_arsenal_page.dart 問題分析

#### 問題 1: 檔案過長 (1002 行)
- **問題描述**: 單一檔案包含過多功能，違反單一責任原則
- **影響**: 難以維護、測試複雜、團隊協作困難
- **位置**: 整個檔案

#### 問題 2: 業務邏輯混雜在 UI 層
- **問題描述**: 表現層包含過多業務邏輯處理
- **具體位置**:
  - `_addSelectedBallsToArsenal()` (584-646 行) - 應移至 logic 層
  - `_confirmRemoveSelected()` (689-713 行) - 業務邏輯處理
  - `_showTieredRemovalDialog()` (715-739 行) - 複雜業務流程控制
  - `_performBagOnlyRemoval()` (743-772 行) - 應由 controller 處理
  - `_performCompleteRemoval()` (774-797 行) - 應由 controller 處理

#### 問題 3: 重複的錯誤處理模式
- **問題描述**: 多處相同的 try-catch 和通知邏輯
- **位置**: 
  - 586-645 行 (addBalls)
  - 744-797 行 (removal methods)
  - 880-953 行 (addToSpecificBag)

#### 問題 4: 狀態管理複雜度過高
- **問題描述**: UI 層直接操作過多狀態變更
- **位置**: 
  - `_initializeTabController()` (102-138 行) - 複雜的 tab 狀態管理
  - `_checkForSelectionMode()` (78-80 行) - 多餘的狀態檢查

#### 問題 5: 方法職責不明確
- **問題描述**: 單一方法處理多種責任
- **例子**:
  - `build()` 方法 (168-277 行) - 過於複雜的建構邏輯
  - `_buildBottomActionBar()` (436-513 行) - 混合邏輯判斷和 UI 建構

### 2.2 架構層級問題

#### 問題 1: Controller 職責邊界模糊
- **new_arsenal_controller.dart** 包含過多具體實作細節
- 缺乏適當的服務層來處理複雜業務流程

#### 問題 2: Actions 檔案定位不明
- **arsenal_actions.dart** 位於 presentation 層但處理業務邏輯
- 應該屬於 logic 層或重新組織

## 3. 重構計畫

### 3.1 第一階段：檔案拆分 (優先級：高)

#### 3.1.1 拆分 my_arsenal_page.dart
```
lib/features/arsenal/presentation/pages/
├── my_arsenal_page.dart (保留主頁面，簡化至 300-400 行)
├── components/
│   ├── arsenal_header.dart (AppBar 和搜尋功能)
│   ├── arsenal_tabs_section.dart (標籤頁區域)
│   ├── arsenal_management_section.dart (管理按鈕區域)
│   ├── arsenal_content_section.dart (內容顯示區域)
│   └── arsenal_bottom_actions.dart (底部操作列)
└── handlers/
    ├── arsenal_bag_handler.dart (球袋相關操作)
    ├── arsenal_selection_handler.dart (選擇模式處理)
    └── arsenal_dialog_handler.dart (對話框處理)
```

#### 3.1.2 重組業務邏輯
```
lib/features/arsenal/logic/
├── new_arsenal_controller.dart (保留核心狀態管理)
├── services/
│   ├── arsenal_bag_service.dart (球袋操作服務)
│   ├── arsenal_selection_service.dart (選擇模式服務)
│   └── arsenal_dialog_service.dart (對話框業務邏輯)
└── use_cases/
    ├── add_balls_use_case.dart (加球用例)
    ├── remove_balls_use_case.dart (移除球用例)
    └── move_balls_use_case.dart (移動球用例)
```

### 3.2 第二階段：責任分離 (優先級：高)

#### 3.2.1 移除 UI 層的業務邏輯
- 將所有 `_addSelectedBallsToArsenal` 類型方法移至 service 層
- 將錯誤處理統一化，建立 `ErrorHandlingMixin`
- 將通知邏輯抽象為 `NotificationService`

#### 3.2.2 簡化狀態管理
- 建立專門的 `ArsenalTabsController` 管理標籤狀態
- 建立 `ArsenalSelectionController` 管理選擇模式
- 減少 UI 層直接的狀態操作

### 3.3 第三階段：程式碼重用 (優先級：中)

#### 3.3.1 建立共用 Mixins
```dart
// lib/features/arsenal/presentation/mixins/
mixin ArsenalErrorHandlingMixin {
  void handleArsenalError(BuildContext context, String operation, dynamic error);
}

mixin ArsenalNotificationMixin {
  void showSuccessMessage(BuildContext context, String message);
  void showErrorMessage(BuildContext context, String message);
}
```

#### 3.3.2 統一對話框管理
- 建立 `ArsenalDialogManager` 統一管理所有對話框
- 標準化對話框的回調處理模式

### 3.4 第四階段：效能優化 (優先級：中)

#### 3.4.1 狀態管理優化
- 將大型狀態拆分為多個小型 provider
- 使用 `family` provider 針對特定球袋/球具
- 實作適當的狀態快取機制

#### 3.4.2 UI 渲染優化
- 使用 `const` 建構子減少重建
- 將列表項目改為 `StatelessWidget`
- 適當使用 `AutomaticKeepAliveClientMixin`

## 4. 實施優先級與時程

### 第一週：緊急重構 (必須)
1. **拆分 my_arsenal_page.dart** - 立即執行
   - 建立 components 資料夾和基本元件
   - 將主頁面簡化至 400 行以下
   - 確保功能完整性

### 第二週：業務邏輯重組 (高優先級)
2. **移動業務邏輯至 logic 層**
   - 建立 service 層
   - 移動所有業務方法
   - 更新依賴注入

### 第三週：程式碼品質提升 (中優先級)
3. **建立共用元件和 Mixins**
   - 統一錯誤處理
   - 建立通知服務
   - 標準化對話框管理

### 第四週：效能優化 (低優先級)
4. **狀態管理和渲染優化**
   - 拆分 provider
   - UI 效能調校
   - 測試和驗證

## 5. 風險評估與應對

### 5.1 高風險項目
1. **功能回歸** - 重構過程可能破壞既有功能
   - **應對**: 建立完整的測試套件
   - **應對**: 分階段重構，確保每階段功能完整

2. **依賴關係複雜** - 多個元件間的依賴可能導致重構困難
   - **應對**: 先建立介面契約，再逐步實作
   - **應對**: 使用 dependency injection 降低耦合

### 5.2 中風險項目
1. **開發時程延遲** - 重構工作量可能超出預期
   - **應對**: 採用增量重構，優先處理最嚴重問題
   - **應對**: 保持現有 API 相容性

## 6. 成功指標

### 6.1 量化指標
- my_arsenal_page.dart 行數 < 400 行
- 單一方法行數 < 30 行
- 業務邏輯方法 100% 移至 logic 層
- UI 元件複用率 > 80%

### 6.2 質化指標
- 程式碼可讀性顯著提升
- 新功能開發效率提高
- bug 發生率降低
- 團隊開發體驗改善

## 7. 總結

My Arsenal 頁面目前面臨嚴重的架構問題，主要體現在：
1. **檔案過長** (1002 行) 影響可維護性
2. **業務邏輯混雜** 在表現層，違反分層架構
3. **重複程式碼** 增加維護成本
4. **責任邊界模糊** 影響程式碼品質

建議採用四階段重構計畫，優先解決最嚴重的架構問題，然後逐步改善程式碼品質和效能。重構完成後，預期能顯著提升程式碼的可維護性、可測試性和開發效率。