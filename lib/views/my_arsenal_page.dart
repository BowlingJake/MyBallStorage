import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';
import '../shared/dialogs/layout_dialog.dart'; // Import layout dialog if needed
import 'weapon_library_page.dart'; // <-- Add this import
import 'add_custom_ball_page.dart'; // <-- Add import for the new custom page

/// 顯示使用者目前擁有的武器清單頁面 (支援選擇模式)
class MyArsenalPage extends StatefulWidget { // Changed to StatefulWidget
  final bool isSelectionMode;

  const MyArsenalPage({super.key, this.isSelectionMode = false});

  @override
  State<MyArsenalPage> createState() => _MyArsenalPageState(); // Create State
}

class _MyArsenalPageState extends State<MyArsenalPage> { // State class
  // State to keep track of selected ball names in selection mode
  final Set<String> _selectedBallNames = {};

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

  // --- Ball Card Widget ---
  Widget _buildBallCard(BuildContext context, BowlingBall ball, WeaponLibraryViewModel viewModel) {
    bool isSelected = widget.isSelectionMode && _selectedBallNames.contains(ball.ball);
    bool isMotiv = ball.brand == 'Motiv Bowling';
    bool isStorm = ball.brand == 'Storm Bowling'; // <-- Correct the brand name
    bool hasSpecialBackground = isMotiv || isStorm; // <-- Helper for common styling

    // Define common text styles
    final baseTextStyle = TextStyle(
      color: hasSpecialBackground ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
      shadows: hasSpecialBackground ? [const Shadow(blurRadius: 1.0, color: Colors.black54, offset: Offset(0.5, 0.5))] : null,
    );
    final boldTextStyle = baseTextStyle.copyWith(
      fontSize: 18, 
      fontWeight: FontWeight.bold,
      // Keep consistent shadow for special backgrounds
    );
    final smallTextStyle = baseTextStyle.copyWith(
      fontSize: 12,
      color: hasSpecialBackground ? Colors.white70 : Colors.grey,
      // Keep consistent shadow for special backgrounds
    );
     final detailTextStyle = baseTextStyle.copyWith(
      fontSize: 14, // Adjust size as needed
       // Keep consistent shadow for special backgrounds
    );
    final layoutHeaderStyle = baseTextStyle.copyWith(
      fontWeight: FontWeight.w500,
       // Keep consistent shadow for special backgrounds
    );

    Widget cardContent = InkWell(
      onTap: widget.isSelectionMode
          ? () {
              // Toggle selection state
              setState(() {
                if (isSelected) {
                  _selectedBallNames.remove(ball.ball);
                } else {
                  _selectedBallNames.add(ball.ball);
                }
              });
            }
          : () {
              // Normal mode action
              showBallActionDialog(context, ball, () {
                // Optional: Callback if dialog modifies ball state directly
              });
            },
      child: Stack( // Use Stack to overlay checkmark
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left part (Image, Brand, Date)
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/Jackal EXJ.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        ball.brand,
                        style: smallTextStyle.copyWith(fontWeight: hasSpecialBackground ? FontWeight.w500 : FontWeight.normal),
                      ),
                    ),
                    Text(
                      ball.releaseDate,
                      style: smallTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right part (Details)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ball Name and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ball.ball,
                            style: boldTextStyle,
                          ),
                        ),
                        // Delete Button (Hide in selection mode)
                        if (!widget.isSelectionMode)
                          InkWell(
                            onTap: () => viewModel.removeBallFromArsenal(ball),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: hasSpecialBackground ? Colors.black.withOpacity(0.4) : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: hasSpecialBackground ? Colors.white : Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Core, Coverstock, Stats
                    Text('Core: ${viewModel.getCoreCategory(ball.core)}', style: detailTextStyle, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Cover: ${ball.coverstockcategory}', style: detailTextStyle, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text('RG: ${ball.rg} / Diff: ${ball.diff} / MB: ${ball.mbDiff}', style: detailTextStyle.copyWith(fontSize: 13), overflow: TextOverflow.ellipsis),
                    // Layout Info
                    if (ball.handType != null &&
                        ball.layoutType != null &&
                        ball.layoutValues != null) ...[
                      const SizedBox(height: 10),
                      Divider(color: hasSpecialBackground ? Colors.white30 : Colors.grey[300], height: 1),
                      const SizedBox(height: 10),
                      Text(
                        '${ball.handType} • '
                        '${ball.layoutType == 'Duel' ? 'Duel Angle Layout' : 'VLS/2LS Layout'}',
                        style: layoutHeaderStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ball.layoutType == 'Duel'
                            ? '${ball.layoutValues![0]}° X ${ball.layoutValues![1]} X ${ball.layoutValues![2]}°'
                            : ball.layoutValues!.join(' X '),
                        style: detailTextStyle,
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          // Overlay Checkmark if selected in selection mode
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                  borderRadius: BorderRadius.circular(12), // Match card radius
                ),
                child: const Center(
                  child: Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 40),
                ),
              ),
            ),
        ],
      ),
    );

    // Determine background decoration based on brand
    BoxDecoration? cardDecoration;
    if (isMotiv) {
      cardDecoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/motiv_test.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
        ),
      );
    } else if (isStorm) {
      cardDecoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/storm_test.png'), // <-- Change .jpg to .png
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken), // <-- Apply similar filter
        ),
      );
    } else {
      cardDecoration = null;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: cardContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeaponLibraryViewModel>();
    final filteredArsenal = viewModel.filteredArsenal;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? '選擇賽事用球' : '我的球櫃'),
        actions: [
          // Action button for selection mode (Confirm)
          if (widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: '完成選擇',
              onPressed: () {
                  // Return the list of selected ball NAMES
                  Navigator.pop(context, _selectedBallNames.toList());
              },
            ),
        ],
      ),
      body: Column( // Use Column to stack filter, button, and list/grid
        children: [
          // Filter section
          _buildFilterDropdown(context, viewModel),

          // Search Bar (only in non-selection mode for now, could be enabled)
          if (!widget.isSelectionMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '搜尋我的球櫃...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true, // Make it more compact
                ),
                onChanged: (value) {
                   viewModel.filterArsenal(value); // Use the dedicated method
                },
              ),
            ),
          
          // Add New Ball Button (only in selection mode)
          if (widget.isSelectionMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('新增保齡球至我的球櫃'),
                onPressed: () => _showAddMethodSelectionDialog(context), // Show the dialog
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40), // Make button wider
                ),
              ),
            ),

          // Ball List/Grid section
          Expanded( // Make the GridView/ListView take remaining space
            child: filteredArsenal.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        // Simplified message
                        widget.isSelectionMode 
                           ? '球櫃中無球可選\n點擊上方按鈕新增' // Updated message for selection mode
                           : (viewModel.hasActiveFilters || viewModel.currentArsenalSearchKeyword.isNotEmpty
                              ? '沒有符合條件的球具'
                              : '您的球櫃是空的\n點擊右下角按鈕新增'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 80.0), // Add padding, esp. bottom for FAB
                    itemCount: filteredArsenal.length,
                    itemBuilder: (context, index) {
                      final ball = filteredArsenal[index];
                      // Build the card for each ball
                      return _buildBallCard(context, ball, viewModel);
                    },
                  ),
          ),
        ],
      ),
      // FAB for adding new balls (only in non-selection mode)
      floatingActionButton: widget.isSelectionMode
          ? null // No FAB in selection mode
          : FloatingActionButton(
              onPressed: () => _showAddMethodSelectionDialog(context),
              tooltip: '新增武器',
              child: const Icon(Icons.add),
            ),
    );
  }
} 