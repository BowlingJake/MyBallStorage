import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/category_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';

/// 球袋分類管理對話框
class CategoryManagementDialog extends ConsumerStatefulWidget {
  const CategoryManagementDialog({super.key});

  @override
  ConsumerState<CategoryManagementDialog> createState() => _CategoryManagementDialogState();
}

class _CategoryManagementDialogState extends ConsumerState<CategoryManagementDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryState = ref.watch(categoryControllerProvider);
    final sortedCategories = ref.watch(sortedCategoriesProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            // 標題列
            _buildHeader(theme),
            
            // 分類列表
            Expanded(
              child: _buildCategoryList(theme, sortedCategories),
            ),
            
            // 底部操作
            _buildBottomActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.category,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '管理球袋分類',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Iconsax.close_circle,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(ThemeData theme, List<BagCategory> categories) {
    if (categories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      onReorder: (oldIndex, newIndex) => _reorderCategories(oldIndex, newIndex, categories),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(theme, category, index);
      },
    );
  }

  Widget _buildCategoryItem(ThemeData theme, BagCategory category, int index) {
    return Container(
      key: ValueKey(category.categoryId),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: category.themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.themeColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category.themeColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            category.icon,
            color: category.themeColor,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category.description != null) ...[
              const SizedBox(height: 4),
              Text(
                category.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                if (category.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '預設',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  Iconsax.menu,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _editCategory(category),
              icon: Icon(
                Iconsax.edit,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            if (!category.isDefault)
              IconButton(
                onPressed: () => _deleteCategory(category),
                icon: Icon(
                  Iconsax.trash,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Iconsax.close_circle),
              label: const Text('關閉'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _createNewCategory,
              icon: const Icon(Iconsax.add),
              label: const Text('新增分類'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reorderCategories(int oldIndex, int newIndex, List<BagCategory> categories) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    final reorderedCategories = [...categories];
    final item = reorderedCategories.removeAt(oldIndex);
    reorderedCategories.insert(newIndex, item);

    // 更新順序
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      final categoryIds = reorderedCategories.map((cat) => cat.categoryId).toList();
      ref.read(categoryControllerProvider.notifier)
          .reorderCategories(authState.value!.id, categoryIds);
    }
  }

  void _editCategory(BagCategory category) {
    showDialog(
      context: context,
      builder: (context) => CategoryEditDialog(category: category),
    );
  }

  void _deleteCategory(BagCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除分類'),
        content: Text('確定要刪除「${category.name}」分類嗎？\n\n此分類中的球具將會被移動到預設分類。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDeleteCategory(category);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(BagCategory category) {
    // 找到第一個預設分類作為重新分配目標
    final categories = ref.read(sortedCategoriesProvider);
    final defaultCategory = categories.where((cat) => cat.isDefault).firstOrNull;

    ref.read(categoryControllerProvider.notifier).deleteCategory(
      category.categoryId,
      defaultCategory?.categoryId,
    );
  }

  void _createNewCategory() {
    showDialog(
      context: context,
      builder: (context) => const CategoryEditDialog(),
    );
  }
}

/// 分類編輯對話框
class CategoryEditDialog extends ConsumerStatefulWidget {
  final BagCategory? category;

  const CategoryEditDialog({super.key, this.category});

  @override
  ConsumerState<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends ConsumerState<CategoryEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  IconData _selectedIcon = Iconsax.bag;
  Color _selectedColor = const Color(0xFF2E7D32);

  final List<IconData> _availableIcons = [
    Iconsax.bag,
    Iconsax.medal_star,
    Iconsax.star,
    Iconsax.heart,
    Iconsax.flash,
    Iconsax.shield,
    Iconsax.medal_star,
    Iconsax.crown,
    Iconsax.star,
    Iconsax.game,
  ];

  final List<Color> _availableColors = [
    const Color(0xFF2E7D32), // Green
    const Color(0xFF1976D2), // Blue
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFFF8F00), // Orange
    const Color(0xFFD32F2F), // Red
    const Color(0xFF388E3C), // Dark Green
    const Color(0xFF5E35B1), // Deep Purple
    const Color(0xFF00ACC1), // Cyan
    const Color(0xFFE64A19), // Deep Orange
    const Color(0xFF7B1FA2), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(text: widget.category?.description ?? '');
    
    if (widget.category != null) {
      _selectedIcon = widget.category!.icon;
      _selectedColor = widget.category!.themeColor;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.category != null;

    return AlertDialog(
      title: Text(isEditing ? '編輯分類' : '新增分類'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 名稱輸入
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '分類名稱',
                hintText: '輸入分類名稱...',
              ),
            ),
            const SizedBox(height: 16),
            
            // 描述輸入
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述 (選填)',
                hintText: '輸入分類描述...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            
            // 圖示選擇
            Text(
              '選擇圖示',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableIcons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? _selectedColor.withOpacity(0.2)
                          : theme.colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? _selectedColor
                            : theme.colorScheme.outline.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected 
                          ? _selectedColor
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            // 顏色選擇
            Text(
              '選擇顏色',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? theme.colorScheme.onSurface
                            : Colors.transparent,
                        width: isSelected ? 3 : 0,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _nameController.text.isNotEmpty ? _saveCategory : null,
          child: Text(isEditing ? '更新' : '創建'),
        ),
      ],
    );
  }

  void _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) return;

    try {
      if (widget.category != null) {
        // 更新現有分類
        final updatedCategory = widget.category!.copyWith(
          name: name,
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          icon: _selectedIcon,
          themeColor: _selectedColor,
        );
        
        await ref.read(categoryControllerProvider.notifier).updateCategory(updatedCategory);
      } else {
        // 創建新分類
        await ref.read(categoryControllerProvider.notifier).createCategory(
          userId: authState.value!.id,
          name: name,
          icon: _selectedIcon,
          themeColor: _selectedColor,
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.category != null ? '分類已更新' : '分類已創建'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作失敗: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}