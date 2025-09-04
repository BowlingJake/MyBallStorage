import 'package:bowlingarsenal_app/features/training/data/repositories/supabase_training_repository.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 測試用的 provider
final testTrainingRepositoryProvider = Provider<SupabaseTrainingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseTrainingRepository(supabase);
});

class TrainingConnectionTest {
  static Future<void> testConnection(WidgetRef ref) async {
    try {
      final repo = ref.read(testTrainingRepositoryProvider);
      
      print('🔥 Testing Training Sessions connection...');
      
      // 1. 測試獲取現有 sessions
      final sessions = await repo.getTrainingSessions();
      print('✅ Successfully fetched ${sessions.length} training sessions');
      
      // 2. 測試創建新 session
      final testSession = await repo.createTrainingSession(
        title: 'Test Session',
        date: DateTime.now(),
        center: 'Test Center',
        isHousePattern: true,
        scoringMethod: 'traditional',
        inputMethod: 'quick',
      );
      print('✅ Successfully created test session: ${testSession.id}');
      
      // 3. 測試創建 game
      final testGame = await repo.createGame(
        trainingSessionId: testSession.id,
        gameNumber: 1,
        totalScore: 150,
        strikes: 3,
        spares: 4,
      );
      print('✅ Successfully created test game: ${testGame.id}');
      
      // 4. 測試獲取 games
      final games = await repo.getGamesForSession(testSession.id);
      print('✅ Successfully fetched ${games.length} games for session');
      
      // 5. 清理測試資料
      await repo.deleteGame(testGame.id);
      await repo.deleteTrainingSession(testSession.id);
      print('✅ Test cleanup completed');
      
      print('🎉 All tests passed! Frontend-backend connection is working.');
      
    } catch (e) {
      print('❌ Connection test failed: $e');
      print('💡 Check if RLS policies are properly set for training_sessions and games tables');
    }
  }
}