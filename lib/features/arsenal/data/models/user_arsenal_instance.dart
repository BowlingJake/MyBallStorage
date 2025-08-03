import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

part 'user_arsenal_instance.freezed.dart';
part 'user_arsenal_instance.g.dart';

@freezed
class UserArsenalInstance with _$UserArsenalInstance {
  const factory UserArsenalInstance({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'ball_id') required int ballId,
    String? notes,
    @JsonKey(name: 'added_date') required DateTime addedDate,
    @JsonKey(name: 'games_used') @Default(0) int gamesUsed,
    
    // 球袋分配 (Boolean: true=在該袋中, false=不在, null=袋子未開通)
    @JsonKey(name: 'bag_1') bool? bag1,
    @JsonKey(name: 'bag_2') bool? bag2,
    @JsonKey(name: 'bag_3') bool? bag3,
    @JsonKey(name: 'bag_4') bool? bag4,
    @JsonKey(name: 'bag_5') bool? bag5,
    @JsonKey(name: 'bag_6') bool? bag6,
    @JsonKey(name: 'bag_7') bool? bag7,
    @JsonKey(name: 'bag_8') bool? bag8,
    @JsonKey(name: 'bag_9') bool? bag9,
    
    // Layout 信息
    @JsonKey(name: 'has_layout') @Default(false) bool hasLayout,
    @JsonKey(name: 'layout_type') String? layoutType, // 'VLS' 或 'DUAL_ANGLE'
    @JsonKey(name: 'layout_value_1') double? layoutValue1,
    @JsonKey(name: 'layout_value_2') double? layoutValue2,
    @JsonKey(name: 'layout_value_3') double? layoutValue3,
    
    // 關聯的球數據 (從JOIN獲取，不存在數據庫中)
    @JsonKey(name: 'bowling_ball_data') 
    @BowlingBallConverter() 
    BowlingBall? bowlingBall,
  }) = _UserArsenalInstance;

  factory UserArsenalInstance.fromJson(Map<String, dynamic> json) => 
      _$UserArsenalInstanceFromJson(json);
}

/// Custom converter for BowlingBall serialization
class BowlingBallConverter implements JsonConverter<BowlingBall?, Map<String, dynamic>?> {
  const BowlingBallConverter();

  @override
  BowlingBall? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return BowlingBall.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(BowlingBall? bowlingBall) {
    if (bowlingBall == null) return null;
    return bowlingBall.toJsonWithCustomFields();
  }
}

extension UserArsenalInstanceExtension on UserArsenalInstance {
  /// Get display name for the ball
  String get displayName {
    return bowlingBall?.name ?? 'Unknown Ball';
  }
  
  /// Get the effective image URL
  String get effectiveImageUrl {
    return bowlingBall?.imageUrl ?? 'https://via.placeholder.com/150';
  }
  
  /// Get the brand name
  String get brandName => bowlingBall?.brand ?? 'Unknown Brand';
  
  /// Get all bag numbers this ball belongs to
  List<int> get activeBagNumbers {
    final bags = <int>[];
    if (bag1 == true) bags.add(1);
    if (bag2 == true) bags.add(2);
    if (bag3 == true) bags.add(3);
    if (bag4 == true) bags.add(4);
    if (bag5 == true) bags.add(5);
    if (bag6 == true) bags.add(6);
    if (bag7 == true) bags.add(7);
    if (bag8 == true) bags.add(8);
    if (bag9 == true) bags.add(9);
    return bags;
  }
  
  /// Check if ball is in specific bag number
  bool isInBag(int bagNumber) {
    switch (bagNumber) {
      case 1: return bag1 == true;
      case 2: return bag2 == true;
      case 3: return bag3 == true;
      case 4: return bag4 == true;
      case 5: return bag5 == true;
      case 6: return bag6 == true;
      case 7: return bag7 == true;
      case 8: return bag8 == true;
      case 9: return bag9 == true;
      default: return false;
    }
  }
  
  /// Get bag status for specific bag number (true/false/null)
  bool? getBagStatus(int bagNumber) {
    switch (bagNumber) {
      case 1: return bag1;
      case 2: return bag2;
      case 3: return bag3;
      case 4: return bag4;
      case 5: return bag5;
      case 6: return bag6;
      case 7: return bag7;
      case 8: return bag8;
      case 9: return bag9;
      default: return null;
    }
  }

  /// Get all categories this ball belongs to (for backward compatibility)
  /// 注意：這個方法現在返回球袋名稱而不是分類名稱
  List<String> get allCategories {
    // 這個方法暫時返回空列表，因為現在需要UserProfile來獲取球袋名稱
    // 實際使用時應該通過Controller層來獲取球袋名稱
    return [];
  }
  
  /// Check if ball belongs to specific category (for backward compatibility)  
  /// 注意：這個方法現在檢查球袋名稱而不是分類名稱
  bool belongsToCategory(String categoryName) {
    // 這個方法暫時返回false，因為現在需要UserProfile來比對球袋名稱
    // 實際使用時應該通過Controller層來檢查
    return false;
  }
  
  /// Get layout display string
  String get layoutDisplayString {
    if (!hasLayout || layoutType == null) return 'Layout Not Set';
    
    final v1 = layoutValue1?.toStringAsFixed(1) ?? '0.0';
    final v2 = layoutValue2?.toStringAsFixed(1) ?? '0.0';
    final v3 = layoutValue3?.toStringAsFixed(1) ?? '0.0';
    
    if (layoutType == 'VLS') {
      return 'VLS(2LS): ${v1}" x ${v2}" x ${v3}"';
    } else if (layoutType == 'DUAL_ANGLE') {
      return 'Dual Angle: ${v1}° x ${v2}" x ${v3}°';
    }
    
    return 'Layout: $v1 x $v2 x $v3';
  }
}