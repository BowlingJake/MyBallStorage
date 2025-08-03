import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    
    // 球袋名稱設定 (1-9)
    @JsonKey(name: 'bag_1_name') @Default('All My Arsenal') String bag1Name,
    @JsonKey(name: 'bag_2_name') String? bag2Name,
    @JsonKey(name: 'bag_3_name') String? bag3Name,
    @JsonKey(name: 'bag_4_name') String? bag4Name,
    @JsonKey(name: 'bag_5_name') String? bag5Name,
    @JsonKey(name: 'bag_6_name') String? bag6Name,
    @JsonKey(name: 'bag_7_name') String? bag7Name,
    @JsonKey(name: 'bag_8_name') String? bag8Name,
    @JsonKey(name: 'bag_9_name') String? bag9Name,
    
    // 球袋開通狀態 (1-9)
    @JsonKey(name: 'bag_1_unlocked') @Default(true) bool bag1Unlocked,
    @JsonKey(name: 'bag_2_unlocked') @Default(false) bool bag2Unlocked,
    @JsonKey(name: 'bag_3_unlocked') @Default(false) bool bag3Unlocked,
    @JsonKey(name: 'bag_4_unlocked') @Default(false) bool bag4Unlocked,
    @JsonKey(name: 'bag_5_unlocked') @Default(false) bool bag5Unlocked,
    @JsonKey(name: 'bag_6_unlocked') @Default(false) bool bag6Unlocked,
    @JsonKey(name: 'bag_7_unlocked') @Default(false) bool bag7Unlocked,
    @JsonKey(name: 'bag_8_unlocked') @Default(false) bool bag8Unlocked,
    @JsonKey(name: 'bag_9_unlocked') @Default(false) bool bag9Unlocked,
    
    // 其他用戶設定
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => 
      _$UserProfileFromJson(json);
}

extension UserProfileExtension on UserProfile {
  /// Get bag name for specific bag number (1-9)
  String? getBagName(int bagNumber) {
    switch (bagNumber) {
      case 1: return bag1Name;
      case 2: return bag2Name;
      case 3: return bag3Name;
      case 4: return bag4Name;
      case 5: return bag5Name;
      case 6: return bag6Name;
      case 7: return bag7Name;
      case 8: return bag8Name;
      case 9: return bag9Name;
      default: return null;
    }
  }
  
  /// Check if bag is unlocked for specific bag number (1-9)
  bool isBagUnlocked(int bagNumber) {
    switch (bagNumber) {
      case 1: return bag1Unlocked;
      case 2: return bag2Unlocked;
      case 3: return bag3Unlocked;
      case 4: return bag4Unlocked;
      case 5: return bag5Unlocked;
      case 6: return bag6Unlocked;
      case 7: return bag7Unlocked;
      case 8: return bag8Unlocked;
      case 9: return bag9Unlocked;
      default: return false;
    }
  }
  
  /// Get list of all unlocked bag numbers
  List<int> get unlockedBagNumbers {
    final bags = <int>[];
    for (int i = 1; i <= 9; i++) {
      if (isBagUnlocked(i)) {
        bags.add(i);
      }
    }
    return bags;
  }
  
  /// Get count of unlocked bags
  int get unlockedBagCount {
    return unlockedBagNumbers.length;
  }
  
  /// Get the next bag number that can be unlocked
  /// 袋子必須按順序開通：1 -> 2 -> 3 -> ... -> 9
  int? get nextBagToUnlock {
    for (int i = 2; i <= 9; i++) { // 從袋子2開始，因為袋子1預設已開通
      if (!isBagUnlocked(i)) {
        // 檢查前一個袋子是否已開通
        if (i == 2 || isBagUnlocked(i - 1)) {
          return i;
        }
        // 如果前一個袋子未開通，則不能開通這個袋子
        break;
      }
    }
    return null; // All bags are unlocked or sequence is blocked
  }
  
  /// Get list of unlocked bag names with their numbers
  List<BagInfo> get unlockedBags {
    return unlockedBagNumbers.map((bagNumber) {
      return BagInfo(
        number: bagNumber,
        name: getBagName(bagNumber) ?? 'Bag $bagNumber',
        isUnlocked: true,
      );
    }).toList();
  }
}

/// Helper class for bag information
@freezed
class BagInfo with _$BagInfo {
  const factory BagInfo({
    required int number,
    required String name,
    required bool isUnlocked,
  }) = _BagInfo;
  
  factory BagInfo.fromJson(Map<String, dynamic> json) => _$BagInfoFromJson(json);
}