import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';
import '../shared/dialogs/layout_dialog.dart'; // Import layout dialog if needed
import 'weapon_library_page.dart'; // <-- Add this import
import 'add_custom_ball_page.dart'; // <-- Add import for the new custom page
import 'package:bowlingarsenal_app/views/ball_card.dart';


/// 顯示使用者目前擁有的武器清單頁面 (支援選擇模式)
class MyArsenalPage extends StatefulWidget { // Changed to StatefulWidget
  final bool isSelectionMode;

  const MyArsenalPage({super.key, this.isSelectionMode = false});

  @override
  State<MyArsenalPage> createState() => _MyArsenalPageState(); // Create State
}

class _MyArsenalPageState extends State<MyArsenalPage> { // State class
  // 新增多選模式狀態
  bool _isMultiSelectMode = false;
  // State to keep track of selected ball names in selection mode
  final Set<String> _selectedBallNames = {};
  bool _hasLoadedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedData) {
      context.read<WeaponLibraryViewModel>().loadBallData();
      _hasLoadedData = true;
    }
  }

  // --- Moved Method: Show Add Method Selection Dialog ---
  void _showAddMethodSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('選擇添加方式'),
          content: const Text('您想要如何添加新的武器？'),
          actions: <Widget>[
            TextButton(
              child: const Text('自行輸入數據'),
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCustomBallPage()), // Navigate to custom page
                );
              },
            ),
            TextButton(
              child: const Text('從現有清單添加'),
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                final viewModel = context.read<WeaponLibraryViewModel>();
                Navigator.push<List<BowlingBall>>(
                  context,
                  MaterialPageRoute(builder: (_) => const WeaponLibraryPage()), // Ensure WeaponLibraryPage is imported
                ).then((selectedBalls) {
                  if (selectedBalls != null && selectedBalls.isNotEmpty) {
                    for (final ball in selectedBalls) {
                      viewModel.addBallToArsenal(ball);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已成功新增 ${selectedBalls.length} 個球具到我的球櫃')),
                    );
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  // --- Filter Dropdown Widget ---
  Widget _buildFilterDropdown(BuildContext context, WeaponLibraryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Brand Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedBrandFilter,
              hint: const Text('品牌'),
              items: viewModel.arsenalBrands.map((String brand) {
                return DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedBrandFilter(newValue);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Core Category Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedCoreCategoryFilter,
              hint: const Text('Core'),
              items: viewModel.arsenalCoreCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedCoreCategoryFilter(newValue);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Coverstock Category Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedCoverstockCategoryFilter,
              hint: const Text('Cover'),
              items: viewModel.arsenalCoverstockCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedCoverstockCategoryFilter(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeaponLibraryViewModel>();
    final filteredArsenal = viewModel.filteredArsenal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelectionMode && !_isMultiSelectMode 
              ? '選擇賽事用球' // Page's own selection mode
              : _isMultiSelectMode 
                  ? '選擇要刪除的球具' // Multi-delete mode
                  : '我的球櫃' // Normal mode
        ),
        actions: [
          // Action button for page's selection mode (Confirm)
          if (widget.isSelectionMode && !_isMultiSelectMode)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: '完成選擇',
              onPressed: () {
                Navigator.pop(context, _selectedBallNames.toList());
              },
            ),

          // Multi-select mode toggle button (only if not in page's selection mode)
          if (!widget.isSelectionMode)
            IconButton(
              icon: Icon(_isMultiSelectMode ? Icons.close : Icons.select_all),
              tooltip: _isMultiSelectMode ? '取消多選' : '多選刪除',
              onPressed: () {
                setState(() {
                  _isMultiSelectMode = !_isMultiSelectMode;
                  _selectedBallNames.clear(); // Clear selections when toggling mode
                });
              },
            ),
          // Batch delete button (only in multi-select mode and if items are selected)
          if (_isMultiSelectMode && _selectedBallNames.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: Text('刪除 (${_selectedBallNames.length})',
                  style: const TextStyle(color: Colors.red)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('確認刪除'),
                    content: Text(
                        '確定要刪除選取的 ${_selectedBallNames.length} 個球具嗎？'),
                    actions: [
                      TextButton(
                        child: const Text('取消'),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                      TextButton(
                        child: const Text('刪除',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          int deletedCount = 0;
                          List<String> namesToDelete = List.from(_selectedBallNames); // Create a copy for iteration
                          for (final ballName in namesToDelete) {
                            try {
                              final ball = viewModel.myArsenal.firstWhere(
                                (b) => b.ball == ballName,
                              );
                              viewModel.removeBallFromArsenal(ball);
                              deletedCount++;
                            } catch (e) {
                              // Ball might have been removed by another process or not found
                              print('Error removing ball $ballName: $e');
                            }
                          }
                          Navigator.pop(dialogContext); // Close the dialog
                          setState(() {
                            _isMultiSelectMode = false;
                            _selectedBallNames.clear();
                          });
                          if (deletedCount > 0) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('已刪除 $deletedCount 個球具')),
                             );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterDropdown(context, viewModel),
          if (!widget.isSelectionMode && !_isMultiSelectMode) // Show search only in normal mode
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '搜尋我的球櫃...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  viewModel.filterArsenal(value);
                },
              ),
            ),
          if (widget.isSelectionMode && !_isMultiSelectMode) // Show "Add to Arsenal" only in page's selection mode
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('新增保齡球至我的球櫃'),
                onPressed: () => _showAddMethodSelectionDialog(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            ),
          Expanded(
            child: filteredArsenal.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.isSelectionMode && !_isMultiSelectMode
                            ? '球櫃中無球可選\n點擊上方按鈕新增'
                            : (viewModel.hasActiveFilters ||
                                    viewModel.currentArsenalSearchKeyword.isNotEmpty)
                                ? '沒有符合條件的球具'
                                : '您的球櫃是空的\n點擊右下角按鈕新增',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                    itemCount: filteredArsenal.length,
                    itemBuilder: (context, index) {
                      final ball = filteredArsenal[index];
                      final bool isSelectedForCurrentMode = _selectedBallNames.contains(ball.ball);

                      return BowlingBallCard(
                        key: ValueKey(ball.ball + ball.brand), // More unique key
                        ball: ball,
                        viewModel: viewModel,
                        isSelected: (_isMultiSelectMode && isSelectedForCurrentMode) || 
                                    (widget.isSelectionMode && !_isMultiSelectMode && isSelectedForCurrentMode),
                        showIndividualDeleteIcon: !_isMultiSelectMode && !widget.isSelectionMode,
                        onTap: () {
                          if (_isMultiSelectMode) { // Multi-delete selection
                            setState(() {
                              if (isSelectedForCurrentMode) {
                                _selectedBallNames.remove(ball.ball);
                              } else {
                                _selectedBallNames.add(ball.ball);
                              }
                            });
                          } else if (widget.isSelectionMode) { // Page's primary selection mode
                            setState(() {
                              if (isSelectedForCurrentMode) {
                                _selectedBallNames.remove(ball.ball);
                              } else {
                                _selectedBallNames.add(ball.ball);
                              }
                            });
                          } else { // Normal mode: Show details dialog
                            showBallActionDialog(context, ball, () {
                              // Optional: Callback if dialog modifies ball state directly
                              // This setState might be useful if layout is updated and needs redraw
                              setState(() {});
                            });
                          }
                        },
                        onLongPress: () {
                          // Long press for layout only in normal view mode
                          if (!_isMultiSelectMode && !widget.isSelectionMode) {
                            showBallActionDialog(
                              context,
                              ball,
                              () { setState(() {}); }, // For potential redraws after layout update
                              directToLayout: true,
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: (widget.isSelectionMode || _isMultiSelectMode)
          ? null // No FAB in any selection mode
          : FloatingActionButton(
              onPressed: () => _showAddMethodSelectionDialog(context),
              tooltip: '新增武器',
              child: const Icon(Icons.add),
            ),
    );
  }
} 