import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// BallRepository的具體實現，基於BallDataService
/// 將服務層包裝為Repository模式，提供更高層次的抽象
class BallDataRepository implements BallRepository {
  BallDataRepository(this._ballDataService);

  final BallDataService _ballDataService;

  @override
  Future<List<BowlingBall>> getAllBalls() async {
    final balls = await _ballDataService.loadBallData();
    balls.sort((a, b) => a.id.compareTo(b.id));  // 預設按ID排序
    return balls;
  }

  @override
  Future<List<BowlingBall>> getBallsPaginated({
    required int offset,
    required int limit,
    String? orderBy,
    bool ascending = true,
  }) async {
    final allBalls = await _ballDataService.loadBallData();
    
    // 排序
    allBalls.sort((a, b) {
      int comparison;
      switch (orderBy) {
        case 'ball_name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'brand':
          comparison = a.brand.compareTo(b.brand);
          break;
        default: // 預設使用ID
          comparison = a.id.compareTo(b.id);
      }
      return ascending ? comparison : -comparison;
    });
    
    // 分頁
    final start = offset;
    final end = (offset + limit).clamp(0, allBalls.length);
    
    if (start >= allBalls.length) return [];
    
    return allBalls.sublist(start, end);
  }

  @override
  Future<int> getTotalCount() async {
    final balls = await _ballDataService.loadBallData();
    return balls.length;
  }

  @override
  Future<List<BowlingBall>> getBallsByBrand(String brand) async {
    final allBalls = await _ballDataService.loadBallData();
    return allBalls
        .where((ball) => ball.brand.toLowerCase() == brand.toLowerCase())
        .toList();
  }

  @override
  Future<List<BowlingBall>> searchBallsByName(String query) async {
    final allBalls = await _ballDataService.loadBallData();
    final lowercaseQuery = query.toLowerCase();
    return allBalls
        .where((ball) => ball.name.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  @override
  Future<List<String>> getAllBrands() async {
    final allBalls = await _ballDataService.loadBallData();
    final brands = allBalls.map((ball) => ball.brand).toSet().toList();
    brands.sort(); // 按字母順序排序
    return brands;
  }

  @override
  Future<BowlingBall?> getBallById(String id) async {
    final allBalls = await _ballDataService.loadBallData();
    try {
      return allBalls.firstWhere((ball) => ball.id == id);
    } catch (e) {
      return null; // 找不到對應ID的球
    }
  }

  @override
  void clearCache() {
    // 由於BallDataService使用私有字段快取，我們無法直接清除
    // 在實際實現中，可能需要修改BallDataService或使用其他策略
    // 暫時留空，或者可以重新創建service實例
  }
} 