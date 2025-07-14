import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/option_toggle_button.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';

class Step2OilPattern extends StatelessWidget {
  const Step2OilPattern({
    super.key,
    required this.isHousePattern,
    required this.onPatternTypeChanged,
    required this.oilPatternNameController,
    required this.oilPatternLengthController,
  });

  final bool isHousePattern;
  final ValueChanged<bool> onPatternTypeChanged;
  final TextEditingController oilPatternNameController;
  final TextEditingController oilPatternLengthController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const StepHeader(
          icon: Icons.water_drop,
          title: 'Oil Pattern',
          subtitle: 'Lane conditions',
        ),
        const SizedBox(height: 16),
        _buildOilPatternSelector(context),
        const Spacer(),
      ],
    );
  }

  Widget _buildOilPatternSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.water_drop, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'Oil Pattern',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OptionToggleButton(
                text: 'House',
                isSelected: isHousePattern,
                onTap: () => onPatternTypeChanged(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OptionToggleButton(
                text: 'Custom',
                isSelected: !isHousePattern,
                onTap: () => onPatternTypeChanged(false),
              ),
            ),
          ],
        ),
        if (!isHousePattern) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CompactTextField(
                  controller: oilPatternNameController,
                  label: 'Pattern',
                  icon: Icons.label,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CompactTextField(
                  controller: oilPatternLengthController,
                  label: 'Length',
                  icon: Icons.straighten,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
} 