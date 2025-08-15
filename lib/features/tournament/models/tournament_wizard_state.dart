import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_wizard_state.freezed.dart';

@freezed
class TournamentWizardState with _$TournamentWizardState {
  const factory TournamentWizardState({
    // Step 1: Basic Information
    @Default('') String tournamentName,
    DateTime? startDate,
    DateTime? endDate,
    @Default(TournamentDateMode.singleDay) TournamentDateMode dateMode,
    @Default([]) List<DateTime> nonContinuousDates,
    @Default('') String location,
    @Default(false) bool useCustomLocation,
    
    // Step 2: Tournament Configuration
    @Default('') String oilPatternName,
    @Default('') String oilPatternLength,
    @Default(true) bool isHousePattern,
    @Default('') String entryFee,
    @Default('') String prizeInfo,
    @Default('recreational') String tournamentType, // recreational, competitive, professional
    
    // Step 3: Smart Recommendations
    @Default([]) List<String> recommendedBalls,
    @Default('') String strategyRecommendation,
    @Default(false) bool analysisCompleted,
    
    // UI State
    @Default(1) int currentStep,
    @Default(false) bool isStep1Valid,
    @Default(false) bool isStep2Valid,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
  }) = _TournamentWizardState;
}

enum TournamentDateMode {
  singleDay,
  continuous,
  nonContinuous,
}

@freezed
class TournamentRecommendation with _$TournamentRecommendation {
  const factory TournamentRecommendation({
    required String ballName,
    required String reason,
    required double confidenceScore,
    @Default(false) bool isSelected,
  }) = _TournamentRecommendation;
}