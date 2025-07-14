import 'package:bowlingarsenal_app/features/training/controllers/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1SessionDetails extends ConsumerWidget {
  const Step1SessionDetails({
    super.key,
    required this.onDateSelected,
    this.initialData,
  });

  final VoidCallback onDateSelected;
  final TrainingDaySummary? initialData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(trainingFormProvider(initialData));
    final formNotifier = ref.read(trainingFormProvider(initialData).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // 步驟標題
        const StepHeader(
          icon: Icons.edit,
          title: 'Session & Location',
          subtitle: 'Basic information',
        ),

        const SizedBox(height: 16),

        // 練習標題和球館名稱（並排）
        Row(
          children: [
            Expanded(
              child: _CompactTextField(
                key: ValueKey(formState.title),
                initialValue: formState.title,
                label: 'Session Title',
                icon: Icons.title,
                onChanged: (value) => formNotifier.updateTitle(value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CompactTextField(
                key: ValueKey(formState.centerName),
                initialValue: formState.centerName,
                label: 'Bowling Center',
                icon: Icons.location_on,
                onChanged: (value) => formNotifier.updateCenterName(value),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 日期選擇器
        _buildDateSelector(context, formState),

        const Spacer(),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, TrainingFormState formState) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onDateSelected,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          color: theme.colorScheme.surface.withOpacity(0.1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Date: ${_formatDate(formState.date ?? DateTime.now())}',
              style: theme.textTheme.bodyMedium,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
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