import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

class SupabaseUserArsenalRepository implements UserArsenalRepository {
  final SupabaseClient _supabase;

  SupabaseUserArsenalRepository(this._supabase);

  @override
  Future<List<UserArsenalInstance>> getUserArsenal(String userId) async {
    try {
      
      final response = await _supabase
          .from('user_arsenal')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .order('added_date', ascending: false);


      return response.map<UserArsenalInstance>((json) {
        // Parse the joined bowling ball data
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        
        
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        // Create the instance with the bowling ball data
        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data'); // Remove the joined data
        // 直接使用原始的 bowlingBallData，不要經過序列化
        instanceData['bowling_ball_data'] = bowlingBallData;

        
        return UserArsenalInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user arsenal: $e');
    }
  }

  @override
  Future<UserArsenalInstance> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName, // 這個參數現在沒用到，但保持向後相容
    String? notes,
  }) async {
    try {

      final instanceData = {
        'user_id': userId,
        'ball_id': ballId,
        'notes': notes,
        'bag_1': true, // 預設放在第一個袋子
        'added_date': DateTime.now().toIso8601String(),
        'games_used': 0,
        'has_layout': false,
      };


      final response = await _supabase
          .from('user_arsenal')
          .insert(instanceData)
          .select()
          .single();


      // Fetch the complete instance with bowling ball data
      return _getCompleteInstance(response['id']);
    } catch (e) {
      throw Exception('Failed to add ball from library: $e');
    }
  }

  @override
  Future<void> updateArsenalInstance(UserArsenalInstance instance) async {
    try {
      final updateData = instance.toJson();
      updateData.remove('bowling_ball_data'); // Don't update the joined data
      updateData.remove('id'); // Don't update the primary key

      await _supabase
          .from('user_arsenal')
          .update(updateData)
          .eq('id', instance.id);
    } catch (e) {
      throw Exception('Failed to update arsenal instance: $e');
    }
  }

  @override
  Future<void> removeArsenalInstance(int instanceId) async {
    try {
      await _supabase
          .from('user_arsenal')
          .delete()
          .eq('id', instanceId);
    } catch (e) {
      throw Exception('Failed to remove arsenal instance: $e');
    }
  }

  @override
  Future<List<UserArsenalInstance>> getArsenalByCategory(String userId, String categoryName) async {
    // 這個方法暫時保留以維持向後相容，但實際上應該使用 getArsenalByBag
    try {
      final response = await _supabase
          .from('user_arsenal')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .eq('bag_1', true) // 暫時只返回第一個袋子的球
          .order('added_date', ascending: false);

      return response.map<UserArsenalInstance>((json) {
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data');
        instanceData['bowling_ball_data'] = bowlingBallData;

        return UserArsenalInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get arsenal by category: $e');
    }
  }

  @override
  Future<List<String>> getUserCategories(String userId) async {
    try {
      // 從 profiles 獲取球袋名稱
      final response = await _supabase
          .from('profiles')
          .select('bag_1_name,bag_1_unlocked,bag_2_name,bag_2_unlocked,bag_3_name,bag_3_unlocked,bag_4_name,bag_4_unlocked,bag_5_name,bag_5_unlocked,bag_6_name,bag_6_unlocked,bag_7_name,bag_7_unlocked,bag_8_name,bag_8_unlocked,bag_9_name,bag_9_unlocked')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return ['All My Arsenal']; // 預設返回第一個袋子名稱
      }

      final Set<String> categories = {};
      
      for (int i = 1; i <= 9; i++) {
        final isUnlocked = response['bag_${i}_unlocked'] as bool?;
        final bagName = response['bag_${i}_name'] as String?;
        
        if (isUnlocked == true && bagName != null && bagName.isNotEmpty) {
          categories.add(bagName);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get user categories: $e');
    }
  }

  @override
  Future<void> updateGamesUsed(int instanceId, int gamesUsed) async {
    try {
      await _supabase
          .from('user_arsenal')
          .update({'games_used': gamesUsed})
          .eq('id', instanceId);
    } catch (e) {
      throw Exception('Failed to update games used: $e');
    }
  }

  @override
  Future<void> updateLayout({
    required int instanceId,
    required String layoutType,
    required double value1,
    required double value2,
    required double value3,
  }) async {
    try {
      await _supabase
          .from('user_arsenal')
          .update({
            'has_layout': true,
            'layout_type': layoutType,
            'layout_value_1': value1,
            'layout_value_2': value2,
            'layout_value_3': value3,
          })
          .eq('id', instanceId);
    } catch (e) {
      throw Exception('Failed to update layout: $e');
    }
  }

  /// Get complete instance with ball data
  Future<UserArsenalInstance> _getCompleteInstance(int instanceId) async {
    final response = await _supabase
        .from('user_arsenal')
        .select('''
          *,
          ball_data(*)
        ''')
        .eq('id', instanceId)
        .single();

    final bowlingBallData = response['ball_data'] as Map<String, dynamic>?;
    BowlingBall? bowlingBall;
    if (bowlingBallData != null) {
      bowlingBall = BowlingBall.fromJson(bowlingBallData);
    }

    final instanceData = Map<String, dynamic>.from(response);
    instanceData.remove('ball_data');
    instanceData['bowling_ball_data'] = bowlingBallData;

    return UserArsenalInstance.fromJson(instanceData);
  }

  @override
  Future<void> updateBagAssignment({
    required int instanceId,
    required int bagNumber,
    required bool isInBag,
  }) async {
    try {
      if (bagNumber < 1 || bagNumber > 9) {
        throw ArgumentError('Bag number must be between 1 and 9');
      }
      
      final columnName = 'bag_$bagNumber';
      
      await _supabase
          .from('user_arsenal')
          .update({columnName: isInBag})
          .eq('id', instanceId);
          
    } catch (e) {
      throw Exception('Failed to update bag assignment: $e');
    }
  }

  @override
  Future<List<UserArsenalInstance>> getArsenalByBag(String userId, int bagNumber) async {
    try {
      if (bagNumber < 1 || bagNumber > 9) {
        throw ArgumentError('Bag number must be between 1 and 9');
      }
      
      final columnName = 'bag_$bagNumber';
      
      final response = await _supabase
          .from('user_arsenal')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .eq(columnName, true)
          .order('added_date', ascending: false);

      return response.map<UserArsenalInstance>((json) {
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data');
        instanceData['bowling_ball_data'] = bowlingBallData;

        return UserArsenalInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get arsenal by bag: $e');
    }
  }
}