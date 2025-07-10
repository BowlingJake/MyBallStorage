import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';

/// 計分策略的抽象介面
/// 定義了所有計分邏輯必須實作的方法
abstract class ScoringStrategy {
  /// 計分策略名稱
  String get name;
  
  /// 計分策略描述
  String get description;
  
  /// 根據原始投球數據計算每一格的得分和累計分數
  /// 
  /// [rolls] 原始投球數據，每個元素代表擊倒的瓶數 (0-10)
  /// 返回包含10格完整計分數據的 BowlingFrame 列表
  List<BowlingFrame> calculateScores(List<int> rolls);
  
  /// 驗證投球數據是否有效
  /// 
  /// [rolls] 要驗證的投球數據
  /// 返回 true 如果數據有效，false 如果有錯誤
  bool validateRolls(List<int> rolls);
  
  /// 取得此策略下的完美分數（所有全倒）
  int get perfectScore;
}

/// 計分模式枚舉
enum ScoringMode { 
  traditional, 
  current 
} 