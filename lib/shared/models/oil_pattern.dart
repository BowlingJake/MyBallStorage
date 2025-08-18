import 'package:freezed_annotation/freezed_annotation.dart';

part 'oil_pattern.freezed.dart';
part 'oil_pattern.g.dart';

/// 油圖類型枚舉
enum PatternType {
  sport,
  house,
  challenge,
  tournament,
  other;
  
  String get displayName {
    switch (this) {
      case PatternType.sport:
        return 'Sport Pattern';
      case PatternType.house:
        return 'House Pattern';
      case PatternType.challenge:
        return 'Challenge Pattern';
      case PatternType.tournament:
        return 'Tournament Pattern';
      case PatternType.other:
        return 'Other';
    }
  }
}

/// 油圖資訊模型
@freezed
class OilPattern with _$OilPattern {
  const factory OilPattern({
    String? id,
    required String name,
    int? length,
    int? volume,
    @JsonKey(name: 'difficulty_level') int? difficultyLevel,
    String? description,
    @JsonKey(name: 'pattern_type') @Default('house') String patternType,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OilPattern;

  factory OilPattern.fromJson(Map<String, dynamic> json) => 
      _$OilPatternFromJson(json);
}

extension OilPatternExtension on OilPattern {
  /// 獲取油圖類型枚舉
  PatternType get patternTypeEnum {
    switch (patternType.toLowerCase()) {
      case 'sport':
        return PatternType.sport;
      case 'house':
        return PatternType.house;
      case 'challenge':
        return PatternType.challenge;
      case 'tournament':
        return PatternType.tournament;
      default:
        return PatternType.other;
    }
  }
  
  /// 獲取難度等級描述
  String get difficultyDescription {
    if (difficultyLevel == null) return 'Unknown';
    
    if (difficultyLevel! <= 3) return 'Easy';
    if (difficultyLevel! <= 6) return 'Medium';
    if (difficultyLevel! <= 8) return 'Hard';
    return 'Expert';
  }
  
  /// 獲取完整描述
  String get fullDescription {
    final parts = <String>[name];
    
    if (length != null) parts.add('${length}ft');
    if (volume != null) parts.add('${volume}ml');
    if (difficultyLevel != null) parts.add('Level $difficultyLevel');
    
    return parts.join(' • ');
  }
}

/// 用戶喜好油圖模型
@freezed
class UserFavoritePattern with _$UserFavoritePattern {
  const factory UserFavoritePattern({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'oil_pattern_id') required String oilPatternId,
    String? notes,
    @JsonKey(name: 'performance_rating') int? performanceRating,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    
    // 關聯的油圖資訊（來自 JOIN 查詢）
    @JsonKey(name: 'oil_pattern') OilPattern? oilPattern,
  }) = _UserFavoritePattern;

  factory UserFavoritePattern.fromJson(Map<String, dynamic> json) => 
      _$UserFavoritePatternFromJson(json);
}

extension UserFavoritePatternExtension on UserFavoritePattern {
  /// 獲取評分星級描述
  String get ratingDescription {
    if (performanceRating == null) return 'Not rated';
    
    switch (performanceRating!) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent';
      default: return 'Unknown';
    }
  }
  
  /// 獲取星級圖示
  String get ratingStars {
    if (performanceRating == null) return '☆☆☆☆☆';
    
    final filled = '★' * performanceRating!;
    final empty = '☆' * (5 - performanceRating!);
    return filled + empty;
  }
}