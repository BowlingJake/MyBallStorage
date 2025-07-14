import 'package:bowlingarsenal_app/features/training/controllers/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/option_toggle_button.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2OilPattern extends ConsumerWidget {
  const Step2OilPattern({
    super.key,
    this.initialData,
  });

  final TrainingDaySummary? initialData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(trainingFormProvider(initialData));
    final formNotifier = ref.read(trainingFormProvider(initialData).notifier);

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
        _buildOilPatternSelector(context, formState, formNotifier),
        const Spacer(),
      ],
    );
  }

  Widget _buildOilPatternSelector(
      BuildContext context, 
      TrainingFormState formState, 
      dynamic formNotifier) {
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // 模式選擇按鈕
        Row(
          children: [
            Expanded(
              child: OptionToggleButton(
                text: 'House Pattern',
                isSelected: formState.isHousePattern,
                onTap: () => formNotifier.onPatternTypeChanged(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OptionToggleButton(
                text: 'Sport Pattern',
                isSelected: !formState.isHousePattern,
                onTap: () => formNotifier.onPatternTypeChanged(false),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 模式名稱和長度輸入
        if (!formState.isHousePattern) ...[
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _CompactTextField(
                  key: ValueKey(formState.oilPatternName),
                  initialValue: formState.oilPatternName,
                  label: 'Pattern Name',
                  icon: Icons.label,
                  onChanged: (value) => formNotifier.updateOilPatternName(value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactTextField(
                  key: ValueKey(formState.oilPatternLength),
                  initialValue: formState.oilPatternLength,
                  label: 'Length',
                  icon: Icons.straighten,
                  onChanged: (value) => formNotifier.updateOilPatternLength(value),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// 自訂 CompactTextField 組件，支援 initialValue 而不是 controller
class _CompactTextField extends StatelessWidget {
  const _CompactTextField({
    super.key,
    required this.initialValue,
    required this.label,
    required this.icon,
    this.onChanged,
  });

  final String initialValue;
  final String label;
  final IconData icon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        color: theme.colorScheme.surface.withOpacity(0.1),
      ),
      child: TextFormField(
        initialValue: initialValue,
        style: theme.textTheme.bodyMedium,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: theme.colorScheme.primary.withOpacity(0.7),
            size: 18,
          ),
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
} 