import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/text_fields/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/option_toggle_button.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2OilPattern extends ConsumerStatefulWidget {
  const Step2OilPattern({
    super.key,
    this.initialData,
  });

  final TrainingDaySummary? initialData;

  @override
  ConsumerState<Step2OilPattern> createState() => _Step2OilPatternState();
}

class _Step2OilPatternState extends ConsumerState<Step2OilPattern> {
  late final TextEditingController _patternNameController;
  late final TextEditingController _patternLengthController;

  @override
  void initState() {
    super.initState();
    final formState = ref.read(trainingFormProvider(widget.initialData));
    _patternNameController = TextEditingController(text: formState.oilPatternName);
    _patternLengthController = TextEditingController(text: formState.oilPatternLength);
  }

  @override
  void dispose() {
    _patternNameController.dispose();
    _patternLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(trainingFormProvider(widget.initialData));
    final formNotifier = ref.read(trainingFormProvider(widget.initialData).notifier);

    // 同步 controller 內容
    if (_patternNameController.text != formState.oilPatternName) {
      _patternNameController.text = formState.oilPatternName;
      _patternNameController.selection = TextSelection.fromPosition(TextPosition(offset: _patternNameController.text.length));
    }
    if (_patternLengthController.text != formState.oilPatternLength) {
      _patternLengthController.text = formState.oilPatternLength;
      _patternLengthController.selection = TextSelection.fromPosition(TextPosition(offset: _patternLengthController.text.length));
    }

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
        if (!formState.isHousePattern) ...[
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CompactTextField(
                  controller: _patternNameController,
                  label: 'Pattern Name',
                  icon: Icons.label,
                  onChanged: (value) => formNotifier.updateOilPatternName(value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CompactTextField(
                  controller: _patternLengthController,
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