import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';

/// 列出所有保齡球（可搜尋），點擊即返回選擇的球
class WeaponLibraryPage extends StatelessWidget {
  const WeaponLibraryPage({super.key});

  Widget _buildSearchFilterDropdown(BuildContext context, WeaponLibraryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0), // Adjust padding if needed
      child: Row(
        children: [
          // Brand Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedBrandFilterForSearch, // Allow null for hint
              hint: const Text('品牌'),
              items: viewModel.allAvailableBrands.map((String brand) {
                return DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedBrandFilterForSearch(newValue);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Core Category Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedCoreCategoryFilterForSearch, // Allow null for hint
              hint: const Text('Core'),
              items: viewModel.allAvailableCoreCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedCoreCategoryFilterForSearch(newValue);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Coverstock Category Filter
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: viewModel.selectedCoverstockCategoryFilterForSearch, // Allow null for hint
              hint: const Text('Cover'),
              items: viewModel.allAvailableCoverstockCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                viewModel.updateSelectedCoverstockCategoryFilterForSearch(newValue);
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
    final searchResults = viewModel.filteredBallsForSearch;

    return Scaffold(
      appBar: AppBar(title: const Text('新增武器庫')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Text Field
            TextField(
              onChanged: (keyword) => viewModel.filterBalls(keyword),
              decoration: const InputDecoration(
                labelText: '搜尋球名',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            // Filter Dropdowns
            _buildSearchFilterDropdown(context, viewModel),
            // Results List
            Expanded(
              child: searchResults.isEmpty
                ? const Center(
                    child: Text(
                      '找不到符合條件的球。',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final ball = searchResults[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop<BowlingBall>(context, ball);
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
                                    Text(
                                      ball.ball,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Displaying relevant info for search results
                                    Text('Core: ${ball.core}', overflow: TextOverflow.ellipsis),
                                    Text('Coverstock: ${ball.coverstockname} (${ball.coverstockcategory})', overflow: TextOverflow.ellipsis),
                                    Text('RG: ${ball.rg} / Diff: ${ball.diff} / MB: ${ball.mbDiff}', overflow: TextOverflow.ellipsis),
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
      ),
    );
  }
}
