# 🚀 第10格計分邏輯重構後續工作清單

## ✅ 已完成項目
- [x] 建立 Current/Traditional 第10格計算器
- [x] Developer Page 獨立測試環境
- [x] 球瓶狀態記憶和顯示邏輯
- [x] 智能按鈕啟用邏輯修復
- [x] 基礎架構和介面設計

---

## 🎯 高優先級 (建議先處理)

### 1. 整合新計算器到現有系統
**檔案**: `lib/features/training/logic/scoring/current_scoring_strategy.dart`
**任務**: 
- 將現有的第10格邏輯替換為新的 `CurrentFrame10Calculator`
- 移除重複的 `_calculateFrame10` 方法
- 使用統一的 `Frame10Calculator` 介面

**代碼範例**:
```dart
class CurrentScoringStrategy implements ScoringStrategy {
  late final Frame10Calculator _frame10Calculator;
  
  CurrentScoringStrategy() {
    _frame10Calculator = CurrentFrame10Calculator();
  }
  
  @override
  List<BowlingFrame> calculateScores(List<int> rolls) {
    // ... 前9格邏輯
    
    // 第10格使用新的計算器
    if (rollIndex < rolls.length) {
      final frame10Result = _frame10Calculator.calculate(rolls, rollIndex, cumulativeScore);
      frames.add(frame10Result.toBowlingFrame(cumulativeScore));
    }
  }
}
```

### 2. Traditional 計分策略同步更新
**檔案**: `lib/features/training/logic/scoring/traditional_scoring_strategy.dart`
**任務**:
- 同樣替換為 `TraditionalFrame10Calculator`
- 確保兩種模式使用一致的介面

### 3. 修復球瓶狀態顯示問題（可選）
**檔案**: `lib/shared/views/developer_page.dart`
**問題**: 第二球Spare後，第一球顯示狀態會改變
**解決方案**:
```dart
// 選項A: 固定歷史顯示（快照模式）
List<List<bool>> _historicalStates = []; // 保存當時的瞬時狀態

// 選項B: 改善UI描述
Text('累積狀態: 剩餘球瓶 ${standingPins.join(", ")}')
```

---

## 🔧 中優先級

### 4. 建立 1-9格通用計算器
**新檔案**: `lib/features/training/logic/scoring/components/frames_1_9_calculator.dart`
**目的**: 將前9格邏輯也分離出來，完善整體架構
```dart
class Frames1To9Calculator {
  static List<BowlingFrame> calculate(List<int> rolls, ScoringStrategy strategy);
  static int consumeRollsUpToFrame9(List<int> rolls);
}
```

### 5. 驗證邏輯重構
**任務**: 將驗證邏輯從計分策略中分離
**新檔案**: `lib/features/training/logic/scoring/components/scoring_validator.dart`
```dart
abstract class ScoringValidator {
  bool validateRolls(List<int> rolls, {bool isEditMode = false});
  List<int> sanitizeRolls(List<int> rolls);
}
```

### 6. Edit Mode 專門處理
**問題**: Edit Mode 仍可能有複雜的狀態管理問題
**解決方案**: 建立專門的 EditModeManager
**新檔案**: `lib/features/training/logic/editing/edit_mode_manager.dart`

---

## 🧪 測試和優化

### 7. 單元測試
**新檔案**: `test/features/training/logic/scoring/components/`
- `current_frame_10_calculator_test.dart`
- `traditional_frame_10_calculator_test.dart`
- `frame_10_test_cases.dart`

**測試案例**:
```dart
group('Current Frame 10 Calculator', () {
  test('Strike should return 30 points and complete', () {
    final result = calculator.calculate([10], 0, 270);
    expect(result.score, 30);
    expect(result.isComplete, true);
    expect(result.rollsUsed, 1);
  });
  
  test('Spare should return 10 + first ball', () {
    final result = calculator.calculate([7, 3], 0, 270);
    expect(result.score, 17); // 10 + 7
    expect(result.isComplete, true);
  });
});
```

### 8. 集成測試
**檔案**: `integration_test/frame_10_scoring_test.dart`
**測試**: 完整遊戲流程，包括 edit mode

---

## 📈 未來擴展

### 9. 支持更多計分模式
**例如**: World Bowling, No-Tap 等
**架構**: 工廠模式 + 策略模式
```dart
class ScoringStrategyFactory {
  static ScoringStrategy create(String mode) {
    switch (mode) {
      case 'current': return CurrentScoringStrategy();
      case 'traditional': return TraditionalScoringStrategy();
      case 'world_bowling': return WorldBowlingScoringStrategy();
    }
  }
}
```

### 10. 性能優化
- 計算結果快取
- 懶加載計算
- 內存使用優化

---

## 📝 文檔和維護

### 11. 更新技術文檔
**檔案**: `docs/BOWLING_SCORING.md`
**內容**: 計分邏輯說明、架構設計、使用指南

### 12. 代碼清理
- 移除舊的重複代碼
- 統一命名規範
- 添加更完整的註釋

---

## 🎮 使用測試環境的建議

### 當前測試步驟：
1. 進入 Developer Page
2. 選擇計分模式（Current/Traditional）
3. 使用「新增投球」測試各種場景

### 重要測試案例：
**Current 模式**:
- [10] → 30分，完成
- [7,3] → 17分，完成  
- [4,3] → 7分，完成

**Traditional 模式**:
- [10,8,1] → 19分，完成
- [7,3,5] → 15分，完成
- [4,3] → 7分，完成

### 發現問題時：
1. 檢查控制台輸出的詳細狀態
2. 確認球瓶狀態記錄是否正確
3. 驗證按鈕啟用邏輯是否符合規則

---

## ⚡ 快速開始建議

**建議處理順序**:
1. 先完成項目 1-2（整合新計算器）
2. 測試基本功能正常
3. 根據需要處理項目 3（UI顯示問題）
4. 再考慮其他擴展功能

這樣可以確保核心功能穩定，然後逐步完善！