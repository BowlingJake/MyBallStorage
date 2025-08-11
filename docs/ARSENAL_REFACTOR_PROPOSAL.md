# My Arsenal 重構提案（v1）

文件目的：在不破壞既有資料模型與邏輯層的前提下，重構 `My Arsenal` 頁面，使其更符合 TECHNICAL_SPEC 中的分層規範、現代互動模式與可維護性。此提案審閱通過後，將分階段實作。

## 目標
- 精簡操作入口：新增、移動、移除，採 AppBar + Modal Bottom Sheet，不使用 FAB 以避免遮擋內容。
- 強化結構與可復用性：拆分大型頁面為小部件，將操作列、搜尋、分頁、清單視圖等模組化。
- 維持/加強 Riverpod 架構：所有 UI 透過 `newArsenalControllerProvider` 與 `userProfileControllerProvider` 取得/變更狀態。
- 無破壞性：保留既有資料流與 repositories，不改動資料結構。

## 現況摘要（重點）
- `my_arsenal_page.dart` 體積龐大，含：TabBar、搜尋、管理列、Grid/List 兩種視圖、選擇模式（移動/移除）。
- 已改為 AppBar 搜尋；右上角三點面板支援 Filter/Sort 並已新增 Move/Remove 快捷。
- 上方仍有舊的行動按鈕列（Add/Move/Remove）。

## 重構藍圖

### 1. 檔案與組件拆分
- 新增目錄 `lib/features/arsenal/presentation/widgets/appbar/`、`tabs/`、`lists/`、`management/`。
- 拆分元件：
  - `ArsenalAppBar`：負責標題/搜尋/右側 actions（Add、More）。
  - `ArsenalTabs`：負責可捲動 TabBar 與解鎖按鈕事件。
  - `ArsenalActionBar`：頁面內容上方的小工具列（後續可移除）。
  - `ArsenalGridView`、`ArsenalListView`：兩種視圖的獨立 Widget。
  - `ArsenalSelectionBar`：在移動/移除模式時顯示的情境控制列（可替代現行 `_buildRemoveModeControls`/`_buildMoveModeControls` 視覺層）。
  - `ArsenalBottomSheet`：More 面板，內含 Move/Remove/Filter/Sort 等項，對應事件由外部注入。

效益：降低單檔複雜度、提高測試與替換彈性。

### 2. 互動與資訊架構
- AppBar：
  - 左：返回首頁。
  - Title：可切換為搜尋輸入（已有）。
  - 右：`Add`（呼叫 `_showCrossSubBagAddDialog`）、`More`（打開 `ArsenalBottomSheet`）。
- Bottom Sheet（More）：
  - 快捷動作：Move（非主袋）、Remove。
  - 管理：Filter、Sort、Clear All。
  - 未來擴充槽位：Manage Categories、Rename Bag、Unlock Bag 等。
- 選擇模式：
  - 觸發：More 快捷或列表卡片長按。
  - 情境列：顯示選取數、確認/取消，置於 AppBar；頁面上方行動列將逐步移除。

### 3. 狀態與邏輯
- 繼續以 `newArsenalControllerProvider` 驅動：
  - `selectedBagNumber`、`viewMode`、`filters`、`sortOption`、`selectedForMove`、`selectedForRemoval`。
- 新增（如需）：
  - `isSelectionMode`（現已由 isRemoveMode/isMoveMode 隱含，可提供便捷 getter）。
  - `enterSelectionMode(SelectionType)`、`exitSelectionMode()` 包裝現有 `_toggle...`，讓 UI 更語義化。

### 4. 導航與路由
- 符合 TECHNICAL_SPEC：所有導航使用 `go_router`。
- More 面板、對話框採 `showModalBottomSheet` / `showDialog`，維持目前風格。

### 5. 視覺與主題
- 搜尋列透明背景（已完成），邊框與提示色使用 Theme 主色系。
- AppBar actions、面板圖示統一使用 `Iconsax`/Material Icons，與品牌色一致。
- 移除 FAB，避免與卡片重疊；所有主動作集中到 AppBar/Bottom Sheet。

### 6. 實作分階段計畫
1) 拆分元件骨架，無行為改變：
   - 抽出 `ArsenalAppBar`、`ArsenalTabs`、`ArsenalGridView`、`ArsenalListView`、`ArsenalBottomSheet`。
2) 將 More 面板的 Move/Remove 行為串上既有 `_toggleMoveMode()`、`_toggleRemoveMode()`。
3) 將選擇模式的控制列上移至 AppBar，並確保返回鍵可退出選擇模式（攔截 `WillPopScope`）。
4) 驗證：Grid/List 兩模式、Filter/Sort 狀態同步、各球袋切換與解鎖流程。
5) 清理：移除頁面內容上方的舊行動按鈕列（在你確認後）。

### 7. 風險與回退
- 風險：拆分過程可能導致狀態注入錯位。對策：以 props 傳遞回呼、在子元件內只讀取 provider，動作一律回調到父層。
- 回退：保留舊按鈕列至第 5 階段完成再刪除；每階段可單獨回滾。

### 8. 不變項
- 資料模型、repositories、providers API 盡量不變；只影響 presentation 層。
- 導航規則與主題系統遵循 `docs/TECHNICAL_SPEC.md`。

---

若此提案獲准，將依階段逐步提交 PR；每個階段都確保單元/整合驗證與最少視覺偏差。

