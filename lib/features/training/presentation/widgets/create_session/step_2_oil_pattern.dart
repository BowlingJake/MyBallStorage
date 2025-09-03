import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/text_fields/compact_text_field.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _lengthError;

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
        // Oil Pattern header with favorite button when sport pattern is selected
        Row(
          children: [
            Text(
              'Oil Pattern',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!formState.isHousePattern) ...[
              const SizedBox(width: 8),
              AppStandardButton(
                text: 'Favorite',
                height: 28,
                fontSize: 11,
                onPressed: () {
                  // TODO: Implement favorite pattern selection
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // House/Sport pattern buttons
        Row(
          children: [
            Expanded(
              child: formState.isHousePattern
                  ? AppStandardButton(
                      text: 'House Pattern',
                      onPressed: () => formNotifier.onPatternTypeChanged(true),
                      height: 40,
                    )
                  : AppStandardButton.secondary(
                      text: 'House Pattern',
                      onPressed: () => formNotifier.onPatternTypeChanged(true),
                      height: 40,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: !formState.isHousePattern
                  ? AppStandardButton(
                      text: 'Sport Pattern',
                      onPressed: () => formNotifier.onPatternTypeChanged(false),
                      height: 40,
                    )
                  : AppStandardButton.secondary(
                      text: 'Sport Pattern',
                      onPressed: () => formNotifier.onPatternTypeChanged(false),
                      height: 40,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sport pattern input fields
        if (!formState.isHousePattern) ...[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pattern Name',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CompactTextField(
                      controller: _patternNameController,
                      onChanged: (value) => formNotifier.updateOilPatternName(value),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Length',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                        color: Colors.black.withOpacity(0.8),
                      ),
                      child: TextFormField(
                        controller: _patternLengthController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: theme.textTheme.bodyMedium,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          // Always allow the input to proceed
                          formNotifier.updateOilPatternLength(value);
                          
                          setState(() {
                            if (value.isEmpty) {
                              _lengthError = null;
                            } else {
                              final numValue = int.tryParse(value);
                              if (numValue != null && numValue >= 20 && numValue <= 60) {
                                _lengthError = null;
                              } else {
                                _lengthError = 'Length must be between 20-60';
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '20-60',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          isDense: false,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_lengthError != null) ...[
            const SizedBox(height: 8),
            Text(
              _lengthError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ],
    );
  }
} 