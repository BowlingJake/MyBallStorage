import 'package:flutter/material.dart';
import 'components/form_fields.dart';
import 'components/scoring_method_selector.dart';
import '../common/glass_dialog_base.dart';

// 新增訓練記錄彈窗
class CreateTrainingRecordDialog extends StatefulWidget {
  final Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod)? onRecordCreated;

  const CreateTrainingRecordDialog({
    Key? key,
    this.onRecordCreated,
  }) : super(key: key);

  @override
  State<CreateTrainingRecordDialog> createState() => _CreateTrainingRecordDialogState();
}

class _CreateTrainingRecordDialogState extends State<CreateTrainingRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _centerNameController = TextEditingController();
  final _oilPatternNameController = TextEditingController();
  final _oilPatternLengthController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isHousePattern = false;
  String _selectedScoringMethod = 'traditional'; // 'traditional' 或 'current'

  @override
  void dispose() {
    _titleController.dispose();
    _centerNameController.dispose();
    _oilPatternNameController.dispose();
    _oilPatternLengthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      // 調用回調函數來創建記錄
      if (widget.onRecordCreated != null) {
        widget.onRecordCreated!(
          _titleController.text,
          _selectedDate,
          _centerNameController.text,
          _oilPatternNameController.text.isEmpty ? null : _oilPatternNameController.text,
          _oilPatternLengthController.text.isEmpty ? null : _oilPatternLengthController.text,
          _isHousePattern,
          _selectedScoringMethod,
        );
      }
      
      Navigator.of(context).pop();
      
      // 顯示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Training record saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialogBase(
      title: 'Add Training Record',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 練習標題
            SessionTitleField(controller: _titleController),
            
            const SizedBox(height: 20),
            
            // 日期和場館
            Row(
              children: [
                // 日期選擇
                Expanded(
                  child: DateSelector(
                    selectedDate: _selectedDate,
                    onDateSelected: _selectDate,
                  ),
                ),
                
                SizedBox(width: 12),
                
                // 球館名稱
                Expanded(
                  child: LocationField(controller: _centerNameController),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 油圖設定
            OilPatternSelector(
              isHousePattern: _isHousePattern,
              nameController: _oilPatternNameController,
              lengthController: _oilPatternLengthController,
              onHousePatternChanged: (value) {
                setState(() {
                  _isHousePattern = value;
                  if (value) {
                    // 如果選擇 House Pattern，清空其他欄位
                    _oilPatternNameController.clear();
                    _oilPatternLengthController.clear();
                  }
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // 計分方式設定
            ScoringMethodSelector(
              selectedMethod: _selectedScoringMethod,
              onMethodSelected: (method) {
                setState(() {
                  _selectedScoringMethod = method;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        DialogButton(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          isPrimary: false,
        ),
        SizedBox(width: 16),
        DialogButton(
          text: 'Save',
          onPressed: _saveRecord,
          isPrimary: true,
        ),
      ],
    );
  }
}

// 顯示新增訓練記錄彈窗的輔助函數
void showCreateTrainingRecordDialog(
  BuildContext context, 
  Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod)? onRecordCreated,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: CreateTrainingRecordDialog(
          onRecordCreated: onRecordCreated,
        ),
      );
    },
  );
} 