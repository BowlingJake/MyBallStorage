import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';

class SupabaseTrainingRepository {
  final SupabaseClient _supabase;

  SupabaseTrainingRepository(this._supabase);

  // === Training Sessions ===

  Future<List<TrainingSession>> getTrainingSessions() async {
    try {
      final response = await _supabase
          .from('training_sessions')
          .select('*')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('date', ascending: false);

      return response
          .map((json) => TrainingSession.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch training sessions: $e');
    }
  }

  Future<TrainingSession> createTrainingSession({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    String? oilPatternName,
    int? oilPatternLength,
    required String scoringMethod,
    required String inputMethod,
  }) async {
    try {
      final response = await _supabase
          .from('training_sessions')
          .insert({
            'user_id': _supabase.auth.currentUser!.id,
            'title': title,
            'date': date.toIso8601String().split('T')[0], // DATE format
            'center': center,
            'is_house_pattern': isHousePattern,
            'oil_pattern_name': oilPatternName,
            'oil_pattern_length': oilPatternLength,
            'scoring_method': scoringMethod,
            'input_method': inputMethod,
          })
          .select()
          .single();

      return TrainingSession.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create training session: $e');
    }
  }

  Future<TrainingSession> updateTrainingSession(TrainingSession session) async {
    try {
      final response = await _supabase
          .from('training_sessions')
          .update({
            'title': session.title,
            'date': session.date.toIso8601String().split('T')[0],
            'center': session.center,
            'is_house_pattern': session.isHousePattern,
            'oil_pattern_name': session.oilPatternName,
            'oil_pattern_length': session.oilPatternLength,
            'scoring_method': session.scoringMethod,
            'input_method': session.inputMethod,
          })
          .eq('id', session.id)
          .select()
          .single();

      return TrainingSession.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update training session: $e');
    }
  }

  Future<void> deleteTrainingSession(String sessionId) async {
    try {
      await _supabase
          .from('training_sessions')
          .delete()
          .eq('id', sessionId);
    } catch (e) {
      throw Exception('Failed to delete training session: $e');
    }
  }

  // === Games ===

  Future<List<Game>> getGamesForSession(String sessionId) async {
    try {
      final response = await _supabase
          .from('games')
          .select('*')
          .eq('training_session_id', sessionId)
          .order('game_number', ascending: true);

      // 正規化欄位：若資料表使用 created_at，轉成模型期望的 timestamp
      final List<Map<String, dynamic>> normalized = (response as List<dynamic>)
          .map((dynamic row) {
        final map = Map<String, dynamic>.from(row as Map);
        map['timestamp'] ??= map['created_at'];
        return map;
      }).toList();

      return normalized.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch games: $e');
    }
  }

  Future<Game> createGame({
    required String trainingSessionId,
    required int gameNumber,
    String? scoringMode,
    int totalScore = 0,
    List<int> frameScores = const [], // 兼容參數，已不再寫入
    int strikes = 0,
    int spares = 0,
    String? notes,
    List<Map<String, dynamic>> ballsUsed = const [], // 兼容參數，已不再寫入
    List<Map<String, dynamic>> detailedRolls = const [], // 兼容參數
    // 舊個別 frame 參數（忽略）
    int frame1Ball1 = 0,
    int frame1Ball2 = 0,
    int frame2Ball1 = 0,
    int frame2Ball2 = 0,
    int frame3Ball1 = 0,
    int frame3Ball2 = 0,
    int frame4Ball1 = 0,
    int frame4Ball2 = 0,
    int frame5Ball1 = 0,
    int frame5Ball2 = 0,
    int frame6Ball1 = 0,
    int frame6Ball2 = 0,
    int frame7Ball1 = 0,
    int frame7Ball2 = 0,
    int frame8Ball1 = 0,
    int frame8Ball2 = 0,
    int frame9Ball1 = 0,
    int frame9Ball2 = 0,
    int frame10Ball1 = 0,
    int frame10Ball2 = 0,
    int? frame10Ball3,
  }) async {
    try {
      final response = await _supabase
          .from('games')
          .insert({
            'training_session_id': trainingSessionId,
            'game_number': gameNumber,
            'total_score': totalScore,
            'strikes': strikes,
            'spares': spares,
            'notes': notes,
            'frames': <Map<String, dynamic>>[],
            'equipment': <Map<String, dynamic>>[],
            'scoring_mode': scoringMode ?? 'current',
            'is_completed': false,
          })
          .select()
          .single();

      return Game.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create game: $e');
    }
  }

  Future<Game> updateGame(Game game) async {
    try {
      final response = await _supabase
          .from('games')
          .update({
            'game_number': game.gameNumber,
            'total_score': game.totalScore,
            'strikes': game.strikes,
            'spares': game.spares,
            'notes': game.notes,
            'frames': game.frames.map((f) => f.toJson()).toList(),
            'equipment': game.equipment.map((e) => e.toJson()).toList(),
            'scoring_mode': game.scoringMode,
            'is_completed': game.isCompleted,
          })
          .eq('id', game.id)
          .select()
          .single();

      return Game.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _supabase
          .from('games')
          .delete()
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  Future<void> updateGameNotes(String gameId, String? notes) async {
    try {
      await _supabase
          .from('games')
          .update({'notes': notes})
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to update game notes: $e');
    }
  }
}