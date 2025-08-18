import 'package:freezed_annotation/freezed_annotation.dart';

part 'bowling_center.freezed.dart';
part 'bowling_center.g.dart';

/// 球館資訊模型
@freezed
class BowlingCenter with _$BowlingCenter {
  const factory BowlingCenter({
    String? id,
    required String name,
    String? address,
    String? city,
    String? country,
    String? phone,
    String? website,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BowlingCenter;

  factory BowlingCenter.fromJson(Map<String, dynamic> json) => 
      _$BowlingCenterFromJson(json);
}

/// 用戶喜好球館模型
@freezed
class UserFavoriteCenter with _$UserFavoriteCenter {
  const factory UserFavoriteCenter({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'bowling_center_id') required String bowlingCenterId,
    String? notes,
    @JsonKey(name: 'visit_count') @Default(0) int visitCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    
    // 關聯的球館資訊（來自 JOIN 查詢）
    @JsonKey(name: 'bowling_center') BowlingCenter? bowlingCenter,
  }) = _UserFavoriteCenter;

  factory UserFavoriteCenter.fromJson(Map<String, dynamic> json) => 
      _$UserFavoriteCenterFromJson(json);
}