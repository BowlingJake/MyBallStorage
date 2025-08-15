import 'package:bowlingarsenal_app/features/tournament/models/tournament_wizard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_wizard_controller.g.dart';

@riverpod
class TournamentWizard extends _$TournamentWizard {
  @override
  TournamentWizardState build() {
    return const TournamentWizardState();
  }

  // Step 1: Basic Information Methods
  void updateTournamentName(String name) {
    state = state.copyWith(tournamentName: name);
    _validateStep1();
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
    _validateStep1();
  }

  void toggleCustomLocation() {
    state = state.copyWith(
      useCustomLocation: !state.useCustomLocation,
      location: '', // Reset location when switching modes
    );
    _validateStep1();
  }

  void updateDateMode(TournamentDateMode mode) {
    state = state.copyWith(
      dateMode: mode,
      startDate: null,
      endDate: null,
      nonContinuousDates: [],
    );
    _validateStep1();
  }

  void updateSingleDate(DateTime date) {
    state = state.copyWith(
      startDate: date,
      endDate: null,
      nonContinuousDates: [],
    );
    _validateStep1();
  }

  void updateDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      nonContinuousDates: [],
    );
    _validateStep1();
  }

  void addNonContinuousDate(DateTime date) {
    final dates = List<DateTime>.from(state.nonContinuousDates);
    if (!dates.any((d) => _isSameDay(d, date))) {
      dates.add(date);
      dates.sort();
      state = state.copyWith(
        nonContinuousDates: dates,
        startDate: null,
        endDate: null,
      );
      _validateStep1();
    }
  }

  void removeNonContinuousDate(DateTime date) {
    final dates = List<DateTime>.from(state.nonContinuousDates);
    dates.removeWhere((d) => _isSameDay(d, date));
    state = state.copyWith(nonContinuousDates: dates);
    _validateStep1();
  }

  // Step 2: Configuration Methods
  void updateOilPatternName(String name) {
    state = state.copyWith(oilPatternName: name);
    _validateStep2();
  }

  void updateOilPatternLength(String length) {
    state = state.copyWith(oilPatternLength: length);
    _validateStep2();
  }

  void togglePatternType() {
    state = state.copyWith(isHousePattern: !state.isHousePattern);
  }

  void updateEntryFee(String fee) {
    state = state.copyWith(entryFee: fee);
  }

  void updatePrizeInfo(String info) {
    state = state.copyWith(prizeInfo: info);
  }

  void updateTournamentType(String type) {
    state = state.copyWith(tournamentType: type);
  }

  // Step 3: Recommendations Methods
  Future<void> generateRecommendations() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    
    try {
      // Simulate AI analysis based on user's arsenal and tournament settings
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock recommendations based on tournament type and oil pattern
      final recommendations = _generateMockRecommendations();
      
      state = state.copyWith(
        recommendedBalls: recommendations,
        strategyRecommendation: _generateStrategyRecommendation(),
        analysisCompleted: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to generate recommendations: $e',
      );
    }
  }

  // Navigation Methods
  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Validation Methods
  void _validateStep1() {
    final isValid = state.tournamentName.isNotEmpty && 
                   state.location.isNotEmpty && 
                   _hasValidDates();
    state = state.copyWith(isStep1Valid: isValid);
  }

  void _validateStep2() {
    // Step 2 is optional, always valid
    state = state.copyWith(isStep2Valid: true);
  }

  bool _hasValidDates() {
    switch (state.dateMode) {
      case TournamentDateMode.singleDay:
        return state.startDate != null;
      case TournamentDateMode.continuous:
        return state.startDate != null && state.endDate != null;
      case TournamentDateMode.nonContinuous:
        return state.nonContinuousDates.isNotEmpty;
    }
  }

  // Helper Methods
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<String> _generateMockRecommendations() {
    // This would integrate with arsenal data in real implementation
    final recommendations = <String>[];
    
    if (state.isHousePattern) {
      recommendations.addAll([
        'Storm Phaze II - Excellent for house patterns',
        'Brunswick Quantum Bias - Versatile medium oil option',
        'Hammer Black Widow 2.0 - Strong backend reaction',
      ]);
    } else {
      recommendations.addAll([
        'Storm Code X - Designed for sport patterns',
        'Roto Grip RST X-2 - Excellent for longer patterns',
        'Motiv Jackal Ghost - Strong mid-lane read',
      ]);
    }
    
    return recommendations;
  }

  String _generateStrategyRecommendation() {
    if (state.isHousePattern) {
      return 'Focus on targeting the pocket consistently. House patterns are typically forgiving, so prioritize accuracy over power. Start with a medium-strength ball and adjust based on lane conditions.';
    } else {
      return 'Sport patterns require precise ball placement and speed control. Start conservative and make small adjustments. Pay attention to carry down and lane transition throughout the session.';
    }
  }

  // Submission Method
  Future<bool> submitTournament() async {
    if (!state.isStep1Valid) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: '');
    
    try {
      // Here we would save to repository/database
      await Future.delayed(const Duration(seconds: 1));
      
      // Reset state after successful submission
      state = const TournamentWizardState();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create tournament: $e',
      );
      return false;
    }
  }
}