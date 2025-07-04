import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/viewmodels/weapon_library_viewmodel.dart';
import 'package:bowlingarsenal_app/widgets/ball_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 列出所有保齡球（可搜尋），點擊選擇，長按查看詳情
class WeaponLibraryPage extends StatefulWidget {
  const WeaponLibraryPage({super.key, this.readOnly = false});
  final bool readOnly;

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
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: BallCardWidget(
            title: ball.ball,
            stat1: ball.rg,
            stat2: ball.diff,
            stat3: ball.mbDiff,
            onTap: () => Navigator.pop(dialogContext),
          ),
        );
      },
    );
  }

  Widget _buildSearchFilterDropdown(
      BuildContext context, WeaponLibraryViewModel viewModel,) {
    // ...原本的篩選 dropdown 不變...
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        
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
        title: Text(widget.readOnly
            ? '球類清單'
            : '選擇武器 (${_selectedBalls.length})',),
        actions: widget.readOnly
            ? null
            : [ /* 保留原本取消與新增按鈕 */ ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            // 搜尋欄
            TextField(
              onChanged: viewModel.filterBalls,
              decoration: const InputDecoration(
                labelText: '搜尋球名',
                prefixIcon: Icon(Icons.search),
                // 讓 theme 處理 border
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12,),
              ),
            ),
            const SizedBox(height: 8),
            // 篩選
            _buildSearchFilterDropdown(context, viewModel),
            const SizedBox(height: 8),
            // 結果列表
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
                      padding: const EdgeInsets.only(bottom: 16),
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
    final isSelected = _selectedBalls.contains(ball);
    return GestureDetector(
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
      child: BallCardWidget(
        title: ball.ball,
        stat1: ball.rg,
        stat2: ball.diff,
        stat3: ball.mbDiff,
        onTap: () => _showBallDetailsDialog(context, ball),
      ),
    );
  }
}
