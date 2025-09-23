## TRAINING 模組重構計畫（Phase 1-3）

更新日期：2025-09-23

### 參考規範
- 技術指南：`docs/TECHNICAL_SPEC.md`
- 設計與互動原則依照技術指南；若後續提供 `CLAUDE.md`，將再同步合併差異。

---

### 1) 範圍與現況總覽
- 路由
  - `/training` → `MyTrainingPage`
  - `/training/detail/:sessionId` → `TrainingDetailPage`
  - `/training/history` → `TrainingHistorySlidingPage`（路由存在）
  - `/training/create/*`, `/training/edit/*` 建立/編輯流程

- 主要頁面與元件（節選）
  - `features/training/presentation/pages/my_training_page.dart`：總覽、最近訓練、啟動新訓練
  - `features/training/presentation/pages/training_detail_page.dart`：大型頁面，含分頁 Games/Equipment/Statistics、互動輸入流程、資料讀寫
  - `features/training/presentation/widgets/scoring_board.dart`：受控計分板
  - `shared/widgets/bowling/bowling_scorecard_widget.dart`：實際 10 格計分 UI
  - `shared/widgets/bowling/pin_selection_dialog.dart`、`pin_selection_widget.dart`：選瓶
  - `features/training/presentation/widgets/components/enhanced_training_equipment.dart`、`enhanced_training_stats.dart`

- 資料與邏輯
  - 模型：`features/training/models/training_record.dart`（`TrainingDaySummary`, `GameRecord` 等）
  - 轉換：`features/training/data/converters/*`（`GameDataConverter`, `TrainingDataConverter`）
  - 計分引擎：`features/training/logic/scoring/engine/scoring_engine.dart`、`pin_state_policy.dart`、`scoring_strategy.dart`
  - 存取：`repositories/games_repository.dart`
  - 注意：`TrainingDataService` 在 `services/` 與 `shared/services/` 各有一份，需整併

---

### 2) 主要問題（痛點）
- `TrainingDetailPage` 超大（>1,200 行），UI 與互動/資料處理混雜，難以測試與維護。
- 本地 UI 狀態（例如 `_addedGames`, `_isEditMode`）與持久化行為耦合在 Widget 內；更新 Supabase 的作業散落在多處。
- 轉換器/服務重複（`TrainingDataService` 兩份），命名與責任邊界不清。
- 通知方式不一致，部分地方仍使用 `SnackBar`（技術指南要求 `TopNotification`）。
- Magic number 與樣式分散（尺寸、邏輯常數），缺乏集中配置。

---

### 3) 重構目標與原則
- 關注點分離：UI（Widget）只負責呈現與事件；邏輯進入 Riverpod Controller；資料經 Repository。
- 不破壞既有資料結構與 API；以相容為先，漸進替換。
- 完整遵循 `docs/TECHNICAL_SPEC.md`：
  - Provider 一律 `@riverpod` 產生
  - 通知一律 `TopNotification`
  - 標籤統一 `OvalTag`
- 模型不可變（Freezed/`copyWith`），易於測試。
- 專案目錄 Feature-Driven，跨層依賴自上而下。

---

### 4) 目標架構（高階）
```
features/training/
  data/
    repositories/
      games_repository.dart            # 現有，補齊介面/錯誤型別
    converters/
      game_data_converter.dart
      training_data_converter.dart
  logic/
    controllers/
      training_detail_controller.dart  # 新：詳情頁狀態與行為（AsyncNotifier）
      training_list_controller.dart    # 新：列表/歷史/摘要
    scoring/
      engine/...                       # 既有
  presentation/
    pages/
      my_training_page.dart
      training_detail_page.dart        # 精簡為展示/Dispatch
      training_history_page.dart       # 取代 sliding page 名稱不一致
    widgets/
      scoring_board.dart
      components/...                   # 拆分出的純 UI 元件
shared/
  widgets/common/notifications/top_notification.dart
```

狀態流：UI → Controller(action) → Repository → Supabase → Controller(state) → UI

---

### 5) 具體重構項目
1. Controller 化（Phase 1）
   - 新增 `TrainingDetailController`（`@riverpod`）：
     - State：`trainingSession`、`games`（原 `_GameUIState` 改為 Freezed 模型）、`isEditMode`、`showPinVisualization`、`isFullscreen`
     - 行為：`loadGames(sessionId)`、`addEmptyGame()`、`deleteLastGame()`、`onFrameTapped()`、`inputNextRoll()`、`inputCompleteFrame()`、`persistGame()`（debounce）
     - 例外轉 `TopNotification`
   - `TrainingDetailPage` 僅渲染與 `ref.watch/ref.read` 派發

2. Data 層整併（Phase 1）
   - 合併 `services/training_data_service.dart` 與 `shared/services/training_data_service.dart` 至 `features/training/data/`（保留對外 API 相容）
   - 明確化 `GamesRepository` 介面與錯誤型別；所有存取統一經 Repository

3. UI 切分與可組合（Phase 2）
   - `TrainingDetailPage` 拆為：`HeaderSection`、`TabBarSection`、`GamesListSection`、`PinRowSection`、`ActionButtons`（皆 Stateless）
   - `BowlingScoreCardWidget` 已調整格內比例；補強 props 的文件化，移除 magic numbers（集中到配置檔）
   - `TrainingUIActions` 替換 SnackBar → `TopNotification`

4. 樣式/常數集中（Phase 2）
   - 新增 `training_theme.dart`（或常數檔）集中尺寸、間距、字級、比例
   - 以此供 `ScoringBoard`/`BowlingScoreCardWidget`/各 section 使用

5. 歷史頁與列表（Phase 3）
   - 新增 `TrainingListController`：載入/分頁/快取
   - 將 `MyTrainingPage` 的「最近訓練」資料流改從 controller 取得
   - 擬真 `TrainingHistoryPage`（替換 sliding 版本）

6. 測試與驗收
   - 控制器單元測試：新增/輸入/刪除/持久化/分數計算接口
   - 小部件 Golden 測試：`ScoringBoard` 關鍵比例

---

### 6) 交付物與驗收標準
- 詳情頁大小 < 400 行，UI/邏輯明確分離。
- 新的 Controller 覆蓋率 ≥ 80%。
- 全局不再使用 `SnackBar`；通知統一 `TopNotification`。
- `TrainingDataService` 僅保留一份，路徑統一。
- 主要互動（新增/輸入/刪除/保存）在真機可連續操作無錯誤。

---

### 7) 分階段時程與回滾
- Phase 1（1-2 天）：Controller 化、資料層整併（不改 UI 行為）。
- Phase 2（1-2 天）：UI 切分、樣式常數化、通知一致化。
- Phase 3（1 天）：歷史頁/列表 Controller、測試完善、文件更新。

回滾：每階段以 feature flag（或路由切換）保留舊頁；出現阻斷問題時切回舊頁面與舊資料流。

---

### 8) 待辦清單（摘錄）
- [ ] 建 `training_detail_controller.dart`（@riverpod + Freezed State）
- [ ] 移轉 `TrainingDetailPage` 互動方法至 Controller
- [ ] 合併 `TrainingDataService` 重複檔案
- [ ] `TopNotification` 取代 SnackBar
- [ ] 切分 `TrainingDetailPage` 子元件
- [ ] 建 `training_theme.dart`（比例/尺寸常數）
- [ ] 新增單元與 golden 測試


