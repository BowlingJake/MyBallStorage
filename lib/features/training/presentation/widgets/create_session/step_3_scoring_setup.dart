import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/input_method_card.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/option_toggle_button.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/step_header.dart';
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
        const StepHeader(
          icon: Icons.settings,
          title: 'Scoring Setup',
          subtitle: 'Choose your input method and scoring system',
        ),
        const SizedBox(height: 16),
        _buildInputMethodSelector(formState, formNotifier),
        const SizedBox(height: 16),
        _buildScoringSystemSelector(formState, formNotifier),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You can change these settings later in the app',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputMethodSelector(
      TrainingFormState formState, 
      dynamic formNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InputMethodCard(
                title: 'Quick Entry',
                subtitle: 'Just total pins',
                description: 'Fast entry for total pins only',
                icon: Icons.speed,
                isSelected: formState.selectedInputMethod == 'quick',
                onTap: () => formNotifier.updateInputMethod('quick'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputMethodCard(
                title: 'Pin by Pin',
                subtitle: 'Detailed tracking',
                description: 'Track each pin for detailed analysis',
                icon: Icons.sports,
                isSelected: formState.selectedInputMethod == 'detailed',
                onTap: () => formNotifier.updateInputMethod('detailed'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoringSystemSelector(
      TrainingFormState formState, 
      dynamic formNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OptionToggleButton(
                text: 'Traditional',
                isSelected: formState.selectedScoringMethod == 'traditional',
                onTap: () => formNotifier.updateScoringMethod('traditional'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OptionToggleButton(
                text: 'Current',
                isSelected: formState.selectedScoringMethod == 'current',
                onTap: () => formNotifier.updateScoringMethod('current'),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 