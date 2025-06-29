import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/training/add_game_advanced_dialog.dart';
import '../../widgets/training/add_game_simple_dialog.dart';
import '../../models/training_record.dart';

// 1. 重構為 StatefulWidget 以管理自定義提示視窗的狀態
class AddGameChoiceDialog extends StatefulWidget {
  final int gameNumber;
  final String dayId;

  const AddGameChoiceDialog({
    Key? key,
    required this.gameNumber,
    required this.dayId,
  }) : super(key: key);

  @override
  State<AddGameChoiceDialog> createState() => _AddGameChoiceDialogState();
}

class _AddGameChoiceDialogState extends State<AddGameChoiceDialog> {
  // 2. 用於管理自定義提示視窗的狀態變數
  OverlayEntry? _overlayEntry;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void dispose() {
    _hideTooltip(); // 確保對話框關閉時，提示視窗也被移除
    super.dispose();
  }

  // 3. 顯示自定義的毛玻璃提示視窗
  void _showTooltip() {
    final overlay = Overlay.of(context);
    final renderBox = _iconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // 全局定位，以使其在對話框之上
        width: MediaQuery.of(context).size.width,
        top: offset.dy + size.height + 8, // 定位在問號圖標下方
        child: Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent, // Material 組件用於正確應用文字樣式
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxWidth: 350), // 4. 限制寬度
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 毛玻璃效果
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // 半透明背景
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'Recommend using detailed scoring for more accurate statistics',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  // 5. 隱藏提示視窗
  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _showSimpleDialog(BuildContext context) async {
    Navigator.pop(context); // Close the selector
    final result = await showAddGameSimpleDialog(context, widget.dayId, widget.gameNumber);
    if (result != null && context.mounted) {
      Navigator.pop(context, result); // Return result to the original caller
    }
  }

  Future<void> _showAdvancedDialog(BuildContext context) async {
    Navigator.pop(context); // Close the selector
    final result = await showAddGameAdvancedDialog(context, widget.dayId, widget.gameNumber);
    if (result != null && context.mounted) {
      Navigator.pop(context, result); // Return result to the original caller
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.05),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0x33000000),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 8),
                          Text(
                            'Choose input method for Game ${widget.gameNumber}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildChoiceOption(
                            context,
                            title: 'Quick Input',
                            subtitle: 'Only input total score, Strikes, Spares',
                            color: Colors.blue,
                            onTap: () => _showSimpleDialog(context),
                          ),
                          const SizedBox(height: 16),
                          _buildChoiceOption(
                            context,
                            title: 'Detailed Scoring',
                            subtitle: 'Use complete score table frame-by-frame input',
                            color: Colors.purple,
                            onTap: () => _showAdvancedDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          'Choose Adding Method',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        // 6. 替換為 GestureDetector 以精確控制長按行為
        GestureDetector(
          key: _iconKey,
          onLongPressStart: (_) => _showTooltip(),
          onLongPressEnd: (_) => _hideTooltip(),
          child: Icon(
            Icons.help_outline_rounded,
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildChoiceOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
} 