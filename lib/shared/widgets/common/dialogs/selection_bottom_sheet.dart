import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:core_theme/core_theme.dart';

/// 通用的底部選擇對話框
/// 用於替換下拉選單，提供更好的手機使用體驗
Future<T?> showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<SelectionItem<T>> items,
  T? selectedValue,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BrandColors.accentColorDark, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 標題
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // 可滾動的選項列表
            Flexible(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                  scrollbars: false, // 隱藏滾動條，符合手機設計規範
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedValue == item.value;
                    return _SelectionTile<T>(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        Navigator.of(context).pop(item.value);
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

/// 選擇項目模型
class SelectionItem<T> {
  final T value;
  final String displayText;

  const SelectionItem({
    required this.value,
    required this.displayText,
  });
}

class _SelectionTile<T> extends StatelessWidget {
  const _SelectionTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final SelectionItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.displayText,
                  style: TextStyle(
                    color: isSelected ? BrandColors.accentColorDark : Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: BrandColors.accentColorDark,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}