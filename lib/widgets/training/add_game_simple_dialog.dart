import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/training_record.dart';
import '../app_standard_button.dart';

/// 簡化版新增遊戲對話框
/// 快速輸入分數而不需要詳細的格數據
class AddGameSimpleDialog extends StatefulWidget {
  final String dayId;
  final int nextGameNumber;

  const AddGameSimpleDialog({
    Key? key,
    required this.dayId,
    required this.nextGameNumber,
  }) : super(key: key);

  @override
  State<AddGameSimpleDialog> createState() => _AddGameSimpleDialogState();
}

class _AddGameSimpleDialogState extends State<AddGameSimpleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  final _strikesController = TextEditingController();
  final _sparesController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _scoreController.dispose();
    _strikesController.dispose();
    _sparesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveGame() {
    if (_formKey.currentState!.validate()) {
      final score = int.parse(_scoreController.text);
      final strikes = int.parse(_strikesController.text);
      final spares = int.parse(_sparesController.text);

      // 簡化的分數計算
      final averagePerFrame = score / 10;
      final frameScores = List.generate(10, (index) => averagePerFrame.round());

      final game = GameRecord(
        id: '${widget.dayId}_game_${DateTime.now().millisecondsSinceEpoch}',
        gameNumber: widget.nextGameNumber,
        score: score,
        frameScores: frameScores,
        strikes: strikes,
        spares: spares,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        timestamp: DateTime.now(),
      );

      Navigator.of(context).pop(game);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '新增第 ${widget.nextGameNumber} 局',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // 分數輸入
              _buildNumberField(
                controller: _scoreController,
                label: '總分',
                hint: '0-300',
                maxValue: 300,
                isRequired: true,
              ),

              SizedBox(height: 16),

              // Strikes 和 Spares 輸入
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      controller: _strikesController,
                      label: 'Strikes',
                      hint: '0-10',
                      maxValue: 10,
                      isRequired: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(
                      controller: _sparesController,
                      label: 'Spares',
                      hint: '0-10',
                      maxValue: 10,
                      isRequired: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 備註輸入
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '備註（選填）',
                  labelStyle: TextStyle(color: Colors.white70),
                  hintText: '本局表現、心得...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),

              SizedBox(height: 24),

              // 底部按鈕
              Row(
                children: [
                  Expanded(
                    child: AppStandardButton(
                      text: '取消',
                      onPressed: () => Navigator.pop(context),
                      customColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: '保存',
                      onPressed: _saveGame,
                      customColor: theme.colorScheme.primary,
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxValue,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '請輸入$label';
        }
        if (value != null && value.isNotEmpty) {
          final intValue = int.tryParse(value);
          if (intValue == null) {
            return '請輸入有效數字';
          }
          if (intValue < 0 || intValue > maxValue) {
            return '$label 應在 0-$maxValue 之間';
          }
        }
        return null;
      },
    );
  }
}

/// 顯示新增遊戲對話框的輔助函數
Future<GameRecord?> showAddGameSimpleDialog(
  BuildContext context,
  String dayId,
  int nextGameNumber,
) async {
  return await showDialog<GameRecord>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: AddGameSimpleDialog(
          dayId: dayId,
          nextGameNumber: nextGameNumber,
        ),
      );
    },
  );
} 