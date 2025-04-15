import 'package:flutter/material.dart';
import '../models/bowling_ball.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import 'weapon_library_page.dart';
import '../shared/dialogs/layout_dialog.dart';
import 'package:provider/provider.dart';

/// 武器庫主頁 (顯示我的 Arsenal)
class WeaponLibraryHomePage extends StatelessWidget {
  const WeaponLibraryHomePage({super.key});

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
                Navigator.push<BowlingBall>(
                  context,
                  MaterialPageRoute(builder: (_) => const WeaponLibraryPage()),
                ).then((selectedBall) {
                  if (selectedBall != null) {
                    viewModel.addBallToArsenal(selectedBall);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

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
    // Use the filtered list from ViewModel
    final myFilteredArsenal = viewModel.filteredArsenal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('武器庫'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 2,
              ),
              icon: const Icon(Icons.add),
              label: const Text('添加我的武器'),
              onPressed: () {
                _showAddMethodSelectionDialog(context);
              },
            ),
          ),
        ],
      ),
      body: Column( // Wrap body content in a Column
        children: [
          // Add Search Bar here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              onChanged: (keyword) => viewModel.filterArsenal(keyword),
              decoration: const InputDecoration(
                labelText: '搜尋我的武器',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                // Optional: Add clear button
                // suffixIcon: IconButton(
                //   icon: Icon(Icons.clear),
                //   onPressed: () {
                //     // Clear text field and filter
                //   },
                // ),
              ),
            ),
          ),
          // Add the filter dropdowns here
          _buildFilterDropdown(context, viewModel),
          // The list view
          Expanded( // Make ListView take remaining space
            child: myFilteredArsenal.isEmpty
                ? const Center(
                    child: Text(
                      '沒有符合條件的武器，請調整篩選器或添加武器。',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12), // Adjust padding
                    itemCount: myFilteredArsenal.length,
                    itemBuilder: (context, index) {
                      final ball = myFilteredArsenal[index];
                      return InkWell(
                        onTap: () {
                          showBallActionDialog(context, ball, () {
                            viewModel.notifyListeners();
                          });
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Center(child: Text('圖片')),
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          ball.brand,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Text(
                                        ball.releaseDate,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ball.ball,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => viewModel.removeBallFromArsenal(ball),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Core Category: ${ball.core.split(' ').last}', overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      Text('Coverstock Category: ${ball.coverstockcategory}', overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 8),
                                      Text('RG: ${ball.rg} / Diff: ${ball.diff} / MB: ${ball.mbDiff}', overflow: TextOverflow.ellipsis),
                                      if (ball.handType != null &&
                                          ball.layoutType != null &&
                                          ball.layoutValues != null) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          '${ball.handType} • '
                                          '${ball.layoutType == 'Duel' ? 'Duel Angle Layout' : 'VLS/2LS Layout'}',
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          ball.layoutType == 'Duel'
                                              ? '${ball.layoutValues![0]}° X ${ball.layoutValues![1]} X ${ball.layoutValues![2]}°'
                                              : ball.layoutValues!.join(' X '),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
