import 'package:flutter/material.dart';
import 'components/form_fields.dart';
import 'components/scoring_method_selector.dart';
import '../common/glass_dialog_base.dart';
import '../../models/training_record.dart';

// 編輯訓練記錄彈窗
class EditTrainingRecordDialog extends StatefulWidget {
  final TrainingDaySummary summary;
  final Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod)? onRecordUpdated;

  const EditTrainingRecordDialog({
    Key? key,
    required this.summary,
    this.onRecordUpdated,
  }) : super(key: key);

  @override
  State<EditTrainingRecordDialog> createState() => _EditTrainingRecordDialogState();
}

class _EditTrainingRecordDialogState extends State<EditTrainingRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _centerNameController;
  late final TextEditingController _oilPatternNameController;
  late final TextEditingController _oilPatternLengthController;
  late DateTime _selectedDate;
  late bool _isHousePattern;
  late String _selectedScoringMethod;

  @override
  void initState() {
    super.initState();
    // 預填入現有數據
    _titleController = TextEditingController(text: widget.summary.title);
    _centerNameController = TextEditingController(text: widget.summary.center);
    _oilPatternNameController = TextEditingController(text: widget.summary.oilPatternName ?? '');
    _oilPatternLengthController = TextEditingController(text: widget.summary.oilPatternLength ?? '');
    _selectedDate = widget.summary.date;
    _isHousePattern = widget.summary.isHousePattern;
    _selectedScoringMethod = widget.summary.scoringMethod;
  }

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

  void _updateRecord() {
    if (_formKey.currentState!.validate()) {
      // 調用回調函數來更新記錄
      if (widget.onRecordUpdated != null) {
        widget.onRecordUpdated!(
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
          content: Text('Training record updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialogBase(
      title: 'Edit Training Record',
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
          text: 'Update',
          onPressed: _updateRecord,
          isPrimary: true,
        ),
      ],
    );
  }
}

// 顯示編輯訓練記錄彈窗的輔助函數
void showEditTrainingRecordDialog(
  BuildContext context, 
  TrainingDaySummary summary,
  Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod)? onRecordUpdated,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: EditTrainingRecordDialog(
          summary: summary,
          onRecordUpdated: onRecordUpdated,
        ),
      );
    },
  );
} 