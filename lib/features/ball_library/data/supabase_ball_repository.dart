import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBallRepository implements BallRepository {
  SupabaseBallRepository(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<BowlingBall>> getAllBalls() async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('*')
          .order('create_at', nullsFirst: false)  // create_at優先，null在後
          .order('id');  // 次要排序用ID
      
      return (response as List<dynamic>)
          .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch balls from database: $e');
    }
  }

  @override
  Future<List<BowlingBall>> getBallsPaginated({
    required int offset,
    required int limit,
    String? orderBy,
    bool ascending = true,
  }) async {
    try {
      
      final query = _supabase
          .from('ball_data')
          .select('*')
          .range(offset, offset + limit - 1);
      
      // 預設排序：create_at優先，null的話用ID排序
      if (orderBy == null || orderBy == 'created_at' || orderBy == 'create_at') {
        
        final response = await query
            .order('create_at', nullsFirst: false)
            .order('id');
        
        
        
        final balls = (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
            
        return balls;
      } else {
        // 其他排序方式
        final response = ascending
            ? await query.order(orderBy)
            : await query.order(orderBy, ascending: false);
        
        return (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e, stackTrace) {
      throw Exception('Failed to fetch paginated balls: $e');
    }
  }

  @override
  Future<int> getTotalCount() async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('id')  // 只選擇一個欄位來計數
          .count(CountOption.exact);
      
      return response.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total count: $e');
    }
  }

  @override
  Future<List<BowlingBall>> getBallsByBrand(String brand) async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('*')
          .ilike('brand', brand)  // 不區分大小寫搜尋
          .order('ball_name');
      
      return (response as List<dynamic>)
          .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch balls by brand: $e');
    }
  }

  @override
  Future<List<BowlingBall>> searchBallsByName(String query) async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('*')
          .or('ball_name.ilike.%$query%,brand.ilike.%$query%')  // 搜尋球名或品牌
          .order('ball_name');
      
      return (response as List<dynamic>)
          .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search balls: $e');
    }
  }

  @override
  Future<List<String>> getAllBrands() async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('brand')
          .order('brand');
      
      final brands = (response as List<dynamic>)
          .map((item) => item['brand'] as String)
          .toSet()  // 移除重複
          .toList();
      
      brands.sort();  // 按字母順序排序
      return brands;
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }

  @override
  Future<BowlingBall?> getBallById(String id) async {
    try {
      final response = await _supabase
          .from('ball_data')
          .select('*')
          .eq('id', id)
          .maybeSingle();  // 返回單一結果或null
      
      if (response == null) return null;
      
      return BowlingBall.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch ball by ID: $e');
    }
  }

  @override
  void clearCache() {
    // Supabase不需要清除快取，因為每次都直接從資料庫讀取
    // 如果需要實作快取機制，可以在這裡加入相關邏輯
  }

  @override
  Future<List<BowlingBall>> getBallsWithFilters({
    String? searchText,
    BallFilters? filters,
    SortCriterion? sortCriterion,
    int? offset,
    int? limit,
  }) async {
    try {

      // 建立基本查詢
      var query = _supabase.from('ball_data').select('*');

      // 搜尋條件
      if (searchText != null && searchText.isNotEmpty) {
        query = query.or('ball_name.ilike.%$searchText%,brand.ilike.%$searchText%');
      }

      // 篩選條件
      if (filters != null) {
        // 處理品牌篩選（支援多選）
        if (filters.brands.isNotEmpty || filters.brand != null) {
          final brands = filters.brands.isNotEmpty 
            ? filters.brands 
            : {if (filters.brand != null) filters.brand!};
          
          if (brands.length == 1) {
            query = query.ilike('brand', '%${brands.first}%');
          } else {
            final brandConditions = brands.map((brand) => 'brand.ilike.%$brand%').join(',');
            query = query.or(brandConditions);
          }
        }
        
        // 處理球心篩選（支援多選）
        if (filters.cores.isNotEmpty || filters.core != null) {
          final cores = filters.cores.isNotEmpty 
            ? filters.cores 
            : {if (filters.core != null) filters.core!};
            
          final coreConditions = <String>[];
          for (final core in cores) {
            coreConditions.add('core_name.ilike.%$core%');
            coreConditions.add('core_type.ilike.%$core%');
          }
          query = query.or(coreConditions.join(','));
        }
        
        // 處理球皮篩選（支援多選）
        if (filters.coverstocks.isNotEmpty || filters.coverstock != null) {
          final coverstocks = filters.coverstocks.isNotEmpty 
            ? filters.coverstocks 
            : {if (filters.coverstock != null) filters.coverstock!};
            
          final coverstockConditions = <String>[];
          for (final coverstock in coverstocks) {
            final coverstockLower = coverstock.toLowerCase();
            if (coverstockLower == 'urethane') {
              coverstockConditions.addAll([
                'coverstock_name.ilike.%urethane%',
                'coverstock_type.ilike.%urethane%'
              ]);
            } else if (coverstockLower == 'polyester') {
              coverstockConditions.addAll([
                'coverstock_name.ilike.%polyester%',
                'coverstock_type.ilike.%polyester%',
                'coverstock_name.ilike.%poly%',
                'coverstock_type.ilike.%poly%'
              ]);
            } else if (coverstockLower == 'solid reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%solid%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%solid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%solid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%solid%,coverstock_name.ilike.%reactive%)'
              ]);
            } else if (coverstockLower == 'pearl reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%pearl%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%pearl%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%pearl%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%pearl%,coverstock_name.ilike.%reactive%)'
              ]);
            } else if (coverstockLower == 'hybrid reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%hybrid%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%hybrid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%hybrid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%hybrid%,coverstock_name.ilike.%reactive%)'
              ]);
            }
          }
          if (coverstockConditions.isNotEmpty) {
            query = query.or(coverstockConditions.join(','));
          }
        }
      }

      // 排序條件
      String orderByField = 'id';
      bool ascending = true;
      
      if (sortCriterion != null) {
        ascending = sortCriterion.ascending;
        switch (sortCriterion.field) {
          case SortField.id:
            orderByField = 'id';
          case SortField.name:
            orderByField = 'ball_name';
          case SortField.brand:
            orderByField = 'brand';
          case SortField.releaseYear:
            orderByField = 'release_date';
          case SortField.rg:
            orderByField = 'rg';
        }
      }

      // 應用排序和分頁，然後執行查詢
      if (offset != null && limit != null) {
        final response = await query
            .order(orderByField, ascending: ascending)
            .range(offset, offset + limit - 1);
        
        return (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final response = await query.order(orderByField, ascending: ascending);
        
        return (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // 這部分已經在上面處理了
    } catch (e, stackTrace) {
      throw Exception('Failed to fetch balls with filters: $e');
    }
  }

  @override
  Future<int> getTotalCountWithFilters({
    String? searchText,
    BallFilters? filters,
  }) async {
    try {

      // 建立查詢來取得符合條件的資料並計算數量
      var query = _supabase.from('ball_data').select('id');

      // 搜尋條件
      if (searchText != null && searchText.isNotEmpty) {
        query = query.or('ball_name.ilike.%$searchText%,brand.ilike.%$searchText%');
      }

      // 篩選條件
      if (filters != null) {
        // 處理品牌篩選（支援多選）
        if (filters.brands.isNotEmpty || filters.brand != null) {
          final brands = filters.brands.isNotEmpty 
            ? filters.brands 
            : {if (filters.brand != null) filters.brand!};
          
          if (brands.length == 1) {
            query = query.ilike('brand', '%${brands.first}%');
          } else {
            final brandConditions = brands.map((brand) => 'brand.ilike.%$brand%').join(',');
            query = query.or(brandConditions);
          }
        }
        
        // 處理球心篩選（支援多選）
        if (filters.cores.isNotEmpty || filters.core != null) {
          final cores = filters.cores.isNotEmpty 
            ? filters.cores 
            : {if (filters.core != null) filters.core!};
            
          final coreConditions = <String>[];
          for (final core in cores) {
            coreConditions.add('core_name.ilike.%$core%');
            coreConditions.add('core_type.ilike.%$core%');
          }
          query = query.or(coreConditions.join(','));
        }
        
        // 處理球皮篩選（支援多選）
        if (filters.coverstocks.isNotEmpty || filters.coverstock != null) {
          final coverstocks = filters.coverstocks.isNotEmpty 
            ? filters.coverstocks 
            : {if (filters.coverstock != null) filters.coverstock!};
            
          final coverstockConditions = <String>[];
          for (final coverstock in coverstocks) {
            final coverstockLower = coverstock.toLowerCase();
            if (coverstockLower == 'urethane') {
              coverstockConditions.addAll([
                'coverstock_name.ilike.%urethane%',
                'coverstock_type.ilike.%urethane%'
              ]);
            } else if (coverstockLower == 'polyester') {
              coverstockConditions.addAll([
                'coverstock_name.ilike.%polyester%',
                'coverstock_type.ilike.%polyester%',
                'coverstock_name.ilike.%poly%',
                'coverstock_type.ilike.%poly%'
              ]);
            } else if (coverstockLower == 'solid reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%solid%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%solid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%solid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%solid%,coverstock_name.ilike.%reactive%)'
              ]);
            } else if (coverstockLower == 'pearl reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%pearl%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%pearl%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%pearl%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%pearl%,coverstock_name.ilike.%reactive%)'
              ]);
            } else if (coverstockLower == 'hybrid reactive') {
              coverstockConditions.addAll([
                'and(coverstock_name.ilike.%hybrid%,coverstock_name.ilike.%reactive%)',
                'and(coverstock_type.ilike.%hybrid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_name.ilike.%hybrid%,coverstock_type.ilike.%reactive%)',
                'and(coverstock_type.ilike.%hybrid%,coverstock_name.ilike.%reactive%)'
              ]);
            }
          }
          if (coverstockConditions.isNotEmpty) {
            query = query.or(coverstockConditions.join(','));
          }
        }
      }

      // 執行查詢並計算數量
      final response = await query;
      final count = (response as List).length;
      return count;
    } catch (e, stackTrace) {
      throw Exception('Failed to get total count with filters: $e');
    }
  }
}