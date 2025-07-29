import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class NotesEditSection extends StatefulWidget {
  const NotesEditSection({
    required this.game,
    required this.onSaveNotes,
    super.key,
  });

  final GameRecord game;
  final Future<void> Function(String notes) onSaveNotes;

  @override
  State<NotesEditSection> createState() => _NotesEditSectionState();
}

class _NotesEditSectionState extends State<NotesEditSection> {
  late TextEditingController _notesController;
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.game.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NotesEditSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.game.notes != oldWidget.game.notes) {
      _notesController.text = widget.game.notes ?? '';
    }
  }

  Future<void> _saveNotes() async {
    await widget.onSaveNotes(_notesController.text);
    setState(() {
      _isEditingNotes = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditingNotes = false;
      _notesController.text = widget.game.notes ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notes',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditingNotes = !_isEditingNotes;
                });
              },
              icon: Icon(
                _isEditingNotes ? Icons.close : Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isEditingNotes)
          _buildEditingSection(theme)
        else
          _buildDisplaySection(theme),
      ],
    );
  }

  Widget _buildEditingSection(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Add notes...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppStandardButton(
                text: 'Cancel',
                onPressed: _cancelEdit,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppStandardButton(
                text: 'Save Notes',
                onPressed: _saveNotes,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisplaySection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        (widget.game.notes?.isNotEmpty ?? false)
            ? widget.game.notes!
            : 'No notes yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: (widget.game.notes?.isNotEmpty ?? false)
              ? Colors.white
              : Colors.white54,
        ),
      ),
    );
  }
}