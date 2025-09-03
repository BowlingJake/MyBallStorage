import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_form_state.freezed.dart';

@freezed
class TrainingFormState with _$TrainingFormState {
  const factory TrainingFormState({
    // Step 1 Data
    @Default('') String title,
    DateTime? date,
    @Default('') String centerName,
    
    // Step 2 Data
    @Default(true) bool isHousePattern,
    @Default('') String oilPatternName,
    @Default('') String oilPatternLength,
    
    // Step 3 Data
    @Default('traditional') String selectedScoringMethod,
    @Default('quick') String selectedInputMethod,
    
    // UI State
    @Default(0) int currentStep,
    @Default(false) bool isStep1Valid,
    @Default(false) bool isStep2Valid,
  }) = _TrainingFormState;
} 