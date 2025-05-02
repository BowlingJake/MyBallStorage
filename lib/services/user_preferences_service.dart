// lib/services/user_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const _keyNickname = 'user_nickname';
  static const _keyHand = 'user_hand';
  static const _keyBallPath = 'user_ball_path';
  static const _keyPAP = 'user_pap';

  Future<void> saveProfile({
    required String nickname,
    required String hand,
    required String ballPath,
    required String pap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
      ..setString(_keyNickname, nickname)
      ..setString(_keyHand, hand)
      ..setString(_keyBallPath, ballPath)
      ..setString(_keyPAP, pap);
  }

  Future<Map<String, String?>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nickname': prefs.getString(_keyNickname),
      'hand': prefs.getString(_keyHand),
      'ballPath': prefs.getString(_keyBallPath),
      'pap': prefs.getString(_keyPAP),
    };
  }
}
