import 'package:flutter/material.dart';
import '../../models/bowling_ball.dart';

enum _DialogView { selection, details, layoutInput }

/// 共用的顯示 Layout 設定與詳細資料的 Dialog
void showBallActionDialog(BuildContext context, BowlingBall ball, VoidCallback onUpdated) {
  _DialogView currentView = _DialogView.selection;

  // Keep track of layout input values within the dialog's state
  String? handType = ball.handType ?? 'One Handed';
  String? layoutType = ball.layoutType ?? 'Duel';
  final field1 = TextEditingController(text: ball.layoutValues?.elementAtOrNull(0) ?? '');
  final field2 = TextEditingController(text: ball.layoutValues?.elementAtOrNull(1) ?? '');
  final field3 = TextEditingController(text: ball.layoutValues?.elementAtOrNull(2) ?? '');

  showDialog(
    context: context,
    // Use StatefulBuilder to manage the internal state (current view)
    builder: (dialogContext) { // Use a different context name to avoid confusion
      return StatefulBuilder(
        builder: (statefulContext, setState) {
          Widget content;
          List<Widget> actions;
          String title;

          switch (currentView) {
            case _DialogView.details:
              title = '詳細資料';
              content = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Core: ${ball.core}'),
                  const SizedBox(height: 8),
                  Text('Coverstock Name: ${ball.coverstockname}'),
                ],
              );
              actions = [
                TextButton(
                  onPressed: () {
                    // Go back to selection view
                    setState(() {
                      currentView = _DialogView.selection;
                    });
                  },
                  child: const Text('返回'),
                ),
              ];
              break;

            case _DialogView.layoutInput:
              title = ball.ball; // Show ball name as title for layout input
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hand Type Selection
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('1 Handed'),
                        selected: handType == 'One Handed',
                        onSelected: (_) => setState(() => handType = 'One Handed'),
                      ),
                      ChoiceChip(
                        label: const Text('2 Handed'),
                        selected: handType == 'Two Handed',
                        onSelected: (_) => setState(() => handType = 'Two Handed'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Layout Type Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('Duel Angle'),
                        selected: layoutType == 'Duel',
                        onSelected: (_) => setState(() => layoutType = 'Duel'),
                      ),
                      ChoiceChip(
                        label: const Text('VLS/2LS'),
                        selected: layoutType == 'VLS',
                        onSelected: (_) => setState(() => layoutType = 'VLS'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Layout Value Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLayoutField(field1, layoutType == 'Duel', isAngle: true),
                      const Text('  X  ', style: TextStyle(fontSize: 10)),
                      _buildLayoutField(field2, false),
                      const Text('  X  ', style: TextStyle(fontSize: 10)),
                      _buildLayoutField(field3, layoutType == 'Duel', isAngle: true),
                    ],
                  ),
                ],
              );
              actions = [
                 TextButton(
                  onPressed: () {
                    setState(() {
                      handType = null;
                      layoutType = null;
                      field1.clear();
                      field2.clear();
                      field3.clear();
                      ball.handType = null;
                      ball.layoutType = null;
                      ball.layoutValues = null;
                    });
                     // Optionally call onUpdated if clearing should persist immediately
                     // onUpdated();
                  },
                  child: const Text('清空'),
                ),
                TextButton(
                  onPressed: () {
                    // Go back to selection view
                    setState(() {
                      currentView = _DialogView.selection;
                    });
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    // Save layout and close the entire dialog
                    ball.handType = handType;
                    ball.layoutType = layoutType;
                    ball.layoutValues = [field1.text, field2.text, field3.text];
                    onUpdated();
                    Navigator.pop(dialogContext); // Close the dialog fully
                  },
                  child: const Text('確認'),
                ),
              ];
              break;

            case _DialogView.selection:
            default:
              title = '選擇操作';
              content = const Text('您想要執行哪個操作？');
              actions = [
                TextButton(
                  onPressed: () {
                     Navigator.pop(dialogContext); // Close the dialog fully
                  },
                  child: const Text('取消'), // This cancels the whole operation
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentView = _DialogView.details;
                    });
                  },
                  child: const Text('查看詳細資料'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentView = _DialogView.layoutInput;
                    });
                  },
                  child: const Text('輸入 Layout'),
                ),
              ];
              break;
          }

          return AlertDialog(
            title: Text(title),
            content: content,
            actions: actions,
          );
        },
      );
    },
  );
}


// Helper function for layout fields remains the same
Widget _buildLayoutField(TextEditingController controller, bool showAngle, {bool isAngle = false}) {
  return SizedBox(
    width: 30,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        if (showAngle && isAngle)
          const Text('°', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
