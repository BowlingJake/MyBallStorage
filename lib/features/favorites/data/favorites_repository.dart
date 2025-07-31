import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// Repository for managing favorite balls
/// Handles all Supabase interactions for favorite balls functionality
class FavoritesRepository {
  final SupabaseClient _supabase;

  FavoritesRepository(this._supabase);

  /// Add a ball to user's favorites
  Future<void> addToFavorites(int ballId) async {
    final userId = _supabase.auth.currentUser?.id;
    
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase.from('favorite_balls').insert({
        'user_id': userId,
        'ball_id': ballId,
      });
    } catch (e) {
      throw Exception('Failed to add ball to favorites: $e');
    }
  }

  /// Remove a ball from user's favorites
  Future<void> removeFromFavorites(int ballId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase
          .from('favorite_balls')
          .delete()
          .eq('user_id', userId)
          .eq('ball_id', ballId);
    } catch (e) {
      throw Exception('Failed to remove ball from favorites: $e');
    }
  }

  /// Check if a ball is in user's favorites
  Future<bool> isFavorite(int ballId) async {
    final userId = _supabase.auth.currentUser?.id;
    
    if (userId == null) {
      return false;
    }

    try {
      final response = await _supabase
          .from('favorite_balls')
          .select('id')
          .eq('user_id', userId)
          .eq('ball_id', ballId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  /// Get user's favorite ball IDs
  Future<List<int>> getFavoriteBallIds() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }

    try {
      final response = await _supabase
          .from('favorite_balls')
          .select('ball_id')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<int>((item) => item['ball_id'] as int).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite ball IDs: $e');
    }
  }

  /// Get user's favorite balls with full ball information
  Future<List<BowlingBall>> getFavoriteBalls() async {
    final userId = _supabase.auth.currentUser?.id;
    
    if (userId == null) {
      return [];
    }

    try {
      final response = await _supabase
          .from('favorite_balls')
          .select('''
            ball_id,
            created_at,
            ball_data!inner(*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<BowlingBall>((item) {
        final ballData = item['ball_data'] as Map<String, dynamic>;
        return BowlingBall.fromJson(ballData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite balls: $e');
    }
  }

  /// Get count of user's favorite balls
  Future<int> getFavoriteCount() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return 0;
    }

    try {
      final response = await _supabase
          .from('favorite_balls')
          .select('id')
          .eq('user_id', userId);

      return response.length;
    } catch (e) {
      throw Exception('Failed to get favorite count: $e');
    }
  }
}