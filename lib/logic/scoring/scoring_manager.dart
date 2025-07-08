import '../../widgets/bowling/bowling_scorecard_widget.dart';
import 'scoring_strategy.dart';
import 'traditional_scoring_strategy.dart';
import 'current_scoring_strategy.dart';

/// 計分管理器
/// 
/// 提供統一的計分介面，內部使用策略模式來處理不同的計分邏輯
class ScoringManager {
  ScoringStrategy _currentStrategy;
  ScoringMode _currentMode;
  
  /// 建構函式，預設使用傳統計分
  ScoringManager({ScoringMode mode = ScoringMode.traditional}) 
    : _currentMode = mode,
      _currentStrategy = _createStrategy(mode);
  
  /// 當前使用的計分模式
  ScoringMode get currentMode => _currentMode;
  
  /// 當前使用的策略名稱
  String get currentStrategyName => _currentStrategy.name;
  
  /// 當前策略的描述
  String get currentStrategyDescription => _currentStrategy.description;
  
  /// 當前策略的完美分數
  int get perfectScore => _currentStrategy.perfectScore;
  
  /// 切換計分模式
  void switchMode(ScoringMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      _currentStrategy = _createStrategy(mode);
    }
  }
  
  /// 計算分數
  /// 
  /// [rolls] 原始投球數據
  /// 返回包含10格完整計分數據的 BowlingFrame 列表
  List<BowlingFrame> calculateScores(List<int> rolls) {
    return _currentStrategy.calculateScores(rolls);
  }
  
  /// 驗證投球數據
  bool validateRolls(List<int> rolls) {
    return _currentStrategy.validateRolls(rolls);
  }
  
  /// 取得所有可用的計分模式
  static List<ScoringModeInfo> getAllModes() {
    return [
      ScoringModeInfo(
        mode: ScoringMode.traditional,
        strategy: TraditionalScoringStrategy(),
      ),
      ScoringModeInfo(
        mode: ScoringMode.current,
        strategy: CurrentScoringStrategy(),
      ),
    ];
  }
  
  /// 根據模式創建策略實例
  static ScoringStrategy _createStrategy(ScoringMode mode) {
    switch (mode) {
      case ScoringMode.traditional:
        return TraditionalScoringStrategy();
      case ScoringMode.current:
        return CurrentScoringStrategy();
    }
  }
  
  /// 建立示範數據，用於測試和展示
  static ScoringDemoData createDemoData() {
    return ScoringDemoData();
  }
}

/// 計分模式資訊
class ScoringModeInfo {
  final ScoringMode mode;
  final ScoringStrategy strategy;
  
  const ScoringModeInfo({
    required this.mode,
    required this.strategy,
  });
  
  String get name => strategy.name;
  String get description => strategy.description;
  int get perfectScore => strategy.perfectScore;
}

/// 示範數據類別
class ScoringDemoData {
  /// 完美遊戲：12次連續Strike
  static const perfectGame = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10];
  
  /// 混合遊戲：包含Strike、Spare、Open frame
  static const mixedGame = [10, 7, 3, 9, 0, 10, 0, 8, 8, 2, 0, 6, 10, 2, 3, 6, 4, 5];
  
  /// 全補中遊戲：每格都是Spare
  static const allSparesGame = [9, 1, 8, 2, 7, 3, 6, 4, 5, 5, 4, 6, 3, 7, 2, 8, 1, 9, 0, 10];
  
  /// 低分遊戲：沒有Strike或Spare
  static const lowScoreGame = [3, 4, 2, 5, 1, 6, 4, 3, 2, 2, 5, 1, 3, 3, 4, 2, 1, 5, 2, 3];
  
  /// 取得所有示範數據
  List<DemoGameData> getAllDemoGames() {
    return [
      DemoGameData(
        name: '完美遊戲',
        description: '12次連續Strike，滿分300',
        rolls: perfectGame,
      ),
      DemoGameData(
        name: '混合遊戲',
        description: '包含Strike、Spare和Open frame的典型遊戲',
        rolls: mixedGame,
      ),
      DemoGameData(
        name: '全補中遊戲',
        description: '每一格都是Spare的遊戲',
        rolls: allSparesGame,
      ),
      DemoGameData(
        name: '低分遊戲',
        description: '沒有Strike或Spare的簡單遊戲',
        rolls: lowScoreGame,
      ),
    ];
  }
}

/// 示範遊戲數據
class DemoGameData {
  final String name;
  final String description;
  final List<int> rolls;
  
  const DemoGameData({
    required this.name,
    required this.description,
    required this.rolls,
  });
} 