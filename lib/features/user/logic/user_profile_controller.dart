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

  /// Update user profile information
  Future<void> updateProfile({
    required String userId,
    String? nickname,
    String? avatarUrl,
    String? country,
    String? city,
    String? dominateHand,
    String? style,
    int? papInteger,
    String? papFraction,
    int? papDirection, // 0=none, 1=up, -1=down
    int? papDriftInteger,
    String? papDriftFraction,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedProfile = await _repository.updateProfile(
        userId: userId,
        nickname: nickname,
        avatarUrl: avatarUrl,
        country: country,
        city: city,
        dominateHand: dominateHand,
        style: style,
        papInteger: papInteger,
        papFraction: papFraction,
        papDirection: papDirection,
        papDriftInteger: papDriftInteger,
        papDriftFraction: papDriftFraction,
      );
      
      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile: $e',
      );
      rethrow;
    }
  }

  /// Update bag name
  Future<void> updateBagName({
    required String userId,
    required int bagNumber,
    required String bagName,
  }) async {
    // 驗證輸入參數
    if (!_validateBagNumber(bagNumber)) {
      throw ArgumentError('Invalid bag number: $bagNumber. Must be between 1-9.');
    }
    
    if (!_validateBagName(bagName)) {
      throw ArgumentError('Invalid bag name. Must be 1-20 characters long.');
    }
    
    // 檢查球袋是否已解鎖
    if (!isBagUnlocked(bagNumber)) {
      throw StateError('Cannot update name for locked bag $bagNumber');
    }
    
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
    // 驗證輸入參數
    if (!_validateBagNumber(bagNumber)) {
      throw ArgumentError('Invalid bag number: $bagNumber. Must be between 1-9.');
    }
    
    if (!_validateBagName(bagName)) {
      throw ArgumentError('Invalid bag name. Must be 1-20 characters long.');
    }
    
    // 檢查球袋是否已解鎖
    if (isBagUnlocked(bagNumber)) {
      throw StateError('Bag $bagNumber is already unlocked');
    }
    
    // 檢查是否符合解鎖順序
    if (nextBagToUnlock != bagNumber) {
      throw StateError('Cannot unlock bag $bagNumber. Next bag to unlock is ${nextBagToUnlock ?? "none"}');
    }
    
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
    // 驗證輸入參數
    if (!_validateBagNumber(bagNumber)) {
      throw ArgumentError('Invalid bag number: $bagNumber. Must be between 1-9.');
    }
    
    // 禁止刪除第一個球袋
    if (bagNumber == 1) {
      throw StateError('Cannot delete the main bag (Bag 1)');
    }
    
    // 檢查球袋是否已解鎖
    if (!isBagUnlocked(bagNumber)) {
      throw StateError('Cannot delete locked bag $bagNumber');
    }
    
    // 檢查是否為最後一個解鎖的球袋（保持順序性）
    if (!_canDeleteBag(bagNumber)) {
      throw StateError('Cannot delete bag $bagNumber. You can only delete the most recently unlocked bag.');
    }
    
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

  /// 驗證球袋編號是否有效 (1-9)
  bool _validateBagNumber(int bagNumber) {
    return bagNumber >= 1 && bagNumber <= 9;
  }

  /// 驗證球袋名稱是否有效
  bool _validateBagName(String bagName) {
    final trimmed = bagName.trim();
    return trimmed.isNotEmpty && trimmed.length <= 20;
  }

  /// 檢查是否可以刪除指定球袋（只能刪除最後解鎖的球袋）
  bool _canDeleteBag(int bagNumber) {
    if (state.profile == null) return false;
    
    final unlockedBags = state.profile!.unlockedBagNumbers;
    if (unlockedBags.isEmpty) return false;
    
    // 只能刪除最後一個解鎖的球袋
    final lastUnlockedBag = unlockedBags.last;
    return bagNumber == lastUnlockedBag;
  }

  /// 取得球袋使用狀態統計
  Map<String, dynamic> getBagStatistics() {
    if (state.profile == null) {
      return {
        'totalBags': 1,
        'unlockedBags': 1,
        'lockedBags': 8,
        'unlockProgress': 1.0 / 9.0,
      };
    }
    
    final unlockedCount = state.profile!.unlockedBagCount;
    
    return {
      'totalBags': 9,
      'unlockedBags': unlockedCount,
      'lockedBags': 9 - unlockedCount,
      'unlockProgress': unlockedCount / 9.0,
    };
  }
}