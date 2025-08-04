import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

/// Abstract repository interface for user profile management
abstract class UserProfileRepository {
  /// Get user profile by user ID
  Future<UserProfile?> getUserProfile(String userId);
  
  /// Create or update user profile
  Future<UserProfile> saveUserProfile(UserProfile profile);
  
  /// Update bag name for specific bag number
  Future<void> updateBagName({
    required String userId,
    required int bagNumber,
    required String bagName,
  });
  
  /// Unlock a specific bag
  Future<void> unlockBag({
    required String userId,
    required int bagNumber,
    required String bagName,
  });
  
  /// Delete a specific bag (set to unlocked: false, name: null)
  Future<void> deleteBag({
    required String userId,
    required int bagNumber,
  });
  
  /// Get all unlocked bags for a user
  Future<List<BagInfo>> getUnlockedBags(String userId);
}