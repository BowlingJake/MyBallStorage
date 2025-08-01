import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';

/// 球袋分類選擇器
class CategorySelector extends StatelessWidget {
  final List<BagCategory> categories;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "全部" 選項
            return _buildCategoryChip(
              context: context,
              theme: theme,
              name: '全部',
              icon: Iconsax.category,
              color: theme.colorScheme.primary,
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
              ballCount: null, // 不顯示數量，在主頁面會顯示總數
            );
          }

          final category = categories[index - 1];
          return _buildCategoryChip(
            context: context,
            theme: theme,
            name: category.name,
            icon: category.icon,
            color: category.themeColor,
            isSelected: selectedCategoryId == category.categoryId,
            onTap: () => onCategorySelected(category.categoryId),
            ballCount: null, // 球數會在主頁面顯示
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required ThemeData theme,
    required String name,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    int? ballCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected 
                  ? color.withOpacity(0.15)
                  : theme.colorScheme.surface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? color.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected 
                      ? color
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected 
                        ? color
                        : theme.colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (ballCount != null) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ballCount.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}