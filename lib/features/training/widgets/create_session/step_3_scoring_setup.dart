import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/input_method_card.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/option_toggle_button.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';

class Step3ScoringSetup extends StatelessWidget {
  const Step3ScoringSetup({
    super.key,
    required this.selectedInputMethod,
    required this.selectedScoringMethod,
    required this.onInputMethodChanged,
    required this.onScoringMethodChanged,
  });

  final String selectedInputMethod;
  final String selectedScoringMethod;
  final ValueChanged<String> onInputMethodChanged;
  final ValueChanged<String> onScoringMethodChanged;

  @override
  Widget build(BuildContext context) {
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
        _buildInputMethodSelector(),
        const SizedBox(height: 16),
        _buildScoringSystemSelector(),
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
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Advanced scoring provides more detailed statistics',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInputMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InputMethodCard(
                title: 'Simple',
                subtitle: 'Only input total score',
                description: 'Quick basic recording',
                icon: Icons.speed,
                isSelected: selectedInputMethod == 'simple',
                onTap: () => onInputMethodChanged('simple'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InputMethodCard(
                title: 'Advanced',
                subtitle: 'Frame-by-frame input',
                description: 'Complete statistics',
                icon: Icons.grid_on,
                isSelected: selectedInputMethod == 'advanced',
                onTap: () => onInputMethodChanged('advanced'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoringSystemSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OptionToggleButton(
                text: 'Traditional',
                isSelected: selectedScoringMethod == 'traditional',
                onTap: () => onScoringMethodChanged('traditional'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OptionToggleButton(
                text: 'Current',
                isSelected: selectedScoringMethod == 'current',
                onTap: () => onScoringMethodChanged('current'),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 