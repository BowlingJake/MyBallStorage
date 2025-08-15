import 'package:flutter/material.dart';

/// 通用的簡潔搜索控制欄組件
/// 包含搜索欄、篩選按鈕和排序按鈕，基於Ball Library的設計風格
class SimpleSearchControls extends StatelessWidget {
  final String searchText;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final int filterCount;
  final bool showFilterBadge;
  final bool showSortButton;

  const SimpleSearchControls({
    super.key,
    this.searchText = '',
    this.searchHint = 'Search...',
    required this.onSearchChanged,
    this.onFilterTap,
    this.onSortTap,
    this.filterCount = 0,
    this.showFilterBadge = true,
    this.showSortButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          // 搜尋框 - 佔據大部分空間
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextField(
                onChanged: onSearchChanged,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                enableSuggestions: true,
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 18),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  isDense: true, // 使TextField更緊湊
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 篩選按鈕
          if (onFilterTap != null) ...[
            _buildActionButton(
              context: context,
              onTap: onFilterTap!,
              icon: Icons.filter_list,
              showBadge: showFilterBadge && filterCount > 0,
              badgeCount: filterCount,
            ),
            const SizedBox(width: 8),
          ],
          
          // 排序按鈕
          if (showSortButton && onSortTap != null)
            _buildActionButton(
              context: context,
              onTap: onSortTap!,
              icon: Icons.sort,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    return Stack(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
        if (showBadge && badgeCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}