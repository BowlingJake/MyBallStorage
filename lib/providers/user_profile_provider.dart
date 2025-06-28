import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/user_preferences_service.dart';

// 使用者檔案狀態管理
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    loadProfile();
  }

  final _userService = UserPreferencesService();

  Future<void> loadProfile() async {
    try {
      final profileData = await _userService.loadProfile();
      if (profileData['nickname'] != null && profileData['nickname']!.isNotEmpty) {
        state = UserProfile(
          nickname: profileData['nickname']!,
          hand: profileData['hand'] ?? '',
          ballPath: profileData['ballPath'] ?? '',
          pap: profileData['pap'] ?? '',
        );
      } else {
        state = null;
      }
    } catch (e) {
      state = null;
      // 處理載入錯誤
    }
  }

  Future<void> updateProfile({
    String? nickname,
    String? hand,
    String? ballPath,
    String? pap,
  }) async {
    final newProfile = UserProfile(
      nickname: nickname ?? state?.nickname ?? '',
      hand: hand ?? state?.hand ?? '',
      ballPath: ballPath ?? state?.ballPath ?? '',
      pap: pap ?? state?.pap ?? '',
    );

    await _userService.saveProfile(
      nickname: newProfile.nickname,
      hand: newProfile.hand,
      ballPath: newProfile.ballPath,
      pap: newProfile.pap,
    );

    state = newProfile;
  }

  bool get isProfileComplete {
    return state != null && 
           state!.nickname.isNotEmpty && 
           state!.hand.isNotEmpty;
  }
}

// Provider 定義
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
}); 