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
      );
    } else {
      // Create mode: Default state
      return TrainingFormState(
        date: DateTime.now(),
      );
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
  }

  void updateOilPatternName(String name) {
    state = state.copyWith(oilPatternName: name);
  }

  void updateOilPatternLength(String length) {
    state = state.copyWith(oilPatternLength: length);
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