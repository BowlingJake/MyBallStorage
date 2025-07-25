// lib/services/user_preferences_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bowlingarsenal_app/shared/models/user_profile.dart';

class UserPreferencesService {
  static const _keyNickname = 'user_nickname';
  static const _keyHand = 'user_hand';
  static const _keyBallPath = 'user_ball_path';
  static const _keyPAP = 'user_pap';
  static const _keyCountry = 'user_country';
  static const _keyCity = 'user_city';
  static const _keyBowlingStyle = 'user_bowling_style';
  static const _keyFavoriteCenters = 'user_favorite_centers';
  static const _keyFavoriteOilPatterns = 'user_favorite_oil_patterns';

  Future<void> saveProfile({
    required String nickname,
    required String hand,
    required String ballPath,
    required String pap,
    String? country,
    String? city,
    String? bowlingStyle,
    List<String>? favoriteCenters,
    List<OilPattern>? favoriteOilPatterns,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..setString(_keyNickname, nickname)
      ..setString(_keyHand, hand)
      ..setString(_keyBallPath, ballPath)
      ..setString(_keyPAP, pap)
      ..setString(_keyCountry, country ?? '')
      ..setString(_keyCity, city ?? '')
      ..setString(_keyBowlingStyle, bowlingStyle ?? '')
      ..setString(_keyFavoriteCenters, jsonEncode(favoriteCenters ?? []))
      ..setString(_keyFavoriteOilPatterns, jsonEncode(
        (favoriteOilPatterns ?? []).map((pattern) => pattern.toJson()).toList()
      ));
  }

  Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> parseFavoriteCenters() {
      final centersJson = prefs.getString(_keyFavoriteCenters);
      if (centersJson == null || centersJson.isEmpty) return [];
      try {
        return List<String>.from(jsonDecode(centersJson));
      } catch (e) {
        return [];
      }
    }
    
    List<OilPattern> parseFavoriteOilPatterns() {
      final patternsJson = prefs.getString(_keyFavoriteOilPatterns);
      if (patternsJson == null || patternsJson.isEmpty) return [];
      try {
        final List<dynamic> patternsList = jsonDecode(patternsJson);
        return patternsList.map((patternJson) => OilPattern.fromJson(patternJson)).toList();
      } catch (e) {
        return [];
      }
    }
    
    return {
      'nickname': prefs.getString(_keyNickname),
      'hand': prefs.getString(_keyHand),
      'ballPath': prefs.getString(_keyBallPath),
      'pap': prefs.getString(_keyPAP),
      'country': prefs.getString(_keyCountry),
      'city': prefs.getString(_keyCity),
      'bowlingStyle': prefs.getString(_keyBowlingStyle),
      'favoriteCenters': parseFavoriteCenters(),
      'favoriteOilPatterns': parseFavoriteOilPatterns(),
    };
  }
}
