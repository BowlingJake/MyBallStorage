import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/user/data/repositories/user_profile_repository.dart';
import 'package:bowlingarsenal_app/features/user/data/repositories/supabase_user_profile_repository.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'user_profile_controller.freezed.dart';
part 'user_profile_controller.g.dart';

/// State class for user profile management
@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    UserProfile? profile,
    @Default(false) bool isLoading,
    String? error,
  }) = _UserProfileState;
}

/// User profile repository provider
@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserProfileRepository(supabase);
}

/// User profile controller
@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  UserProfileState build() {
    return const UserProfileState();
  }

  UserProfileRepository get _repository => ref.read(userProfileRepositoryProvider);

  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      var profile = await _repository.getUserProfile(userId);
      
      // If profile doesn't exist, create default one
      if (profile == null) {
        profile = UserProfile(
          userId: userId,
          bag1Name: 'All My Arsenal', // 預設第一個球袋名稱
          bag1Unlocked: true, // 預設開通第一個球袋
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        profile = await _repository.saveUserProfile(profile);
      }
      
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load user profile: $e',
      );
    }
  }

  /// Update bag name
  Future<void> updateBagName({
    required String userId,
    required int bagNumber,
    required String bagName,
  }) async {
    try {
      // 先設置載入狀態
      state = state.copyWith(isLoading: true, error: null);
      
      await _repository.updateBagName(
        userId: userId,
        bagNumber: bagNumber,
        bagName: bagName,
      );
      
      // Reload profile to get updated data
      await loadUserProfile(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update bag name: $e',
      );
      rethrow;
    }
  }

  /// Unlock a bag
  Future<void> unlockBag({
    required String userId,
    required int bagNumber,
    required String bagName,
  }) async {
    try {
      // 先設置載入狀態
      state = state.copyWith(isLoading: true, error: null);
      
      await _repository.unlockBag(
        userId: userId,
        bagNumber: bagNumber,
        bagName: bagName,
      );
      
      // Reload profile to get updated data
      await loadUserProfile(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to unlock bag: $e',
      );
      rethrow;
    }
  }

  /// Delete a bag
  Future<void> deleteBag({
    required String userId,
    required int bagNumber,
  }) async {
    try {
      // 先設置載入狀態
      state = state.copyWith(isLoading: true, error: null);
      
      await _repository.deleteBag(
        userId: userId,
        bagNumber: bagNumber,
      );
      
      // Reload profile to get updated data
      await loadUserProfile(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete bag: $e',
      );
      rethrow;
    }
  }

  /// Get unlocked bags
  Future<List<BagInfo>> getUnlockedBags(String userId) async {
    try {
      return await _repository.getUnlockedBags(userId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to get unlocked bags: $e');
      rethrow;
    }
  }

  /// Check if bag is unlocked
  bool isBagUnlocked(int bagNumber) {
    return state.profile?.isBagUnlocked(bagNumber) ?? false;
  }

  /// Get bag name
  String? getBagName(int bagNumber) {
    return state.profile?.getBagName(bagNumber);
  }

  /// Get unlocked bag count
  int get unlockedBagCount {
    return state.profile?.unlockedBagCount ?? 1;
  }

  /// Get next bag to unlock
  int? get nextBagToUnlock {
    return state.profile?.nextBagToUnlock;
  }
}