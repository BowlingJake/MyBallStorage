import 'package:bowlingarsenal_app/features/arsenal/models/arsenal_ball.dart';

/// 抽象的 Arsenal Repository 介面
/// 定義了所有與 Arsenal 數據相關的操作合約
abstract class ArsenalRepository {
  /// 獲取用戶的保齡球庫列表
  Future<List<ArsenalBall>> getUserArsenal();

  /// 將新的保齡球添加到庫中
  Future<void> addBallToArsenal(ArsenalBall ball);

  /// 更新庫中的保齡球資訊
  Future<void> updateBallInArsenal(ArsenalBall ball);

  /// 從庫中移除指定的保齡球
  Future<void> removeBallFromArsenal(String ballId);
} 