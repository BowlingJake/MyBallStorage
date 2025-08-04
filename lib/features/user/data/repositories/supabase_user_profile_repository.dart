import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/user/data/repositories/user_profile_repository.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

class SupabaseUserProfileRepository implements UserProfileRepository {
  final SupabaseClient _supabase;

  SupabaseUserProfileRepository(this._supabase);

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> saveUserProfile(UserProfile profile) async {
    try {
      final data = profile.toJson();
      data.remove('id'); // Remove id for upsert

      final response = await _supabase
          .from('profiles')
          .upsert(data)
          .eq('user_id', profile.userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  @override
  Future<void> updateBagName({
    required String userId,
    required int bagNumber,
    required String bagName,
  }) async {
    try {
      if (bagNumber < 1 || bagNumber > 9) {
        throw ArgumentError('Bag number must be between 1 and 9');
      }

      final columnName = 'bag_${bagNumber}_name';

      await _supabase
          .from('profiles')
          .update({columnName: bagName})
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update bag name: $e');
    }
  }

  @override
  Future<void> unlockBag({
    required String userId,
    required int bagNumber,
    required String bagName,
  }) async {
    try {
      if (bagNumber < 1 || bagNumber > 9) {
        throw ArgumentError('Bag number must be between 1 and 9');
      }

      final nameColumn = 'bag_${bagNumber}_name';
      final unlockedColumn = 'bag_${bagNumber}_unlocked';

      await _supabase
          .from('profiles')
          .update({
            nameColumn: bagName,
            unlockedColumn: true,
          })
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to unlock bag: $e');
    }
  }

  @override
  Future<void> deleteBag({
    required String userId,
    required int bagNumber,
  }) async {
    try {
      if (bagNumber < 1 || bagNumber > 9) {
        throw ArgumentError('Bag number must be between 1 and 9');
      }
      
      // 不能刪除袋子 1 (All My Arsenal)
      if (bagNumber == 1) {
        throw ArgumentError('Cannot delete bag 1 (All My Arsenal)');
      }

      final nameColumn = 'bag_${bagNumber}_name';
      final unlockedColumn = 'bag_${bagNumber}_unlocked';

      await _supabase
          .from('profiles')
          .update({
            nameColumn: null,
            unlockedColumn: false,
          })
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete bag: $e');
    }
  }

  @override
  Future<List<BagInfo>> getUnlockedBags(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      if (profile == null) {
        return [];
      }

      return profile.unlockedBags;
    } catch (e) {
      throw Exception('Failed to get unlocked bags: $e');
    }
  }
}