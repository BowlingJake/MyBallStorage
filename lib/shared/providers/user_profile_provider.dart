import 'package:bowlingarsenal_app/shared/models/user_profile.dart';
import 'package:bowlingarsenal_app/services/user_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 使用者檔案狀態管理
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    loadProfile();
  }

  final _userService = UserPreferencesService();

  Future<void> loadProfile() async {
    try {
      final profileData = await _userService.loadProfile();
      if (profileData['nickname'] != null &&
          profileData['nickname']!.isNotEmpty) {
        state = UserProfile(
          nickname: profileData['nickname']!,
          hand: profileData['hand'] ?? '',
          ballPath: profileData['ballPath'] ?? '',
          pap: profileData['pap'] ?? '',
          country: profileData['country'] ?? '',
          city: profileData['city'] ?? '',
          bowlingStyle: profileData['bowlingStyle'] ?? '',
          favoriteCenters: profileData['favoriteCenters'] ?? [],
          favoriteOilPatterns: profileData['favoriteOilPatterns'] ?? [],
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
    String? country,
    String? city,
    String? bowlingStyle,
    List<String>? favoriteCenters,
    List<OilPattern>? favoriteOilPatterns,
  }) async {
    final newProfile = UserProfile(
      nickname: nickname ?? state?.nickname ?? '',
      hand: hand ?? state?.hand ?? '',
      ballPath: ballPath ?? state?.ballPath ?? '',
      pap: pap ?? state?.pap ?? '',
      country: country ?? state?.country ?? '',
      city: city ?? state?.city ?? '',
      bowlingStyle: bowlingStyle ?? state?.bowlingStyle ?? '',
      favoriteCenters: favoriteCenters ?? state?.favoriteCenters ?? [],
      favoriteOilPatterns: favoriteOilPatterns ?? state?.favoriteOilPatterns ?? [],
    );

    await _userService.saveProfile(
      nickname: newProfile.nickname,
      hand: newProfile.hand,
      ballPath: newProfile.ballPath,
      pap: newProfile.pap,
      country: newProfile.country,
      city: newProfile.city,
      bowlingStyle: newProfile.bowlingStyle,
      favoriteCenters: newProfile.favoriteCenters,
      favoriteOilPatterns: newProfile.favoriteOilPatterns,
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
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
      return UserProfileNotifier();
    });
