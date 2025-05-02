import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';
import '../widgets/ball_card_widget.dart';

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

  /// 顯示球具詳細的浮動視窗，使用 BallCardWidget
  void _showBallDetailsDialog(BuildContext context, BowlingBall ball) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: BallCardWidget(
            title: ball.ball,
            stat1: ball.rg.toString(),
            stat2: ball.diff.toString(),
            stat3: ball.mbDiff.toString(),
            onTap: () => Navigator.pop(dialogContext),
          ),
        );
      },
    );
  }

  Widget _buildSearchFilterDropdown(BuildContext context, WeaponLibraryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Row(
        children: [ /* 篩選 UI 不變 */ ],
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
                  onPressed: () => setState(() => _selectedBalls.clear()),
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
                        : () => Navigator.pop(context, _selectedBalls),
                    child: Text('新增 (${_selectedBalls.length})'),
                  ),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            TextField(
              onChanged: (keyword) => viewModel.filterBalls(keyword),
              decoration: const InputDecoration(
                labelText: '搜尋球名',
                prefixIcon: Icon(Icons.search),
                // 使用 theme 處理 border 等樣式
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
            const SizedBox(height: 8),
            _buildSearchFilterDropdown(context, viewModel),
            const SizedBox(height: 8),
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
      // 長按才彈窗
      onLongPress: () => _showBallDetailsDialog(context, ball),
      child: Card(
        elevation: isSelected ? 6 : 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
              : BorderSide.none,
        ),
        color: isSelected
            ? Theme.of(context).primaryColorLight.withOpacity(0.3)
            : null,
        child: InkWell(
          onTap: widget.readOnly
              ? null
              : () {
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
                        child: const Center(
                          child: Icon(Icons.sports_baseball, color: Colors.white70, size: 30),
                        ),
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
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
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
                    child: Icon(Icons.check_circle,
                        color: Theme.of(context).primaryColor, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
