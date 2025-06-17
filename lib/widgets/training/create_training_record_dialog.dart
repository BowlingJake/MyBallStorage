import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';

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
                              
                              const SizedBox(height: 20),
                              
                              // 第四排：計分方式設定
                              _ScoringMethodSection(
                                selectedMethod: _selectedScoringMethod,
                                onMethodSelected: (method) {
                                  setState(() {
                                    _selectedScoringMethod = method;
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
            Icon(Iconsax.calendar_1, color: Colors.white.withOpacity(0.8), size: 20),
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
        prefixIcon: Icon(Iconsax.location, color: Colors.white.withOpacity(0.8), size: 20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Oil Pattern (Optional)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              // House Pattern 按鈕移到這裡
              GestureDetector(
                onTap: () => onHousePatternChanged(!isHousePattern),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'House Pattern',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: isHousePattern ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
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

// 計分方式選擇器
class _ScoringMethodSection extends StatefulWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const _ScoringMethodSection({
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<_ScoringMethodSection> createState() => _ScoringMethodSectionState();
}

class _ScoringMethodSectionState extends State<_ScoringMethodSection> {
  OverlayEntry? _tooltipOverlay;

  void _showTooltip(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    _tooltipOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideTooltip,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            left: position.dx - 50,
            top: position.dy + 40,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(
                              text: 'Traditional Scoring:\n',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                            TextSpan(
                              text: 'Classic 10-pin scoring with cumulative frame totals. Bonus points from next rolls.\n\n',
                            ),
                            TextSpan(
                              text: 'Current Scoring (World Bowling):\n',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                            TextSpan(
                              text: 'Modern pin-based scoring. Strike = 30 points, spare = 10 + first roll.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    Overlay.of(context).insert(_tooltipOverlay!);
  }

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          // 標題與問號按鈕
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scoring Method',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onLongPressStart: (_) => _showTooltip(context),
                onLongPressEnd: (_) => _hideTooltip(),
                onTapDown: (_) => _showTooltip(context),
                onTapUp: (_) => _hideTooltip(),
                onTapCancel: () => _hideTooltip(),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.question_mark,
                    size: 8,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 兩個並排按鈕
          Row(
            children: [
              // Traditional Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('traditional'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.selectedMethod == 'traditional' 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: widget.selectedMethod == 'traditional' 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'traditional' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Traditional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: widget.selectedMethod == 'traditional' ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Current Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('current'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.selectedMethod == 'current' 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: widget.selectedMethod == 'current' 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'current' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Current',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: widget.selectedMethod == 'current' ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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