import '../models/arsenal_ball.dart';
import '../widgets/ball_list_view.dart';

/// 將 ArsenalBall 轉換為 BowlingBall 的適配器函數
/// 用於在 popout detail 中顯示 Arsenal 中的球
BowlingBall arsenalBallToBowlingBall(ArsenalBall arsenalBall) {
  return BowlingBall(
    id: arsenalBall.name, // 使用名稱作為 ID
    name: arsenalBall.name,
    brand: arsenalBall.brand,
    coverstock: arsenalBall.cover, // cover 映射到 coverstock
    coverstockName: arsenalBall.cover, // 完整名稱也使用 cover
    core: arsenalBall.core,
    imageUrl: arsenalBall.imagePath, // imagePath 映射到 imageUrl
    rg: null, // Arsenal 球沒有這些數據，設為 null
    differential: null,
    massBias: null,
  );
} 