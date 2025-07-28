import 'package:bowlingarsenal_app/features/arsenal/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/widgets/ball_list_view.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// 將 ArsenalBall 轉換為 BowlingBall 的適配器函數
/// 用於在 popout detail 中顯示 Arsenal 中的球
BowlingBall arsenalBallToBowlingBall(ArsenalBall arsenalBall) {
  return BowlingBall(
    id: 0, // 使用預設 ID，因為 BowlingBall.id 是 int 類型
    name: arsenalBall.name,
    brand: arsenalBall.brand,
    coverstock: arsenalBall.cover, // cover 映射到 coverstock
    coverstockName: arsenalBall.cover, // 完整名稱也使用 cover
    coreName: arsenalBall.core, // core 映射到 coreName
    imageUrl: arsenalBall.imagePath, // imagePath 映射到 imageUrl
  );
}
