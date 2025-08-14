# My Arsenal 模組程式碼審查報告

版本: 2025-08-13  
範圍: `features/arsenal/presentation/pages/my_arsenal_page.dart` 與其關聯的 controllers/services/widgets、對話框與共用元件

## 一、檔案與關聯盤點（主要）
- Pages
  - `lib/features/arsenal/presentation/pages/my_arsenal_page.dart`
  - `lib/features/arsenal/presentation/pages/components/arsenal_tabs_section.dart`
  - `lib/features/arsenal/presentation/pages/components/arsenal_management_section.dart`
  - `lib/features/arsenal/presentation/pages/components/arsenal_content_section.dart`
- AppBar/Tabs/Lists/Grid
  - `lib/features/arsenal/presentation/widgets/appbar/arsenal_app_bar.dart`
  - `lib/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart`
  - `lib/features/arsenal/presentation/widgets/tabs/arsenal_tabs.dart`
  - `lib/features/arsenal/presentation/widgets/lists/arsenal_list_view.dart`
  - `lib/features/arsenal/presentation/widgets/lists/arsenal_grid_view.dart`
- Logic/Controller/Service
  - `lib/features/arsenal/logic/new_arsenal_controller.dart`（@freezed + @riverpod）
  - `lib/features/arsenal/logic/services/arsenal_ui_service.dart`（@riverpod）
- Dialogs（部分）
  - `lib/features/arsenal/presentation/widgets/dialogs/move_target_bag_dialog.dart`
  - `lib/shared/widgets/common/dialogs/bag_selection_dialog.dart`
- 其他整合
  - `lib/shared/widgets/common/navigation/modern_bottom_navigation.dart`
  - `lib/shared/widgets/common/professional_dark_background.dart`
  - `lib/features/auth/logic/auth_controller.dart`
  - `lib/features/user/logic/user_profile_controller.dart`

（註）路由與全域 Provider 設定位於 `lib/routing/*`, `lib/shared/providers/*`（本輪針對 My Arsenal 直接關聯部分為主）。

## 二、與 TECHNICAL_SPEC 對照
- 架構分層
  - Presentation 僅負責 UI 與事件委派；邏輯集中在 Riverpod Notifier/Service 與 Repository 層，符合 3.2 分層職責。
- 狀態管理
  - 全面採用 Riverpod + `@riverpod` codegen，controller 與 service 清晰，符合規範。
- 資料模型
  - `NewArsenalState` 使用 Freezed，不可變、拷貝語意完整，符合規範與你的偏好（模型不可變）
- 路由管理
  - 頁面導覽採用 `GoRouter` 的 `context.go(...)`，符合專案導覽慣例與你的偏好 [[memory:2284679]].
- 共用元件與設計系統
  - 行動按鈕與對話框使用 `AppStandardButton` 與 `ArsenalDialog` 等統一樣式，符合文件建議。

## 三、全域設定與一致性
- Provider 來源以 `shared/providers/app_providers.dart` 注入（Supabase 等），未見 UI 直接持有 Client，符合資料層抽象。
- 背景與導航
  - `ProfessionalDarkBackground` 包覆頁面，`ModernBottomNavigation` 一致管理底部導覽。
  - 建議確認 `assets/images/Sport_Tech_Background.webp` 已在 `pubspec.yaml` 宣告。

## 四、程式品質觀察
- 可維護性/可測試性
  - 邏輯集中在 `NewArsenalController` 與 `ArsenalUIService`，UI 輕量，利於測試與重構。
- 效能
  - `filteredArsenalInstancesProvider` 在資料量大時使用背景 isolate 計算，良好。
- 錯誤處理與 UX
  - Controller 以 try/catch 處理，UI 顯示錯誤狀態與 retry；部分 retry 行為可再優化（見改進）。
- Lints
  - 本輪檢視檔案未見 linter 錯誤。

## 五、可改進項目（優先序）
1) ArsenalContentSection 錯誤重試流程
- 現況：
  - error 狀態的 onRetry 使用 `ref.refresh(newArsenalControllerProvider)`，可能只會重建預設 state，未必重新載入資料。
- 改進：
  - 直接取得 `userId` 後呼叫 `initialize(userId)` 或新增 `refreshWithAuth()` 包裝：
  - 範例（概念）：
    ```dart
    final auth = ref.read(authControllerProvider);
    final userId = auth.value?.id;
    if (userId != null) {
      await ref.read(newArsenalControllerProvider.notifier).initialize(userId);
    }
    ```

2) 去除多餘的 Null 合併運算
- 現況：`final int sourceBagNumber = state.selectedBagNumber ?? 1;`
- 觀察：`selectedBagNumber` 為非空 `int`，`?? 1` 冗餘。
- 改進：直接使用 `state.selectedBagNumber`。

3) 避免重複邏輯（單一真相來源）
- 現況：
  - `ArsenalManagementSection._getSelectedBagDisplayText` 與 `ArsenalUIService.getSelectedBagDisplayText` 重疊。
- 改進：
  - 由 UIService 提供統一方法，`ManagementSection` 以回呼直接呼叫 Service，減少重複。

4) 文案/i18n 與常數整合
- 現況：多處使用硬編碼英文字串（e.g., 'My Arsenal', 'Search balls...'）。
- 改進：移至 `shared/app_strings.dart` 或國際化方案，方便多語系維護。

5) Tab 選擇鎖定與提示
- 現況：`selectionMode` 下阻止切換 Tab，但僅 silently revert。
- 改進：提供視覺提示或訊息（SnackBar/TopNotification），提高可用性。

6) 對話框一致性
- 現況：對話框多處採自定組裝（如 `Dialog + Container`）。
- 改進：盡量透過 `ArsenalDialog.show<T>` 或統一封裝，維持樣式與交互一致。

7) 測試覆蓋
- 針對 `NewArsenalController` 的關鍵用例（移動、移除、排序、過濾、搜尋）補齊單元/整合測試。

8) 小型整潔化
- 使用 `const`（可時）與更明確的型別註記，減少 rebuild 與提升可讀性。

## 六、評分（10 分制）
- 架構與分層：9.0
- 狀態管理與資料流：9.0
- 程式風格與一致性：8.5
- 錯誤處理與 UX：8.0
- 效能與可擴充性：8.5
- 測試覆蓋與可測性：7.5
- 整體：8.6/10

## 七、建議的下一步行動（可分支）
- feat/arsenal-retry: 修正 `onRetry` 為以 userId 重新初始化的流程；UIService 增補 `refreshWithAuth()`。
- refactor/arsenal-display-text: 移除 `ArsenalManagementSection` 內部顯示字串邏輯，改用 UIService 單一來源。
- chore/nullish-cleanup: 移除 `?? 1` 等冗餘運算，補齊 `const`。
- i18n/strings-extract: 抽取文字常數至 `shared/app_strings.dart` 或 i18n。
- test/arsenal-controller: 針對移動/移除/過濾/排序/搜尋新增測試。

---
本報告依據目前程式碼快照與 `docs/TECHNICAL_SPEC.md` 進行審視；後續若有結構性調整，建議更新此報告。

