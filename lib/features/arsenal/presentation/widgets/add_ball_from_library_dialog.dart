import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/category_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';

/// 從球庫選擇球具加入 Arsenal 的對話框
class AddBallFromLibraryDialog extends ConsumerStatefulWidget {
  final String? preselectedCategoryId;

  const AddBallFromLibraryDialog({
    super.key,
    this.preselectedCategoryId,
  });

  @override
  ConsumerState<AddBallFromLibraryDialog> createState() => _AddBallFromLibraryDialogState();
}

class _AddBallFromLibraryDialogState extends ConsumerState<AddBallFromLibraryDialog> {
  String? _selectedCategoryId;
  String _searchQuery = '';
  String _nickname = '';
  DateTime? _purchaseDate;
  BowlingBall? _selectedBall;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.preselectedCategoryId;
    
    // 載入球庫資料 - 球庫控制器在初始化時會自動載入
    // 不需要額外呼叫方法
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ballLibraryState = ref.watch(ballLibraryControllerProvider);
    final categories = ref.watch(sortedCategoriesProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
            
            // 搜尋欄
            _buildSearchBar(theme),
            
            // 球具列表
            Expanded(
              child: _buildBallList(theme, ballLibraryState),
            ),
            
            // 底部操作區
            if (_selectedBall != null)
              _buildBottomActions(theme, categories),
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
            Iconsax.book,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '從球庫選擇',
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

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          ref.read(ballLibraryControllerProvider.notifier).updateSearchText(value);
        },
        decoration: InputDecoration(
          hintText: '搜尋球具名稱或品牌...',
          prefixIcon: const Icon(Iconsax.search_normal),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBallList(ThemeData theme, AsyncValue<BallLibraryState> ballLibraryState) {
    if (ballLibraryState.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (ballLibraryState.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '載入失敗',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ballLibraryState.error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!ballLibraryState.hasValue) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    final balls = ballLibraryState.value!.filteredBalls;

    if (balls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_normal,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '找不到球具',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '請嘗試其他搜尋關鍵字',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: balls.length,
      itemBuilder: (context, index) {
        final ball = balls[index];
        final isSelected = _selectedBall?.id == ball.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectBall(ball),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.colorScheme.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // 球具圖片
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ball.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Iconsax.cpu,
                              color: theme.colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 球具資訊
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ball.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ball.brand,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (ball.rg != null && ball.diff != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'RG: ${ball.rg!.toStringAsFixed(2)}',
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Diff: ${ball.diff!.toStringAsFixed(3)}',
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // 選取指示器
                    if (isSelected)
                      Icon(
                        Iconsax.tick_circle,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(ThemeData theme, List<BagCategory> categories) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 分類選擇
          Row(
            children: [
              Icon(
                Iconsax.category,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '選擇球袋:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category.categoryId,
                child: Row(
                  children: [
                    Icon(
                      category.icon,
                      color: category.themeColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
            hint: const Text('選擇球袋分類'),
          ),
          const SizedBox(height: 16),
          // 暱稱輸入
          TextField(
            onChanged: (value) => _nickname = value,
            decoration: InputDecoration(
              labelText: '暱稱 (選填)',
              hintText: '為這顆球取個暱稱...',
              prefixIcon: const Icon(Iconsax.edit),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 操作按鈕
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedCategoryId != null && !_isAdding
                      ? _addBallToArsenal
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isAdding
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('加入球袋'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectBall(BowlingBall ball) {
    setState(() {
      _selectedBall = ball;
    });
  }

  Future<void> _addBallToArsenal() async {
    if (_selectedBall == null || _selectedCategoryId == null) return;

    setState(() {
      _isAdding = true;
    });

    try {
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        throw Exception('使用者未登入');
      }

      await ref.read(arsenalControllerProvider.notifier).addBallFromLibrary(
        userId: authState.value!.id,
        ballId: _selectedBall!.id.toString(),
        categoryId: _selectedCategoryId!,
        nickname: _nickname.isEmpty ? null : _nickname,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('成功加入 ${_selectedBall!.name} 到球袋'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加入失敗: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }
}