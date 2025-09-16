import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/training/data/repositories/supabase_training_repository.dart';
import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';

class TrainingSessionsRepository {
  late final SupabaseTrainingRepository _supabaseRepo;

  TrainingSessionsRepository() {
    _supabaseRepo = SupabaseTrainingRepository(Supabase.instance.client);
  }

  Future<void> updateTrainingSession({
    required String sessionId,
    required String title,
    required String centerName,
    required DateTime date,
    required bool isHousePattern,
    String? oilPatternName,
    int? oilPatternLength,
    required String scoringMethod,
    required String fillMethod,
  }) async {
    try {
      // 首先獲取現有的 session 來保持其他欄位不變
      final sessions = await _supabaseRepo.getTrainingSessions();
      final existingSession = sessions.firstWhere(
        (s) => s.id == sessionId,
        orElse: () => throw Exception('Training session not found'),
      );

      // 創建更新後的 session
      final updatedSession = TrainingSession(
        id: sessionId,
        userId: existingSession.userId,
        title: title,
        date: date,
        center: centerName,
        isHousePattern: isHousePattern,
        oilPatternName: oilPatternName,
        oilPatternLength: oilPatternLength,
        scoringMethod: scoringMethod,
        inputMethod: fillMethod,
        createdAt: existingSession.createdAt,
        updatedAt: DateTime.now(),
      );

      await _supabaseRepo.updateTrainingSession(updatedSession);
    } catch (e) {
      throw Exception('Failed to update training session: $e');
    }
  }
}