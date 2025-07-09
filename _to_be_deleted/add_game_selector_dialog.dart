import 'dart:ui';

import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/widgets/training/add_game_advanced_dialog.dart';
import 'package:bowlingarsenal_app/widgets/training/add_game_simple_dialog.dart';
import 'package:flutter/material.dart';

/// 新增遊戲方式選擇器對話框
class AddGameSelectorDialog extends StatelessWidget {
  const AddGameSelectorDialog({
    required this.dayId,
    required this.nextGameNumber,
    super.key,
  });
  final String dayId;
  final int nextGameNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 標題
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Adding Method',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Choose input method for Game $nextGameNumber',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 24),

                // 選項列表
                _buildOptionCard(
                  context,
                  icon: Icons.speed,
                  title: 'Quick Input',
                  subtitle: 'Only input total score, Strikes, Spares',
                  description: 'Suitable for quick basic data recording',
                  color: Colors.blue,
                  onTap: () => _showSimpleDialog(context),
                ),

                const SizedBox(height: 16),

                _buildOptionCard(
                  context,
                  icon: Icons.grid_on,
                  title: 'Detailed Scoring',
                  subtitle: 'Use complete score table frame-by-frame input',
                  description: 'Get complete score statistics and analysis',
                  color: Colors.purple,
                  onTap: () => _showAdvancedDialog(context),
                ),

                const SizedBox(height: 24),

                // 說明文字
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recommend using detailed scoring for more accurate statistics',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSimpleDialog(BuildContext context) async {
    Navigator.pop(context); // 關閉選擇器
    final result = await showAddGameSimpleDialog(
      context,
      dayId,
      nextGameNumber,
    );
    if (result != null) {
      Navigator.pop(context, result); // 返回結果到原始調用者
    }
  }

  Future<void> _showAdvancedDialog(BuildContext context) async {
    Navigator.pop(context); // 關閉選擇器
    final result = await showAddGameAdvancedDialog(
      context,
      dayId,
      nextGameNumber,
    );
    if (result != null) {
      Navigator.pop(context, result); // 返回結果到原始調用者
    }
  }
}

/// 顯示新增遊戲選擇器對話框的輔助函數
Future<GameRecord?> showAddGameSelectorDialog(
  BuildContext context,
  String dayId,
  int nextGameNumber,
) async {
  return showDialog<GameRecord>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: AddGameSelectorDialog(
          dayId: dayId,
          nextGameNumber: nextGameNumber,
        ),
      );
    },
  );
}
