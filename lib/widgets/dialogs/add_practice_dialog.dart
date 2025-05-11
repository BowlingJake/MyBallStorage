import 'package:flutter/material.dart';
import '../../theme/text_styles.dart';
import '../primary_button.dart';

class AddPracticeDialog extends StatefulWidget {
  const AddPracticeDialog({super.key});

  @override
  State<AddPracticeDialog> createState() => _AddPracticeDialogState();
}

class _AddPracticeDialogState extends State<AddPracticeDialog> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _oilPatternController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _locationController.dispose();
    _oilPatternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新增練習紀錄', style: AppTextStyles.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 日期選擇器
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '練習日期',
                  labelStyle: AppTextStyles.body,
                ),
                child: Text(
                  '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                  style: AppTextStyles.body,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 地點輸入
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '練習地點',
                labelStyle: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 16),
            // 油尺輸入
            TextField(
              controller: _oilPatternController,
              decoration: const InputDecoration(
                labelText: '練習油尺（選填）',
                labelStyle: AppTextStyles.body,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消', style: AppTextStyles.button),
        ),
        MyCustomButton(
          text: '確認',
          onPressed: () {
            if (_locationController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請填寫練習地點', style: AppTextStyles.body)),
              );
              return;
            }
            
            Navigator.pop(context, {
              'date': '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
              'location': _locationController.text,
              'oilPattern': _oilPatternController.text,
              'scores': [],
            });
          },
        ),
      ],
    );
  }
} 