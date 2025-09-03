import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_form_controller.g.dart';

@riverpod
class TrainingForm extends _$TrainingForm {
  @override
  TrainingFormState build(TrainingDaySummary? initialData) {
    if (initialData != null) {
      // Edit mode: Populate state from initial data
      return TrainingFormState(
        title: initialData.title,
        date: initialData.date,
        centerName: initialData.center,
        isHousePattern: initialData.isHousePattern,
        oilPatternName: initialData.oilPatternName ?? '',
        oilPatternLength: initialData.oilPatternLength ?? '',
        selectedScoringMethod: initialData.scoringMethod,
        selectedInputMethod: initialData.inputMethod,
        isStep1Valid: true, // Assume valid if editing
        isStep2Valid: true, // Assume valid if editing
      );
    } else {
      // Create mode: Default state with no date selected
      final defaultState = TrainingFormState();
      // Validate Step 2 for house pattern (default)
      return defaultState.copyWith(isStep2Valid: true); // House pattern is valid by default
    }
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
    _validateStep1();
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
    _validateStep1();
  }

  void updateCenterName(String centerName) {
    state = state.copyWith(centerName: centerName);
    _validateStep1();
  }

  void onPatternTypeChanged(bool isHouse) {
    state = state.copyWith(isHousePattern: isHouse);
    _validateStep2();
  }

  void updateOilPatternName(String name) {
    state = state.copyWith(oilPatternName: name);
    _validateStep2();
  }

  void updateOilPatternLength(String length) {
    state = state.copyWith(oilPatternLength: length);
    _validateStep2();
  }
  
  void updateScoringMethod(String method) {
    state = state.copyWith(selectedScoringMethod: method);
  }

  void updateInputMethod(String method) {
    state = state.copyWith(selectedInputMethod: method);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
  
  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void _validateStep1() {
    final isValid = state.title.isNotEmpty && state.centerName.isNotEmpty && state.date != null;
    state = state.copyWith(isStep1Valid: isValid);
  }
  
  void _validateStep2() {
    bool isValid;
    if (state.isHousePattern) {
      // House pattern: no additional fields required
      isValid = true;
    } else {
      // Sport pattern: pattern name and valid length (20-60) required
      final lengthValue = int.tryParse(state.oilPatternLength);
      isValid = state.oilPatternName.isNotEmpty && 
                lengthValue != null && 
                lengthValue >= 20 && 
                lengthValue <= 60;
    }
    state = state.copyWith(isStep2Valid: isValid);
  }
  
  void reset() {
    state = TrainingFormState();
  }
  
  TrainingFormState? submit() {
    _validateStep1();
    if (!state.isStep1Valid) {
      // Optionally, force navigation to the invalid step
      goToStep(0);
      return null;
    }
    // Add validation for other steps if needed
    return state;
  }
} 