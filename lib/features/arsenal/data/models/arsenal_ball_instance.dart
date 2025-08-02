import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';

part 'arsenal_ball_instance.freezed.dart';
part 'arsenal_ball_instance.g.dart';

@freezed
class ArsenalBallInstance with _$ArsenalBallInstance {
  const factory ArsenalBallInstance({
    @JsonKey(name: 'instance_id') required String instanceId,
    @JsonKey(name: 'ball_id') required String ballId,
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String nickname,
    @JsonKey(name: 'added_date') required DateTime addedDate,
    @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
    @JsonKey(name: 'bag_category_id') required String bagCategoryId,
    BallLayout? layout,
    @JsonKey(name: 'instance_number') @Default(1) int instanceNumber,
    String? notes,
    
    // Usage tracking
    @JsonKey(name: 'games_used') @Default(0) int gamesUsed,
    
    // Reference to the base bowling ball data - stored as JSON map for serialization
    @JsonKey(name: 'bowling_ball_data') 
    @BowlingBallConverter() 
    BowlingBall? bowlingBall,
    
    // Custom ball data (for user-created balls)
    @JsonKey(name: 'is_custom_ball') @Default(false) bool isCustomBall,
    @JsonKey(name: 'local_image_path') String? localImagePath,
  }) = _ArsenalBallInstance;

  factory ArsenalBallInstance.fromJson(Map<String, dynamic> json) => 
      _$ArsenalBallInstanceFromJson(json);
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

extension ArsenalBallInstanceExtension on ArsenalBallInstance {
  /// Get display name with nickname if available
  String get displayName {
    if (nickname.isNotEmpty) {
      return '$nickname (${bowlingBall?.name ?? 'Unknown Ball'})';
    }
    return bowlingBall?.name ?? 'Unknown Ball';
  }
  
  /// Get the effective image URL
  String get effectiveImageUrl {
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return localImagePath!;
    }
    return bowlingBall?.imageUrl ?? 'https://via.placeholder.com/150';
  }
  
  /// Check if this ball has layout information
  bool get hasLayout => layout != null;
  
  /// Get the brand name
  String get brandName => bowlingBall?.brand ?? 'Unknown Brand';
}