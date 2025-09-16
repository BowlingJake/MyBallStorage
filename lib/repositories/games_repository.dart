import 'package:supabase_flutter/supabase_flutter.dart';

class GamesRepository {
  GamesRepository({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<Map<String, dynamic>> upsertGame({
    required String trainingSessionId,
    required int gameNumber,
    String scoringMode = 'current',
    required List<Map<String, dynamic>> frames,
    List<Map<String, dynamic>> equipment = const [],
    int totalScore = 0,
    int strikes = 0,
    int spares = 0,
    String? notes,
    bool isCompleted = false,
  }) async {
    try {
      // 先嘗試找現有的遊戲
      final existing = await _client
          .from('games')
          .select('id')
          .eq('training_session_id', trainingSessionId)
          .eq('game_number', gameNumber)
          .maybeSingle();

      final data = {
        'training_session_id': trainingSessionId,
        'game_number': gameNumber,
        'frames': frames,
        'equipment': equipment,
        'total_score': totalScore,
        'strikes': strikes,
        'spares': spares,
        'scoring_mode': scoringMode,
        'is_completed': isCompleted,
        'notes': notes,
      };

      final result = existing != null
          ? await _client
              .from('games')
              .update(data)
              .eq('id', existing['id'])
              .select()
              .single()
          : await _client
              .from('games')
              .insert(data)
              .select()
              .single();

      return result as Map<String, dynamic>;
    } catch (e) {
      print('Error upserting game: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGamesBySession(String trainingSessionId) async {
    try {
      final result = await _client
          .from('games')
          .select('*')
          .eq('training_session_id', trainingSessionId)
          .order('game_number');
      return (result as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching games: $e');
      return [];
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _client
          .from('games')
          .delete()
          .eq('id', gameId);
    } catch (e) {
      print('Error deleting game: $e');
      rethrow;
    }
  }
}


