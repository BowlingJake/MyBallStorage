import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/selection_bottom_sheet.dart';

/// 替換下拉選單的選擇按鈕
/// 點擊後會彈出底部選擇對話框
class SelectionButton<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<SelectionItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String dialogTitle;

  const SelectionButton({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    SelectionItem<T>? selectedItem;
    try {
      selectedItem = items.firstWhere((item) => item.value == value);
    } catch (e) {
      selectedItem = null;
    }

    return GestureDetector(
      onTap: onChanged != null ? () => _showSelectionDialog(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedItem?.displayText ?? hint,
                style: TextStyle(
                  color: selectedItem != null ? Colors.white : Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) async {
    final result = await showSelectionBottomSheet<T>(
      context: context,
      title: dialogTitle,
      items: items,
      selectedValue: value,
    );

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }
}