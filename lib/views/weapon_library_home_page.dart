import 'package:flutter/material.dart';
import '../models/bowling_ball.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import 'weapon_library_page.dart';
import '../shared/dialogs/layout_dialog.dart';
import 'package:provider/provider.dart';
import 'my_arsenal_page.dart';

/// 武器庫主頁 (顯示導航選項)
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
                Navigator.push<List<BowlingBall>>(
                  context,
                  MaterialPageRoute(builder: (_) => const WeaponLibraryPage()),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeaponLibraryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('武器庫'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyArsenalPage()),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '我的球櫃',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              viewModel.myArsenal.isEmpty ? '還沒有球，點此查看與添加' : '查看已添加的 ${viewModel.myArsenal.length} 個球具',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeaponLibraryPage(readOnly: true),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.list_alt_outlined, color: Colors.white, size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '球類資料庫',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '瀏覽所有可用的球具資訊',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('排行榜功能即將推出！')),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.leaderboard_outlined, color: Colors.white, size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '排行榜',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '查看社群排名（即將推出）',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
                  label: const Text('新增武器到我的球櫃', style: TextStyle(color: Colors.blueAccent)),
                  onPressed: () => _showAddMethodSelectionDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
