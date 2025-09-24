# 按鈕設計系統規範

## 設計原則

我們的按鈕設計遵循清晰的視覺層級和功能語義，確保用戶能快速理解每個按鈕的作用和重要性。

## 按鈕類型與應用場景

### 1. 主要動作按鈕 (Primary Action)
**樣式**: 金色實心填滿 + 黑色文字/圖標
**使用場景**:
- ✅ 確認/提交表單 (`Submit`, `Save`, `Confirm`)
- ✅ 完成流程 (`Finish`, `Complete`, `Done`)
- ✅ 登入/註冊 (`Login`, `Sign Up`)
- ✅ 購買/付款 (`Buy Now`, `Purchase`)
- ✅ 開始重要流程 (`Start Game`, `Begin`)

**代碼實現**:
```dart
AppStandardButton(
  text: 'Confirm',
  onPressed: () {},
  // 不需要額外參數，使用默認金色樣式
)
```

### 2. 次要動作按鈕 (Secondary Action)  
**樣式**: 中性色線框 + 中性色文字
**使用場景**:
- ↩️ 取消操作 (`Cancel`, `Back`)
- 📄 查看詳情 (`View Details`, `Learn More`)
- ⚙️ 設置選項 (`Settings`, `Options`)
- 🔄 重置/清除 (`Reset`, `Clear`)

**代碼實現**:
```dart
AppStandardButton.secondary(
  text: 'Cancel',
  onPressed: () {},
)
```

### 3. 創造/特殊功能按鈕 (Creative/Special Action)
**樣式**: 青色實心填滿 + 白色文字/圖標
**使用場景**:
- ➕ 創建新內容 (`Add New`, `Create`, `New Game`)
- 🎯 特殊功能入口 (`Ball Comparison`, `Export Data`)
- 🔗 連接/同步 (`Connect`, `Sync`)
- 📊 分析/報告 (`Generate Report`, `Analyze`)

**代碼實現**:
```dart
AppStandardButton.creative(
  text: 'Add New Ball',
  icon: Icons.add,
  onPressed: () {},
)
```

### 4. 破壞性動作按鈕 (Destructive Action)
**樣式**: 紅色實心填滿 + 白色文字/圖標
**使用場景**:
- 🗑️ 刪除資料 (`Delete`, `Remove`)
- ❌ 永久性操作 (`Clear All Data`)
- 🚫 禁用/停用 (`Disable`, `Deactivate`)

**代碼實現**:
```dart
AppStandardButton.destructive(
  text: 'Delete',
  icon: Icons.delete,
  onPressed: () {},
)
```

## 視覺層級

```
🥇 主要動作 (金色實心) → 最高優先級，頁面最重要的操作
🥈 創造功能 (青色實心) → 重要功能，但不是主流程
🥉 次要動作 (線框樣式) → 輔助操作，低視覺權重
⚠️ 破壞動作 (紅色實心) → 警告性操作，需謹慎處理
```

## 應用示例

### Ball Library 頁面
- `Add to Arsenal` → 創造功能按鈕 (青色)
- `Ball Comparison` → 創造功能按鈕 (青色)  
- `Compare` (選中2顆球後) → 主要動作按鈕 (金色)
- `Cancel` → 次要動作按鈕 (線框)

### 對話框
- `Save` → 主要動作按鈕 (金色)
- `Cancel` → 次要動作按鈕 (線框)
- `Delete Ball` → 破壞性動作按鈕 (紅色)

### 表單
- `Submit` → 主要動作按鈕 (金色)
- `Reset Form` → 次要動作按鈕 (線框)
- `Add New Category` → 創造功能按鈕 (青色)

## 狀態設計

### Disabled 狀態
- 所有按鈕類型在disabled時使用統一的灰色樣式
- 透明度降至 60%，視覺上明確表示不可操作

### Loading 狀態  
- 保持原有顏色，但顯示loading指示器
- 文字替換為 "Loading..." 或保持原文字 + spinner

### Hover/Press 狀態
- 主要/創造/破壞性按鈕：顏色變深 10%
- 次要按鈕：背景變為淺灰色

## 實現建議

建議在 `AppStandardButton` 中新增便利構造函數：

```dart
class AppStandardButton extends StatelessWidget {
  // 主要按鈕 (默認)
  const AppStandardButton({...});
  
  // 次要按鈕
  const AppStandardButton.secondary({...});
  
  // 創造功能按鈕  
  const AppStandardButton.creative({...});
  
  // 破壞性按鈕
  const AppStandardButton.destructive({...});
}
```

這樣可以讓開發者更直觀地選擇按鈕類型，同時確保設計一致性。

## 尺寸規範

- 標準高度（AppStandardButton.height）: 40px
- 標準字體大小: 14px
- 對話框預設按鈕高度: 40px（除非有特殊需求）

說明：專案中所有未特別指定的按鈕，預設高度皆為 40px，以統一觸控可用性與視覺一致性。