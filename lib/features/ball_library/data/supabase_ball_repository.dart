import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
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
      print('🔍 SupabaseBallRepository: getBallsPaginated');
      print('   offset: $offset, limit: $limit, orderBy: $orderBy');
      
      final query = _supabase
          .from('ball_data')
          .select('*')
          .range(offset, offset + limit - 1);
      
      // 預設排序：create_at優先，null的話用ID排序
      if (orderBy == null || orderBy == 'created_at' || orderBy == 'create_at') {
        print('   Using create_at + id sorting');
        final response = await query
            .order('create_at', nullsFirst: false)
            .order('id');
        
        print('   Raw response length: ${response.length}');
        if (response.isNotEmpty) {
          print('   First item: ${response.first}');
        }
        
        final balls = (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
            
        print('   Mapped balls: ${balls.length}');
        return balls;
      } else {
        // 其他排序方式
        print('   Using custom sorting: $orderBy');
        final response = ascending
            ? await query.order(orderBy)
            : await query.order(orderBy, ascending: false);
        
        print('   Raw response length: ${response.length}');
        return (response as List<dynamic>)
            .map((json) => BowlingBall.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e, stackTrace) {
      print('❌ SupabaseBallRepository error: $e');
      print('Stack trace: $stackTrace');
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
}