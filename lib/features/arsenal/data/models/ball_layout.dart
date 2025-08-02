import 'package:freezed_annotation/freezed_annotation.dart';

part 'ball_layout.freezed.dart';
part 'ball_layout.g.dart';

@freezed
class BallLayout with _$BallLayout {
  const factory BallLayout({
    @JsonKey(name: 'layout_id') required String layoutId,
    @JsonKey(name: 'user_id') required String userId,
    
    // Layout measurements (in inches)
    @JsonKey(name: 'pin_to_pap') @Default(0.0) double pinToPap,        // Pin到PAP距離
    @JsonKey(name: 'pap_to_mb') @Default(0.0) double papToMb,         // PAP到MB距離  
    @JsonKey(name: 'psa_angle') @Default(0.0) double psaAngle,        // PSA角度 (度)
    @JsonKey(name: 'val_angle') @Default(0.0) double valAngle,        // VAL角度 (度)
    
    // Layout classification
    @JsonKey(name: 'layout_type') @Default(LayoutType.control) LayoutType layoutType,
    
    // Additional layout information
    @JsonKey(name: 'layout_image') String? layoutImage,                   // 鑽法圖片URL或本地路徑
    @JsonKey(name: 'driller_name') String? drillerName,                   // 鑽球師名稱
    @JsonKey(name: 'drilled_date') DateTime? drilledDate,                 // 鑽球日期
    String? notes,                         // 備註
    
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BallLayout;

  factory BallLayout.fromJson(Map<String, dynamic> json) => 
      _$BallLayoutFromJson(json);
}

@JsonEnum()
enum LayoutType {
  @JsonValue('aggressive')
  aggressive('強勾型', '適合重油、需要強烈後端反應'),
  
  @JsonValue('control')
  control('控制型', '平衡的長度和後端反應'),
  
  @JsonValue('straight')
  straight('直球型', '最小的側向移動，適合補中'),
  
  @JsonValue('skid_flip')
  skidFlip('滑行翻轉型', '長距離滑行後強烈翻轉'),
  
  @JsonValue('smooth_arc')
  smoothArc('平滑弧線型', '漸進式的連續弧線'),
  
  @JsonValue('length')
  length('長距離型', '延後反應點，適合短油');

  const LayoutType(this.displayName, this.description);

  final String displayName;
  final String description;
}

extension BallLayoutExtension on BallLayout {
  /// Check if layout has complete drilling information
  bool get hasCompleteInfo {
    return pinToPap > 0 && papToMb > 0;
  }
  
  /// Get layout summary string
  String get layoutSummary {
    if (!hasCompleteInfo) return '未設定鑽法';
    
    return 'Pin-PAP: ${pinToPap.toStringAsFixed(1)}" | '
           'PAP-MB: ${papToMb.toStringAsFixed(1)}" | '
           'PSA: ${psaAngle.toStringAsFixed(0)}°';
  }
  
  /// Get layout classification description
  String get typeDescription => layoutType.description;
  
  /// Check if layout is aggressive (short pin distance)
  bool get isAggressive {
    return pinToPap > 0 && pinToPap <= 3.5;
  }
  
  /// Check if layout is control oriented
  bool get isControl {
    return pinToPap > 3.5 && pinToPap <= 5.0;
  }
  
  /// Check if layout is length oriented  
  bool get isLength {
    return pinToPap > 5.0;
  }
  
  /// Get recommended use case based on measurements
  String get recommendedUse {
    if (pinToPap <= 3.5) {
      return '重油球道、需要強烈後端反應';
    } else if (pinToPap <= 5.0) {
      return '中油球道、平衡型表現';
    } else {
      return '輕油球道、需要長距離滑行';
    }
  }
}