import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:ui';

// 新增訓練記錄彈窗
class CreateTrainingRecordDialog extends StatefulWidget {
  final Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern)? onRecordCreated;

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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: 400,
                minWidth: 320,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // 內容
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 標題與關閉按鈕
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Training Record',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 表單
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // 第一排：練習標題
                              _SessionTitleField(controller: _titleController),
                              
                              const SizedBox(height: 20),
                              
                              // 第二排：日期和場館
                              Row(
                                children: [
                                  // 日期選擇
                                  Expanded(
                                    child: _DateSelector(
                                      selectedDate: _selectedDate,
                                      onDateSelected: _selectDate,
                                    ),
                                  ),
                                  
                                  SizedBox(width: 12),
                                  
                                  // 球館名稱
                                  Expanded(
                                    child: _BowlingCenterField(controller: _centerNameController),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // 第三排：油圖設定
                              _OilPatternSection(
                                nameController: _oilPatternNameController,
                                lengthController: _oilPatternLengthController,
                                isHousePattern: _isHousePattern,
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
                              
                              const SizedBox(height: 32),
                              
                              // 按鈕
                              _ActionButtons(onSave: _saveRecord),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 練習標題輸入欄位
class _SessionTitleField extends StatelessWidget {
  final TextEditingController controller;

  const _SessionTitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      maxLength: 20, // 限制標題長度為20字
      decoration: InputDecoration(
        labelText: 'Session Title',
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(Icons.title, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        counterStyle: TextStyle(color: Colors.white54, fontSize: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter session title';
        }
        return null;
      },
    );
  }
}

// 日期選擇器
class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(BuildContext) onDateSelected;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDateSelected(context),
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.year}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 保齡球館輸入欄位
class _BowlingCenterField extends StatelessWidget {
  final TextEditingController controller;

  const _BowlingCenterField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Bowling Center',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        prefixIcon: Icon(Icons.location_on, color: Colors.white, size: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }
}

// 油圖設定區域
class _OilPatternSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lengthController;
  final bool isHousePattern;
  final Function(bool) onHousePatternChanged;

  const _OilPatternSection({
    required this.nameController,
    required this.lengthController,
    required this.isHousePattern,
    required this.onHousePatternChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題
          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Oil Pattern (Optional)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // House Pattern 選項
          GestureDetector(
            onTap: () => onHousePatternChanged(!isHousePattern),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isHousePattern 
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: isHousePattern 
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.3),
                  width: isHousePattern ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isHousePattern ? Icons.check_circle : Icons.circle_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'House Pattern',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isHousePattern ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // 當不是 House Pattern 時顯示自訂欄位
          if (!isHousePattern) ...[
            Text(
              'Custom Oil Pattern',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                // 油型名稱
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),
                
                SizedBox(width: 8),
                
                // 油型長度
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: lengthController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Length',
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      suffixText: 'ft',
                      suffixStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// 操作按鈕
class _ActionButtons extends StatelessWidget {
  final VoidCallback onSave;

  const _ActionButtons({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GFButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "Cancel",
            type: GFButtonType.outline,
            color: Colors.white,
            size: GFSize.MEDIUM,
            shape: GFButtonShape.pills,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GFButton(
            onPressed: onSave,
            text: "Save",
            type: GFButtonType.outline,
            color: Colors.white,
            size: GFSize.MEDIUM,
            shape: GFButtonShape.pills,
          ),
        ),
      ],
    );
  }
}

// 顯示新增訓練記錄彈窗的輔助函數
void showCreateTrainingRecordDialog(
  BuildContext context, 
  Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern)? onRecordCreated,
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