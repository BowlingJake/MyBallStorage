import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

/// Edit Layout Dialog for Arsenal balls
class EditLayoutDialog extends ConsumerStatefulWidget {
  final UserArsenalInstance arsenalInstance;

  const EditLayoutDialog({
    required this.arsenalInstance,
    super.key,
  });

  @override
  ConsumerState<EditLayoutDialog> createState() => _EditLayoutDialogState();
}

class _EditLayoutDialogState extends ConsumerState<EditLayoutDialog> {
  late String _selectedLayoutType;
  late TextEditingController _value1Controller;
  late TextEditingController _value2Controller;
  late TextEditingController _value3Controller;

  @override
  void initState() {
    super.initState();
    
    // 初始化選擇的layout type，優先使用現有數據，否則預設VLS
    _selectedLayoutType = widget.arsenalInstance.layoutType ?? 'VLS';
    
    // 初始化控制器，填入現有數據
    _value1Controller = TextEditingController(
      text: widget.arsenalInstance.layoutValue1?.toString() ?? '',
    );
    _value2Controller = TextEditingController(
      text: widget.arsenalInstance.layoutValue2?.toString() ?? '',
    );
    _value3Controller = TextEditingController(
      text: widget.arsenalInstance.layoutValue3?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _value1Controller.dispose();
    _value2Controller.dispose();
    _value3Controller.dispose();
    super.dispose();
  }

  String get _firstFieldLabel {
    return _selectedLayoutType == 'VLS' ? 'Pin to PAP' : 'Duel Angle';
  }

  String get _secondFieldLabel {
    return _selectedLayoutType == 'VLS' ? 'PSA to PAP' : 'Pin to PAP';
  }

  String get _thirdFieldLabel {
    return _selectedLayoutType == 'VLS' ? 'PAP to COG' : 'VAL Angle';
  }

  String get _firstFieldHint {
    return _selectedLayoutType == 'VLS' ? ' ' : ' ';
  }

  String get _secondFieldHint {
    return _selectedLayoutType == 'VLS' ? ' ' : ' ';
  }

  String get _thirdFieldHint {
    return _selectedLayoutType == 'VLS' ? ' ' : ' ';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 球名標題
              Text(
                widget.arsenalInstance.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              
              // Layout 文字
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Layout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // 兩個標籤選擇器
              Row(
                children: [
                  Expanded(
                    child: _buildLayoutTypeButton('VLS'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLayoutTypeButton('DUAL_ANGLE'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 三個輸入方框
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildValueInput(
                      _value1Controller,
                      _firstFieldLabel,
                      _firstFieldHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 58, // 增加高度以配合文字框總高度 (label + spacing + input)
                    padding: const EdgeInsets.only(top: 18), // 向下調整 X 的位置
                    alignment: Alignment.center,
                    child: const Text(
                      'X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildValueInput(
                      _value2Controller,
                      _secondFieldLabel,
                      _secondFieldHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 58, // 增加高度以配合文字框總高度 (label + spacing + input)
                    padding: const EdgeInsets.only(top: 18), // 向下調整 X 的位置
                    alignment: Alignment.center,
                    child: const Text(
                      'X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildValueInput(
                      _value3Controller,
                      _thirdFieldLabel,
                      _thirdFieldHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 底部按鈕
              Row(
                children: [
                  Expanded(
                    child: AppStandardButton.secondary(
                      text: 'Exit',
                      height: 36,
                      fontSize: 14,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: 'Confirm',
                      height: 36,
                      fontSize: 14,
                      onPressed: _handleConfirm,
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

  Widget _buildLayoutTypeButton(String layoutType) {
    final isSelected = _selectedLayoutType == layoutType;
    final displayText = layoutType == 'VLS' ? 'VLS(2LS)' : 'Duel Angle';
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLayoutType = layoutType;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildValueInput(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[300],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[600]!,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleConfirm() async {
    // 驗證輸入
    final value1 = double.tryParse(_value1Controller.text);
    final value2 = double.tryParse(_value2Controller.text);
    final value3 = double.tryParse(_value3Controller.text);
    
    if (value1 == null || value2 == null || value3 == null) {
      TopNotification.showError(
        context,
        'Please enter valid numbers for all fields',
      );
      return;
    }
    
    try {
      // 取得使用者ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        throw Exception('User not authenticated');
      }
      final userId = authState.value!.id;
      
      // 映射layout type到資料庫格式
      String dbLayoutType;
      if (_selectedLayoutType == 'VLS') {
        dbLayoutType = 'VLS';
      } else if (_selectedLayoutType == 'DUAL_ANGLE') {
        dbLayoutType = 'DUAL_ANGLE';
      } else {
        dbLayoutType = _selectedLayoutType; // 保持原值
      }
      
      // 更新layout到後端
      await ref.read(newArsenalControllerProvider.notifier).updateLayout(
        instanceId: widget.arsenalInstance.id,
        layoutType: dbLayoutType,
        value1: value1,
        value2: value2,
        value3: value3,
        userId: userId,
      );
      
      // 關閉dialog並回傳成功
      if (mounted) {
        Navigator.of(context).pop({
          'success': true,
          'layoutType': _selectedLayoutType,
          'value1': value1,
          'value2': value2,
          'value3': value3,
        });
      }
    } catch (e) {
      // 顯示錯誤訊息
      if (mounted) {
        TopNotification.showError(
          context,
          'Failed to update layout: $e',
        );
      }
    }
  }
}

/// Helper function to show the edit layout dialog
Future<Map<String, dynamic>?> showEditLayoutDialog(
  BuildContext context,
  UserArsenalInstance arsenalInstance,
) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return EditLayoutDialog(arsenalInstance: arsenalInstance);
    },
  );
}