import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
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

  @override
  Future<List<BowlingBall>> getBallsWithFilters({
    String? searchText,
    BallFilters? filters,
    SortCriterion? sortCriterion,
    int? offset,
    int? limit,
  }) async {
    final allBalls = await _ballDataService.loadBallData();
    Iterable<BowlingBall> filteredBalls = allBalls;

    // 搜尋條件
    if (searchText != null && searchText.isNotEmpty) {
      final lowercaseQuery = searchText.toLowerCase();
      filteredBalls = filteredBalls.where((ball) =>
          ball.name.toLowerCase().contains(lowercaseQuery) ||
          ball.brand.toLowerCase().contains(lowercaseQuery));
    }

    // 篩選條件
    if (filters != null) {
      // 處理品牌篩選（支援多選）
      if (filters.brands.isNotEmpty || filters.brand != null) {
        final brands = filters.brands.isNotEmpty 
          ? filters.brands 
          : {if (filters.brand != null) filters.brand!};
        
        filteredBalls = filteredBalls.where((ball) {
          return brands.any((brand) => 
            ball.brand.toLowerCase().contains(brand.toLowerCase()));
        });
      }
      
      // 處理球心篩選（支援多選）
      if (filters.cores.isNotEmpty || filters.core != null) {
        final cores = filters.cores.isNotEmpty 
          ? filters.cores 
          : {if (filters.core != null) filters.core!};
        
        filteredBalls = filteredBalls.where((ball) {
          final ballCore = ball.core.toLowerCase();
          return cores.any((core) => ballCore.contains(core.toLowerCase()));
        });
      }
      
      // 處理球皮篩選（支援多選）
      if (filters.coverstocks.isNotEmpty || filters.coverstock != null) {
        final coverstocks = filters.coverstocks.isNotEmpty 
          ? filters.coverstocks 
          : {if (filters.coverstock != null) filters.coverstock!};
        
        filteredBalls = filteredBalls.where((ball) {
          final coverstock = (ball.coverstock ?? '').toLowerCase();
          
          return coverstocks.any((selectedCoverstock) {
            final selectedCoverstockLower = selectedCoverstock.toLowerCase();
            switch (selectedCoverstockLower) {
              case 'urethane':
                return coverstock.contains('urethane');
              case 'polyester':
                return coverstock.contains('polyester') || coverstock.contains('poly');
              case 'solid reactive':
                return coverstock.contains('solid') && coverstock.contains('reactive');
              case 'pearl reactive':
                return coverstock.contains('pearl') && coverstock.contains('reactive');
              case 'hybrid reactive':
                return coverstock.contains('hybrid') && coverstock.contains('reactive');
              default:
                return false;
            }
          });
        });
      }
    }

    // 排序
    final ballsList = filteredBalls.toList();
    if (sortCriterion != null) {
      ballsList.sort((a, b) {
        int comparison;
        switch (sortCriterion.field) {
          case SortField.id:
            comparison = a.id.compareTo(b.id);
            break;
          case SortField.name:
            comparison = a.name.compareTo(b.name);
            break;
          case SortField.brand:
            comparison = a.brand.compareTo(b.brand);
            break;
          case SortField.releaseYear:
            if (a.releaseDate == null && b.releaseDate == null) {
              comparison = 0;
            } else if (a.releaseDate == null) {
              comparison = 1;
            } else if (b.releaseDate == null) {
              comparison = -1;
            } else {
              comparison = a.releaseDate!.compareTo(b.releaseDate!);
            }
            break;
          case SortField.rg:
            if (a.rg == null && b.rg == null) {
              comparison = 0;
            } else if (a.rg == null) {
              comparison = 1;
            } else if (b.rg == null) {
              comparison = -1;
            } else {
              comparison = a.rg!.compareTo(b.rg!);
            }
            break;
        }
        return sortCriterion.ascending ? comparison : -comparison;
      });
    }

    // 分頁
    if (offset != null && limit != null) {
      final start = offset.clamp(0, ballsList.length);
      final end = (offset + limit).clamp(0, ballsList.length);
      return ballsList.sublist(start, end);
    }

    return ballsList;
  }

  @override
  Future<int> getTotalCountWithFilters({
    String? searchText,
    BallFilters? filters,
  }) async {
    final filteredBalls = await getBallsWithFilters(
      searchText: searchText,
      filters: filters,
    );
    return filteredBalls.length;
  }
} 