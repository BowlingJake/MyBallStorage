import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';
import '../shared/dialogs/layout_dialog.dart'; // Import layout dialog if needed
import 'weapon_library_page.dart'; // <-- Add this import

/// 顯示使用者目前擁有的武器清單頁面
class MyArsenalPage extends StatelessWidget {
  const MyArsenalPage({super.key});

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
              onPressed: null, // Disabled for now
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

    Widget cardContent = Row(
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
                   color: hasSpecialBackground ? Colors.black.withOpacity(0.2) : Colors.grey[300],
                   borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('圖片', style: TextStyle(color: Colors.white70))),
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
                  // Delete Button
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

    return InkWell(
      onTap: () {
        showBallActionDialog(context, ball, () {
          viewModel.notifyListeners();
        });
      },
      child: Card(
        elevation: hasSpecialBackground ? 5 : 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // side: hasSpecialBackground ? BorderSide(color: Colors.grey.shade700, width: 0.5) : BorderSide.none, // Optional subtle border
        ),
        child: Container(
           decoration: cardDecoration, // <-- Apply dynamic decoration
           child: Padding(
             padding: const EdgeInsets.all(12.0),
             child: cardContent,
           ),
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
        title: const Text('我的球櫃'),
        actions: [
          // Use FilledButton.icon for better visibility with its own background
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('添加保齡球至球櫃'),
              onPressed: () => _showAddMethodSelectionDialog(context),
              // style: FilledButton.styleFrom(
              //   // You can customize the style further if needed,
              //   // e.g., backgroundColor, foregroundColor
              //   // visualDensity: VisualDensity.compact, // Make it slightly smaller if needed
              // ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterDropdown(context, viewModel),
          Expanded(
            child: filteredArsenal.isEmpty
                ? Center(
                    child: Text(
                      viewModel.hasActiveFilters
                          ? '沒有符合條件的球具\n請調整篩選器或添加新球具'
                          : '您的球櫃是空的！\n點擊右上角 + 新增球具',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemCount: filteredArsenal.length,
                    itemBuilder: (context, index) {
                      final ball = filteredArsenal[index];
                      return _buildBallCard(context, ball, viewModel);
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 