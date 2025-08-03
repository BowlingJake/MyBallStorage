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
    
    // 球袋分類 (最多9個)
    @JsonKey(name: 'bag_category_1') String? bagCategory1,
    @JsonKey(name: 'bag_category_2') String? bagCategory2,
    @JsonKey(name: 'bag_category_3') String? bagCategory3,
    @JsonKey(name: 'bag_category_4') String? bagCategory4,
    @JsonKey(name: 'bag_category_5') String? bagCategory5,
    @JsonKey(name: 'bag_category_6') String? bagCategory6,
    @JsonKey(name: 'bag_category_7') String? bagCategory7,
    @JsonKey(name: 'bag_category_8') String? bagCategory8,
    @JsonKey(name: 'bag_category_9') String? bagCategory9,
    
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
  
  /// Get all categories this ball belongs to
  List<String> get allCategories {
    return [
      bagCategory1,
      bagCategory2,
      bagCategory3,
      bagCategory4,
      bagCategory5,
      bagCategory6,
      bagCategory7,
      bagCategory8,
      bagCategory9,
    ].where((category) => category != null && category.isNotEmpty).cast<String>().toList();
  }
  
  /// Check if ball belongs to specific category
  bool belongsToCategory(String categoryName) {
    return allCategories.contains(categoryName);
  }
  
  /// Get layout display string
  String get layoutDisplayString {
    if (!hasLayout || layoutType == null) return 'No Layout';
    
    final v1 = layoutValue1?.toStringAsFixed(1) ?? '0.0';
    final v2 = layoutValue2?.toStringAsFixed(1) ?? '0.0';
    final v3 = layoutValue3?.toStringAsFixed(1) ?? '0.0';
    
    if (layoutType == 'VLS') {
      return 'VLS: ${v1}" x ${v2}" x ${v3}°';
    } else if (layoutType == 'DUAL_ANGLE') {
      return 'Dual: ${v1}° x ${v2}" x ${v3}°';
    }
    
    return 'Layout: $v1 x $v2 x $v3';
  }
}