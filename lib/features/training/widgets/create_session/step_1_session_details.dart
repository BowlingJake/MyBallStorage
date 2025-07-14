import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';

class Step1SessionDetails extends StatelessWidget {
  const Step1SessionDetails({
    super.key,
    required this.titleController,
    required this.centerNameController,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onValidate,
  });

  final TextEditingController titleController;
  final TextEditingController centerNameController;
  final DateTime selectedDate;
  final VoidCallback onDateSelected;
  final Function(String) onValidate;

  @override
  Widget build(BuildContext context) {
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
              child: CompactTextField(
                controller: titleController,
                label: 'Session Title',
                icon: Icons.title,
                onChanged: onValidate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CompactTextField(
                controller: centerNameController,
                label: 'Bowling Center',
                icon: Icons.location_on,
                onChanged: onValidate,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 日期選擇
        _buildDateSelector(context),

        const Spacer(),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onDateSelected,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          color: theme.colorScheme.surface.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training Date',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
} 