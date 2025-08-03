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
      print('Supabase Arsenal Repository: Getting arsenal for user $userId');
      
      final response = await _supabase
          .from('user_arsenal')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .order('added_date', ascending: false);

      print('Supabase Arsenal Repository: Raw response: $response');

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

        print('Supabase Arsenal Repository: Processing instance ${instanceData['id']} - Ball: ${bowlingBall?.name}');
        
        return UserArsenalInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      print('Supabase Arsenal Repository: Error getting user arsenal: $e');
      throw Exception('Failed to get user arsenal: $e');
    }
  }

  @override
  Future<UserArsenalInstance> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName,
    String? notes,
  }) async {
    try {
      print('Supabase Arsenal Repository: Adding ball $ballId to category "$categoryName" for user $userId');

      final instanceData = {
        'user_id': userId,
        'ball_id': ballId,
        'notes': notes,
        'bag_category_1': categoryName, // 預設放在第一個分類
        'added_date': DateTime.now().toIso8601String(),
        'games_used': 0,
        'has_layout': false,
      };

      print('Supabase Arsenal Repository: Inserting data: $instanceData');

      final response = await _supabase
          .from('user_arsenal')
          .insert(instanceData)
          .select()
          .single();

      print('Supabase Arsenal Repository: Insert successful: $response');

      // Fetch the complete instance with bowling ball data
      return _getCompleteInstance(response['id']);
    } catch (e) {
      print('Supabase Arsenal Repository: Error adding ball from library: $e');
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
    try {
      final response = await _supabase
          .from('user_arsenal')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .or('bag_category_1.eq.$categoryName,bag_category_2.eq.$categoryName,bag_category_3.eq.$categoryName,bag_category_4.eq.$categoryName,bag_category_5.eq.$categoryName,bag_category_6.eq.$categoryName,bag_category_7.eq.$categoryName,bag_category_8.eq.$categoryName,bag_category_9.eq.$categoryName')
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
      final response = await _supabase
          .from('user_arsenal')
          .select('bag_category_1,bag_category_2,bag_category_3,bag_category_4,bag_category_5,bag_category_6,bag_category_7,bag_category_8,bag_category_9')
          .eq('user_id', userId);

      final Set<String> categories = {};
      
      for (final row in response) {
        for (int i = 1; i <= 9; i++) {
          final category = row['bag_category_$i'] as String?;
          if (category != null && category.isNotEmpty) {
            categories.add(category);
          }
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
}