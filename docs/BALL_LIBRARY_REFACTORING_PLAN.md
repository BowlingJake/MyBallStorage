# Ball Library 功能重構計畫

**文件版本:** 1.0  
**建立日期:** 2025-01-11  
**分析範圍:** Ball Library Page 及相關組件

## 1. 現況分析摘要

### 1.1 檔案規模分析
經過程式碼行數統計，發現以下狀況：
- **ball_library_page.dart**: 763 行 - 偏長但尚可接受 (相比 Arsenal 的 1002 行已好很多)
- **ball_library_controller.dart**: 368 行 - 適中
- **supabase_ball_repository.dart**: 433 行 - 適中

### 1.2 架構遵循度評估
根據 CLAUDE.md 和 TECHNICAL_SPEC.md 的規範檢查：

#### ✅ 已遵循的良好實踐
1. **三層架構完整** - 明確的 data/logic/presentation 分層
2. **Repository 模式** - 所有資料存取透過 Repository 介面
3. **Riverpod 使用** - 正確使用 @riverpod 註解和 AsyncNotifier
4. **Freezed 模型** - 所有狀態和模型類別使用 Freezed
5. **錯誤處理** - 適當的 try-catch 和錯誤顯示
6. **共用元件使用** - 正確使用 AppStandardButton、TopNotification 等
7. **業務邏輯封裝** - `getBallsForComparison()` 等方法在 controller 層

#### ⚠️ 潛在改善點
1. **UI 層業務邏輯** - 部分業務處理仍在 presentation 層
2. **方法責任過重** - 某些方法處理多種職責
3. **重複的 UI 建構邏輯** - 排序對話框等可抽出為獨立元件
4. **狀態管理複雜度** - 多種選擇模式的狀態切換邏輯

#### ❌ 需要改善的問題
1. **表現層的業務邏輯混雜** - `_addSelectedBallsToArsenal()` 應移至 logic 層
2. **直接的跨模組依賴** - Ball Library 直接呼叫 Arsenal Controller
3. **UI 建構邏輯複雜** - 某些 UI 建構方法過於複雜

## 2. 具體問題識別

### 2.1 ball_library_page.dart 問題分析

#### 問題 1: 跨模組業務邏輯處理 (553-616 行)
- **問題描述**: `_addSelectedBallsToArsenal()` 方法在 Ball Library 中直接操作 Arsenal Controller
- **架構違反**: 跨模組直接依賴，違反分層架構原則
- **影響**: 模組耦合度過高，難以獨立測試和維護

#### 問題 2: 複雜的 UI 建構邏輯
- **問題描述**: `_buildSortDialog()` (273-377 行) 過於複雜，包含大量的 UI 結構
- **影響**: 降低程式碼可讀性，難以重用
- **位置**: 
  - `_buildSortDialog()` (273-377 行) - 應抽出為獨立元件
  - `_buildSortOption()` (379-426 行) - 可與對話框一起重構

#### 問題 3: 選擇模式狀態管理複雜
- **問題描述**: 比較模式和加入 Arsenal 模式的狀態切換邏輯分散
- **位置**:
  - `_toggleComparisonMode()` (55-63 行)
  - `_toggleAddToArsenalMode()` (65-73 行)  
  - `_exitSelectionMode()` (81-87 行)
  - `_resetSelection()` (75-79 行)

#### 問題 4: 業務邏輯與 UI 邏輯混雜
- **問題描述**: 表現層包含業務決策邏輯
- **具體例子**:
  - `_toggleBallSelection()` (89-105 行) - 包含選擇限制的業務規則
  - `_showComparison()` (107-140 行) - 包含資料載入和錯誤處理業務邏輯

### 2.2 架構層級問題

#### 問題 1: 模組間直接依賴
- **Ball Library** 直接依賴 **Arsenal Controller**
- 違反了模組獨立性原則
- 應透過事件或服務層進行通訊

#### 問題 2: 業務流程控制分散
- 加入 Arsenal 的完整流程分散在多個方法中
- 缺乏統一的業務流程管理

## 3. 重構計畫

### 3.1 第一階段：業務邏輯重組 (優先級：高)

#### 3.1.1 建立專門的 Use Case 層
```
lib/features/ball_library/logic/
├── ball_library_controller.dart (保留核心狀態管理)
├── use_cases/
│   ├── ball_comparison_use_case.dart (球具比較用例)
│   ├── ball_selection_use_case.dart (球具選擇用例)
│   └── add_balls_to_arsenal_use_case.dart (加入 Arsenal 用例)
└── services/
    ├── ball_selection_service.dart (選擇模式管理)
    └── cross_module_communication_service.dart (跨模組通訊)
```

#### 3.1.2 移除跨模組直接依賴
- 建立 `CrossModuleCommunicationService` 處理與 Arsenal 的互動
- 使用事件驅動模式取代直接呼叫
- 建立 `AddBallsToArsenalUseCase` 封裝完整業務流程

### 3.2 第二階段：UI 元件抽離 (優先級：高)

#### 3.2.1 排序對話框重構
```
lib/features/ball_library/presentation/widgets/dialogs/
├── ball_sort_dialog.dart (排序對話框)
├── ball_sort_option_item.dart (排序選項項目)
└── sort_dialog_controller.dart (對話框邏輯控制)
```

#### 3.2.2 選擇模式 UI 元件化
```
lib/features/ball_library/presentation/widgets/selection/
├── ball_selection_info_bar.dart (選擇資訊列)
├── ball_selection_action_buttons.dart (操作按鈕)
└── ball_selection_action_tag.dart (動作標籤)
```

### 3.3 第三階段：狀態管理優化 (優先級：中)

#### 3.3.1 建立專門的選擇模式 Controller
```dart
// lib/features/ball_library/logic/ball_selection_controller.dart
@riverpod
class BallSelectionController extends _$BallSelectionController {
  @override
  BallSelectionState build() => const BallSelectionState();
  
  void toggleComparisonMode() { /* 邏輯處理 */ }
  void toggleAddToArsenalMode() { /* 邏輯處理 */ }
  void selectBall(int ballId) { /* 選擇邏輯 */ }
  void resetSelection() { /* 重設邏輯 */ }
  void exitSelectionMode() { /* 退出邏輯 */ }
}

@freezed
class BallSelectionState with _$BallSelectionState {
  const factory BallSelectionState({
    @Default(BallSelectionMode.none) BallSelectionMode mode,
    @Default({}) Set<int> selectedBallIds,
  }) = _BallSelectionState;
}

enum BallSelectionMode { none, comparison, addToArsenal }
```

#### 3.3.2 簡化主頁面狀態管理
- 將選擇模式相關狀態移至 `BallSelectionController`
- 主頁面僅負責 UI 渲染和事件分派

### 3.4 第四階段：程式碼品質提升 (優先級：中)

#### 3.4.1 建立共用 Mixins
```dart
// lib/features/ball_library/presentation/mixins/
mixin BallSelectionMixin {
  void handleBallSelection(int ballId);
  bool canSelectBall(int ballId, BallSelectionMode mode);
}

mixin BallLibraryNotificationMixin {
  void showBallActionSuccess(BuildContext context, String action, int count);
  void showBallActionError(BuildContext context, String action, String error);
}
```

#### 3.4.2 統一業務流程介面
```dart
// lib/features/ball_library/logic/interfaces/
abstract class BallLibraryUseCase<T> {
  Future<T> execute();
}

class AddBallsToArsenalUseCase implements BallLibraryUseCase<void> {
  final List<int> ballIds;
  final String userId;
  
  // 封裝完整的加入 Arsenal 流程
  @override
  Future<void> execute() async { /* 實作 */ }
}
```

## 4. 重構優勢對比

### 4.1 與 Arsenal 頁面相比的優勢
1. **程式碼規模合理** - 763 行相對於 Arsenal 的 1002 行
2. **架構遵循度較高** - 基本的三層分離已確立
3. **業務邏輯相對集中** - 大部分邏輯在 controller 層
4. **錯誤處理完整** - 有適當的錯誤處理機制

### 4.2 重構後預期改善
1. **模組獨立性** - 消除跨模組直接依賴
2. **程式碼重用性** - 抽離的 UI 元件可重用
3. **測試便利性** - Use Case 層便於單元測試
4. **維護容易度** - 職責明確，修改影響範圍小

## 5. 實施優先級與時程

### 第一週：業務邏輯重組 (高優先級)
1. **建立 Use Case 層**
   - 建立 `AddBallsToArsenalUseCase`
   - 建立跨模組通訊服務
   - 移除直接的模組依賴

### 第二週：UI 元件抽離 (高優先級)
2. **排序對話框重構**
   - 抽出 `BallSortDialog` 元件
   - 建立可重用的排序選項元件
   - 簡化主頁面程式碼

### 第三週：狀態管理優化 (中優先級)
3. **建立選擇模式 Controller**
   - 抽離選擇模式狀態管理
   - 簡化主頁面狀態邏輯
   - 提升狀態管理的清晰度

### 第四週：程式碼品質提升 (低優先級)
4. **建立共用 Mixins 和介面**
   - 統一業務流程處理
   - 建立可重用的功能模組
   - 完善文件和測試

## 6. 風險評估與應對

### 6.1 低風險項目
1. **UI 元件抽離** - 不影響業務邏輯，風險較低
   - **應對**: 保持原有介面不變，漸進式重構

2. **排序對話框重構** - 功能單純，重構風險低
   - **應對**: 建立新元件後再替換舊實作

### 6.2 中風險項目
1. **跨模組依賴解除** - 可能影響 Arsenal 加入功能
   - **應對**: 建立事件系統，確保功能完整性
   - **應對**: 完整的整合測試驗證

2. **狀態管理重構** - 可能影響選擇模式功能
   - **應對**: 分階段遷移，保持向後相容

## 7. 成功指標

### 7.1 量化指標
- 主頁面行數減少至 < 500 行
- 跨模組直接依賴數量 = 0
- UI 元件重用率 > 70%
- 業務邏輯方法 100% 在 logic 層

### 7.2 質化指標
- 模組獨立性顯著提升
- 程式碼可讀性和維護性改善
- 單元測試覆蓋率提高
- 新功能開發效率提升

## 8. 總結

Ball Library 頁面相比 Arsenal 頁面在架構上已有較好的基礎，主要問題集中在：

### 🎯 核心問題
1. **跨模組直接依賴** - Ball Library 直接操作 Arsenal Controller
2. **業務邏輯混雜** - 部分業務邏輯仍在表現層
3. **UI 建構邏輯複雜** - 排序對話框等應抽出為獨立元件
4. **選擇模式管理分散** - 缺乏統一的狀態管理

### 📈 重構重點
1. **模組解耦** - 建立跨模組通訊服務
2. **業務邏輯上移** - 建立 Use Case 層
3. **UI 元件化** - 抽離可重用的 UI 元件
4. **狀態管理優化** - 專門的選擇模式 Controller

### ✨ 預期效益
相比 Arsenal 頁面，Ball Library 的重構難度較低，但收益同樣顯著：
- 提升模組獨立性和可測試性
- 改善程式碼結構和可維護性  
- 建立可重用的元件庫
- 為其他類似功能提供重構範本

重構完成後，Ball Library 將成為專案中架構最佳實踐的典範模組。