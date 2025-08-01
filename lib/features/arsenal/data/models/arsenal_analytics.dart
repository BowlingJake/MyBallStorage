import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';

part 'arsenal_analytics.freezed.dart';
part 'arsenal_analytics.g.dart';

@freezed
class ArsenalAnalytics with _$ArsenalAnalytics {
  const factory ArsenalAnalytics({
    required String userId,
    required int totalBalls,
    required int customBalls,
    required Map<String, int> brandDistribution,
    required Map<String, int> categoryDistribution,
    required Map<String, int> layoutTypeDistribution,
    required RGDiffDistribution rgDiffDistribution,
    required DateTime lastUpdated,
  }) = _ArsenalAnalytics;

  factory ArsenalAnalytics.fromJson(Map<String, dynamic> json) => 
      _$ArsenalAnalyticsFromJson(json);
}

@freezed
class RGDiffDistribution with _$RGDiffDistribution {
  const factory RGDiffDistribution({
    required List<BallDataPoint> dataPoints,
    required double avgRG,
    required double avgDiff,
    required double minRG,
    required double maxRG,
    required double minDiff,
    required double maxDiff,
  }) = _RGDiffDistribution;

  factory RGDiffDistribution.fromJson(Map<String, dynamic> json) => 
      _$RGDiffDistributionFromJson(json);
}

@freezed
class BallDataPoint with _$BallDataPoint {
  const factory BallDataPoint({
    required String instanceId,
    required String ballName,
    required String brand,
    required double rg,
    required double diff,
    required BallQuadrant quadrant,
  }) = _BallDataPoint;

  factory BallDataPoint.fromJson(Map<String, dynamic> json) => 
      _$BallDataPointFromJson(json);
}

@JsonEnum()
enum BallQuadrant {
  @JsonValue('hook_monster')
  hookMonster('強勾球', '低RG, 高Diff'),
  
  @JsonValue('length_hook')
  lengthHook('長距離強勾', '高RG, 高Diff'),
  
  @JsonValue('control')
  control('控制型', '低RG, 低Diff'),
  
  @JsonValue('straight')
  straight('直球型', '高RG, 低Diff');

  const BallQuadrant(this.displayName, this.description);

  final String displayName;
  final String description;
}

extension ArsenalAnalyticsExtension on ArsenalAnalytics {
  /// Calculate ball configuration balance score (0-100)
  double get configurationScore {
    final quadrantCounts = <BallQuadrant, int>{};
    
    for (final point in rgDiffDistribution.dataPoints) {
      quadrantCounts[point.quadrant] = (quadrantCounts[point.quadrant] ?? 0) + 1;
    }
    
    // Ideal distribution would be roughly equal across quadrants
    final totalBalls = rgDiffDistribution.dataPoints.length;
    if (totalBalls == 0) return 0;
    
    final idealPerQuadrant = totalBalls / 4;
    double deviationSum = 0;
    
    for (final quadrant in BallQuadrant.values) {
      final count = quadrantCounts[quadrant] ?? 0;
      deviationSum += (count - idealPerQuadrant).abs();
    }
    
    // Convert to 0-100 score (lower deviation = higher score)
    final maxDeviation = totalBalls;
    return ((maxDeviation - deviationSum) / maxDeviation * 100).clamp(0, 100);
  }
  
  /// Get the most represented brand
  String get topBrand {
    if (brandDistribution.isEmpty) return 'N/A';
    return brandDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// Get missing quadrants (areas where user has no balls)
  List<BallQuadrant> get missingQuadrants {
    final presentQuadrants = rgDiffDistribution.dataPoints
        .map((point) => point.quadrant)
        .toSet();
    
    return BallQuadrant.values
        .where((quadrant) => !presentQuadrants.contains(quadrant))
        .toList();
  }
  
  /// Get recommendations based on current arsenal
  List<String> get recommendations {
    final recommendations = <String>[];
    final missing = missingQuadrants;
    
    if (missing.contains(BallQuadrant.hookMonster)) {
      recommendations.add('考慮添加強勾型球具來處理重油球道');
    }
    if (missing.contains(BallQuadrant.straight)) {
      recommendations.add('考慮添加直球型球具來處理輕油球道');
    }
    if (missing.contains(BallQuadrant.control)) {
      recommendations.add('考慮添加控制型球具來平衡您的配置');
    }
    if (missing.contains(BallQuadrant.lengthHook)) {
      recommendations.add('考慮添加長距離強勾型球具來處理中油球道');
    }
    
    if (customBalls > totalBalls * 0.3) {
      recommendations.add('您有很多自定義球具，考慮整理和更新資訊');
    }
    
    return recommendations;
  }
}

extension BallDataPointExtension on BallDataPoint {
  /// Determine quadrant based on RG and Diff values
  static BallQuadrant determineQuadrant(double rg, double diff) {
    // These thresholds can be adjusted based on typical bowling ball specs
    const rgThreshold = 2.55; // Typical threshold between low and high RG
    const diffThreshold = 0.045; // Typical threshold between low and high Diff
    
    if (rg < rgThreshold && diff > diffThreshold) {
      return BallQuadrant.hookMonster;
    } else if (rg >= rgThreshold && diff > diffThreshold) {
      return BallQuadrant.lengthHook;
    } else if (rg < rgThreshold && diff <= diffThreshold) {
      return BallQuadrant.control;
    } else {
      return BallQuadrant.straight;
    }
  }
  
  /// Create BallDataPoint from ArsenalBallInstance
  static BallDataPoint fromArsenalBall(ArsenalBallInstance instance) {
    final ball = instance.bowlingBall;
    final rg = ball?.rg ?? 2.5;
    final diff = ball?.diff ?? 0.04;
    
    return BallDataPoint(
      instanceId: instance.instanceId,
      ballName: ball?.name ?? 'Unknown Ball',
      brand: ball?.brand ?? 'Unknown Brand',
      rg: rg,
      diff: diff,
      quadrant: BallDataPointExtension.determineQuadrant(rg, diff),
    );
  }
}