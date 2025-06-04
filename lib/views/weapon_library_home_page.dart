import 'package:flutter/material.dart';
import '../models/bowling_ball.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import 'weapon_library_page.dart';
import '../shared/dialogs/layout_dialog.dart';
import 'package:provider/provider.dart';
import 'ball_library_page.dart';
import '../theme/text_styles.dart';

/// 武器庫主頁 (顯示導航選項)
class WeaponLibraryHomePage extends StatelessWidget {
  const WeaponLibraryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeaponLibraryViewModel>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('武器庫'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 我的球櫃 Button (Full Width)
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
                              MaterialPageRoute(builder: (context) => const BallLibraryPage()),
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

                      // Row 1: Database & Leaderboard
                      Row(
                        children: [
                          // 球類資料庫 Button (Half Width)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 6, bottom: 12),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                  children: const [
                                    Icon(Icons.list_alt_outlined, color: Colors.white, size: 28),
                                    SizedBox(height: 8),
                                    Text(
                                      '球類資料庫',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Slightly smaller font
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 排行榜 Button (Half Width)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 6, bottom: 12),
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
                                    const SnackBar(content: Text('排行榜功能即將推出！', style: AppTextStyles.subtitle)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                  children: const [
                                    Icon(Icons.leaderboard_outlined, color: Colors.white, size: 28),
                                    SizedBox(height: 8),
                                    Text(
                                      '排行榜',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Slightly smaller font
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Row 2: Update 1 & Update 2
                      Row(
                        children: [
                          // 待更新 Button (Half Width)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 6, bottom: 12),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  backgroundColor: Colors.grey, // 使用灰色背景
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('此功能待更新！', style: AppTextStyles.body)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                  children: const [
                                    Icon(Icons.help_outline, color: Colors.white, size: 28), // 使用問號圖標
                                    SizedBox(height: 8),
                                    Text(
                                      '待更新',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Slightly smaller font
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 待更新 Button 2 (Half Width)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 6, bottom: 12),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  backgroundColor: Colors.grey.shade600, // 使用深灰色背景
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('此功能待更新！', style: AppTextStyles.body)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                  children: const [
                                    Icon(Icons.build_circle_outlined, color: Colors.white, size: 28), // 使用工具圖標
                                    SizedBox(height: 8),
                                    Text(
                                      '球具分析',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Slightly smaller font
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
