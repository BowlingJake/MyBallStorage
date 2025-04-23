import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';

/// 列出所有保齡球（可搜尋），點擊選擇，長按查看詳情
class WeaponLibraryPage extends StatefulWidget {
  final bool readOnly;
  
  const WeaponLibraryPage({
    super.key,
    this.readOnly = false,
  });

  @override
  State<WeaponLibraryPage> createState() => _WeaponLibraryPageState();
}

class _WeaponLibraryPageState extends State<WeaponLibraryPage> {
  final List<BowlingBall> _selectedBalls = [];
  bool _hasLoadedData = false;

  void _showBallDetailsDialog(BuildContext context, BowlingBall ball) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ball.ball),
          content: const SingleChildScrollView(
            child: Text('詳細資訊待補...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('返回'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedData) {
      context.read<WeaponLibraryViewModel>().loadBallData();
      _hasLoadedData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeaponLibraryViewModel>();
    final searchResults = viewModel.filteredBallsForSearch;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.readOnly ? '球類清單' : '選擇武器 (${_selectedBalls.length})'),
        actions: widget.readOnly
            ? null
            : [
                TextButton(
                  child: const Text('取消選取'),
                  onPressed: () {
                    setState(() {
                      _selectedBalls.clear();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                     ),
                    onPressed: _selectedBalls.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context, _selectedBalls);
                          },
                    child: Text('新增 (${_selectedBalls.length})'),
                  ),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            // Search Text Field
            TextField(
              onChanged: (keyword) => viewModel.filterBalls(keyword),
              decoration: const InputDecoration(
                labelText: '搜尋球名',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
             const SizedBox(height: 8),
            // Filter Dropdowns
            _buildSearchFilterDropdown(context, viewModel),
            const SizedBox(height: 8),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final ball = searchResults[index];
                        return _buildBallCard(context, ball);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallCard(BuildContext context, BowlingBall ball) {
    final bool isSelected = _selectedBalls.contains(ball);

    return GestureDetector(
      onLongPress: () {
        _showBallDetailsDialog(context, ball);
      },
      child: Card(
        elevation: isSelected ? 6 : 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
              : BorderSide.none,
        ),
        color: isSelected ? Theme.of(context).primaryColorLight.withOpacity(0.3) : null,
        child: InkWell(
          onTap: widget.readOnly ? null : () {
            setState(() {
              if (isSelected) {
                _selectedBalls.remove(ball);
              } else {
                _selectedBalls.add(ball);
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Icon(Icons.sports_baseball, color: Colors.white70, size: 30)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ball.brand,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ball.releaseDate,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                         textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ball.ball,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Core: ${context.read<WeaponLibraryViewModel>().getCoreCategory(ball.core)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                       const SizedBox(height: 4),
                      Text(
                        'Cover: ${ball.coverstockcategory}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected && !widget.readOnly)
                   Padding(
                     padding: const EdgeInsets.only(left: 4.0),
                     child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20),
                   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
