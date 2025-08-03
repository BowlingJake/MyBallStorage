import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';

abstract class UserArsenalRepository {
  /// Get all arsenal instances for a user
  Future<List<UserArsenalInstance>> getUserArsenal(String userId);
  
  /// Add a ball from library to user's arsenal
  Future<UserArsenalInstance> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName,
    String? notes,
  });
  
  /// Update an arsenal instance
  Future<void> updateArsenalInstance(UserArsenalInstance instance);
  
  /// Remove an arsenal instance
  Future<void> removeArsenalInstance(int instanceId);
  
  /// Get arsenal instances filtered by category
  Future<List<UserArsenalInstance>> getArsenalByCategory(String userId, String categoryName);
  
  /// Get all unique category names for a user
  Future<List<String>> getUserCategories(String userId);
  
  /// Update games used for an instance
  Future<void> updateGamesUsed(int instanceId, int gamesUsed);
  
  /// Update layout for an instance
  Future<void> updateLayout({
    required int instanceId,
    required String layoutType,
    required double value1,
    required double value2,
    required double value3,
  });
}