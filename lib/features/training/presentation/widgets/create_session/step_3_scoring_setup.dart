import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step3ScoringSetup extends ConsumerWidget {
  const Step3ScoringSetup({
    super.key,
    this.initialData,
  });

  final TrainingDaySummary? initialData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(trainingFormProvider(initialData));
    final formNotifier = ref.read(trainingFormProvider(initialData).notifier);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildSectionHeader(theme, 'Input Preferences'),
        const SizedBox(height: 16),
        _buildInputMethodSelector(theme, formState, formNotifier),
        const SizedBox(height: 16),
        _buildInputDescriptionTooltip(theme, formState),
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Scoring System'),
        const SizedBox(height: 16),
        _buildScoringSystemSelector(formState, formNotifier),
        const SizedBox(height: 16),
        _buildScoringDescriptionTooltip(theme, formState),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputMethodSelector(
      ThemeData theme,
      TrainingFormState formState, 
      dynamic formNotifier) {
    return Row(
      children: [
        Expanded(
          child: formState.selectedInputMethod == 'quick'
              ? AppStandardButton(
                  text: 'Quick Entry',
                  onPressed: () => formNotifier.updateInputMethod('quick'),
                  height: 40,
                )
              : AppStandardButton.secondary(
                  text: 'Quick Entry',
                  onPressed: () => formNotifier.updateInputMethod('quick'),
                  height: 40,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: formState.selectedInputMethod == 'detailed'
              ? AppStandardButton(
                  text: 'Frame by Frame',
                  onPressed: () => formNotifier.updateInputMethod('detailed'),
                  height: 40,
                )
              : AppStandardButton.secondary(
                  text: 'Frame by Frame',
                  onPressed: () => formNotifier.updateInputMethod('detailed'),
                  height: 40,
                ),
        ),
      ],
    );
  }

  Widget _buildInputDescriptionTooltip(ThemeData theme, TrainingFormState formState) {
    final description = formState.selectedInputMethod == 'quick'
        ? 'No frame-by-frame recording, only enter total score per game. Quick but cannot calculate strike rate and related statistics'
        : 'Record each ball throw including pins down and pin positions. Enables calculation of strike rates and detailed analytics';
    
    final title = formState.selectedInputMethod == 'quick'
        ? 'Quick Entry'
        : 'Frame by Frame';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        '$title: $description',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
  
  Widget _buildScoringDescriptionTooltip(ThemeData theme, TrainingFormState formState) {
    final description = formState.selectedScoringMethod == 'traditional'
        ? 'Strike: 10 + next two balls bonus. Spare: 10 + next ball bonus. 10th frame allows bonus balls'
        : 'Strike: 30 points. Spare: 10 + first ball score. 10th frame has no bonus balls, maximum 2 balls';
    
    final title = formState.selectedScoringMethod == 'traditional'
        ? 'Traditional'
        : 'Current';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        '$title: $description',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildScoringSystemSelector(
      TrainingFormState formState, 
      dynamic formNotifier) {
    return Row(
      children: [
        Expanded(
          child: formState.selectedScoringMethod == 'traditional'
              ? AppStandardButton(
                  text: 'Traditional',
                  onPressed: () => formNotifier.updateScoringMethod('traditional'),
                  height: 40,
                )
              : AppStandardButton.secondary(
                  text: 'Traditional',
                  onPressed: () => formNotifier.updateScoringMethod('traditional'),
                  height: 40,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: formState.selectedScoringMethod == 'current'
              ? AppStandardButton(
                  text: 'Current',
                  onPressed: () => formNotifier.updateScoringMethod('current'),
                  height: 40,
                )
              : AppStandardButton.secondary(
                  text: 'Current',
                  onPressed: () => formNotifier.updateScoringMethod('current'),
                  height: 40,
                ),
        ),
      ],
    );
  }
} 