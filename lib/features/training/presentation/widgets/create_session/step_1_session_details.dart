import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/compact_text_field.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/shared/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1SessionDetails extends ConsumerStatefulWidget {
  const Step1SessionDetails({
    super.key,
    required this.onDateSelected,
    this.initialData,
  });

  final VoidCallback onDateSelected;
  final TrainingDaySummary? initialData;

  @override
  ConsumerState<Step1SessionDetails> createState() => _Step1SessionDetailsState();
}

class _Step1SessionDetailsState extends ConsumerState<Step1SessionDetails> {
  late final TextEditingController _titleController;
  late final TextEditingController _centerController;

  @override
  void initState() {
    super.initState();
    final formState = ref.read(trainingFormProvider(widget.initialData));
    _titleController = TextEditingController(text: formState.title);
    _centerController = TextEditingController(text: formState.centerName);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(trainingFormProvider(widget.initialData));
    final formNotifier = ref.read(trainingFormProvider(widget.initialData).notifier);

    // 僅同步 controller 內容，不動日期區塊
    if (_titleController.text != formState.title) {
      _titleController.text = formState.title;
      _titleController.selection = TextSelection.fromPosition(TextPosition(offset: _titleController.text.length));
    }
    if (_centerController.text != formState.centerName) {
      _centerController.text = formState.centerName;
      _centerController.selection = TextSelection.fromPosition(TextPosition(offset: _centerController.text.length));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const StepHeader(
          icon: Icons.edit,
          title: 'Session & Location',
          subtitle: 'Basic information',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CompactTextField(
                controller: _titleController,
                label: 'Session Title',
                icon: Icons.title,
                onChanged: (value) => formNotifier.updateTitle(value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CompactTextField(
                controller: _centerController,
                label: 'Bowling Center',
                icon: Icons.location_on,
                onChanged: (value) => formNotifier.updateCenterName(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDateSelector(context, formState),
        const Spacer(),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, TrainingFormState formState) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onDateSelected,
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