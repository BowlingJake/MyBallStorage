import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

/// 抽象的 Ball Repository 介面
/// 定義了所有與保齡球庫數據相關的操作合約
abstract class BallRepository {
  /// 獲取所有可用的保齡球列表
  Future<List<BowlingBall>> getAllBalls();

  /// 分頁獲取保齡球列表
  Future<List<BowlingBall>> getBallsPaginated({
    required int offset,
    required int limit,
    String? orderBy,
    bool ascending = true,
  });

  /// 根據搜尋條件、篩選條件和排序條件獲取保齡球列表
  Future<List<BowlingBall>> getBallsWithFilters({
    String? searchText,
    BallFilters? filters,
    SortCriterion? sortCriterion,
    int? offset,
    int? limit,
  });

  /// 根據搜尋條件、篩選條件獲取總數量
  Future<int> getTotalCountWithFilters({
    String? searchText,
    BallFilters? filters,
  });

  /// 根據品牌篩選保齡球
  Future<List<BowlingBall>> getBallsByBrand(String brand);

  /// 根據名稱搜尋保齡球
  Future<List<BowlingBall>> searchBallsByName(String query);

  /// 獲取所有可用的品牌列表
  Future<List<String>> getAllBrands();

  /// 根據ID獲取特定保齡球
  Future<BowlingBall?> getBallById(String id);

  /// 獲取總數量
  Future<int> getTotalCount();

  /// 清除快取（用於重新加載數據）
  void clearCache();
} 