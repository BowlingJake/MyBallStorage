import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/text_fields/compact_text_field.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
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
        const SizedBox(height: 16),
        _buildFieldSection(
          context,
          title: 'Session Title',
          child: CompactTextField(
            controller: _titleController,
            onChanged: (value) => formNotifier.updateTitle(value),
          ),
        ),
        const SizedBox(height: 24),
        _buildFieldSection(
          context,
          title: 'Bowling Center',
          button: _buildFavoriteButton(context),
          child: CompactTextField(
            controller: _centerController,
            onChanged: (value) => formNotifier.updateCenterName(value),
          ),
        ),
        const SizedBox(height: 24),
        _buildFieldSection(
          context,
          title: 'Date',
          button: formState.date == null ? _buildDateSelectorButton(context) : _buildChangeDateButton(context),
          child: formState.date != null ? _buildSelectedDateText(context, formState) : const SizedBox.shrink(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFieldSection(BuildContext context, {
    required String title, 
    required Widget child,
    Widget? button,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (button != null) ...[
                const SizedBox(width: 8),
                button,
              ],
            ],
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return AppStandardButton(
      text: 'Favorite',
      height: 28,
      fontSize: 11,
      onPressed: () {
        // 功能後補
        // TODO: 實現從收藏中選擇保齡球館的功能
      },
    );
  }

  Widget _buildDateSelectorButton(BuildContext context) {
    return AppStandardButton(
      text: 'Select date',
      height: 28,
      fontSize: 11,
      onPressed: widget.onDateSelected,
    );
  }

  Widget _buildChangeDateButton(BuildContext context) {
    return AppStandardButton(
      text: 'Change date',
      height: 28,
      fontSize: 11,
      onPressed: widget.onDateSelected,
    );
  }

  Widget _buildSelectedDateText(BuildContext context, TrainingFormState formState) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(
        _formatDate(formState.date!),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
} 