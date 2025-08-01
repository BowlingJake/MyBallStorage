import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_analytics.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/arsenal_controller.dart';

part 'analytics_controller.g.dart';

/// State for analytics management
class AnalyticsState {
  final ArsenalAnalytics? analytics;
  final bool isLoading;
  final String? error;

  const AnalyticsState({
    this.analytics,
    this.isLoading = false,
    this.error,
  });

  AnalyticsState copyWith({
    ArsenalAnalytics? analytics,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Analytics controller
@riverpod
class AnalyticsController extends _$AnalyticsController {
  @override
  AnalyticsState build() {
    return const AnalyticsState();
  }

  ArsenalRepository get _repository => ref.read(arsenalRepositoryProvider);

  /// Load analytics for user
  Future<void> loadAnalytics(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final analytics = await _repository.getArsenalAnalytics(userId);
      state = state.copyWith(analytics: analytics, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load analytics: $e',
      );
    }
  }

  /// Refresh analytics data
  Future<void> refreshAnalytics(String userId) async {
    await loadAnalytics(userId);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider to get RG/Diff data points for charting
@riverpod
List<BallDataPoint> rgDiffDataPoints(RgDiffDataPointsRef ref) {
  final analyticsState = ref.watch(analyticsControllerProvider);
  return analyticsState.analytics?.rgDiffDistribution.dataPoints ?? [];
}

/// Provider to get brand distribution data
@riverpod
Map<String, int> brandDistribution(BrandDistributionRef ref) {
  final analyticsState = ref.watch(analyticsControllerProvider);
  return analyticsState.analytics?.brandDistribution ?? {};
}

/// Provider to get configuration balance score
@riverpod
double configurationScore(ConfigurationScoreRef ref) {
  final analyticsState = ref.watch(analyticsControllerProvider);
  return analyticsState.analytics?.configurationScore ?? 0.0;
}

/// Provider to get missing quadrants
@riverpod
List<BallQuadrant> missingQuadrants(MissingQuadrantsRef ref) {
  final analyticsState = ref.watch(analyticsControllerProvider);
  return analyticsState.analytics?.missingQuadrants ?? [];
}

/// Provider to get recommendations
@riverpod
List<String> arsenalRecommendations(ArsenalRecommendationsRef ref) {
  final analyticsState = ref.watch(analyticsControllerProvider);
  return analyticsState.analytics?.recommendations ?? [];
}