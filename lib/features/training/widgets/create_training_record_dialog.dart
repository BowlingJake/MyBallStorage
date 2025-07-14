import 'dart:ui';

import 'package:bowlingarsenal_app/features/training/widgets/create_session/step_1_session_details.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/step_2_oil_pattern.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_session/step_3_scoring_setup.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

// 重構的新增訓練記錄彈窗 - 遵循APP標準視覺風格
class CreateTrainingRecordDialog extends StatefulWidget {
  const CreateTrainingRecordDialog({super.key, this.onRecordCreated});
  final Function(
    String title,
    DateTime date,
    String center,
    String? oilPatternName,
    String? oilPatternLength,
    bool isHousePattern,
    String scoringMethod,
    String inputMethod,
  )?
  onRecordCreated;

  @override
  State<CreateTrainingRecordDialog> createState() =>
      _CreateTrainingRecordDialogState();
}

class _CreateTrainingRecordDialogState extends State<CreateTrainingRecordDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // 表單控制器
  final _titleController = TextEditingController();
  final _centerNameController = TextEditingController();
  final _oilPatternNameController = TextEditingController();
  final _oilPatternLengthController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isHousePattern = true;
  String _selectedScoringMethod = 'traditional';
  String _selectedInputMethod = 'simple'; // 新增：輸入方式

  // 3步表單流程狀態
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // 動畫控制器
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // 表單驗證狀態
  bool _step1Valid = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _validateStep1();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _centerNameController.dispose();
    _oilPatternNameController.dispose();
    _oilPatternLengthController.dispose();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _validateStep1() {
    setState(() {
      _step1Valid =
          _titleController.text.isNotEmpty &&
          _centerNameController.text.isNotEmpty;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              surface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && !_step1Valid) {
      _showValidationMessage('Please enter session title and bowling center');
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      widget.onRecordCreated?.call(
        _titleController.text,
        _selectedDate,
        _centerNameController.text,
        _oilPatternNameController.text.isEmpty
            ? null
            : _oilPatternNameController.text,
        _oilPatternLengthController.text.isEmpty
            ? null
            : _oilPatternLengthController.text,
        _isHousePattern,
        _selectedScoringMethod,
        _selectedInputMethod, // 新增參數
      );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Training session created successfully!'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: _buildDialog());
  }

  Widget _buildDialog() {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: size.width * 0.92,
          constraints: BoxConstraints(
            maxWidth: 420,
            maxHeight: size.height * 0.7, // 降低高度避免滾動
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  // 與漢堡選單相同的透明度設定
                  color: const Color(0x33000000), // 20% 不透明度的純黑色
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 1.5,
                  ),
                  // 還原為 APP標準光暈效果
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    _buildProgressIndicator(),
                    Expanded(child: _buildFormContent()),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // 圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.sports,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 標題和副標題
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Training Session', // 恢復原始標題
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    // 顏色由主題自動決定
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStepTitle(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // 關閉按鈕
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withOpacity(0.7), // 還原顏色
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withOpacity(
                0.1,
              ), // 還原背景
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Session & Location Details';
      case 1:
        return 'Oil Pattern Settings';
      case 2:
        return 'Scoring Preferences';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color:
                      i <= _currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            ),
            if (i < 2) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Step1SessionDetails(
              titleController: _titleController,
              centerNameController: _centerNameController,
              selectedDate: _selectedDate,
              onDateSelected: () => _selectDate(context),
              onValidate: (_) => _validateStep1(),
            ),
            Step2OilPattern(
              isHousePattern: _isHousePattern,
              onPatternTypeChanged: (isHouse) {
                setState(() {
                  _isHousePattern = isHouse;
                });
              },
              oilPatternNameController: _oilPatternNameController,
              oilPatternLengthController: _oilPatternLengthController,
            ),
            Step3ScoringSetup(
              selectedInputMethod: _selectedInputMethod,
              onInputMethodChanged: (method) {
                setState(() {
                  _selectedInputMethod = method;
                });
              },
              selectedScoringMethod: _selectedScoringMethod,
              onScoringMethodChanged: (method) {
                setState(() {
                  _selectedScoringMethod = method;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          // 上一步按鈕
          if (_currentStep > 0) ...[
            Expanded(
              child: AppStandardButton(
                text: 'Previous',
                icon: Icons.arrow_back,
                onPressed: _previousStep,
                height: 40,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // 下一步/完成按鈕
          Expanded(
            child: AppStandardButton(
              text: _currentStep == 2 ? 'Create Session' : 'Next',
              icon: _currentStep == 2 ? Icons.check : Icons.arrow_forward,
              onPressed:
                  (_currentStep == 0 ? _step1Valid : true)
                      ? (_currentStep == 2 ? _saveRecord : _nextStep)
                      : () {},
              enabled: _currentStep == 0 ? _step1Valid : true,
              isPrimary: false,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// 顯示新增訓練記錄彈窗的輔助函數
void showCreateTrainingRecordDialog(
  BuildContext context,
  Function(
    String title,
    DateTime date,
    String center,
    String? oilPatternName,
    String? oilPatternLength,
    bool isHousePattern,
    String scoringMethod,
    String inputMethod,
  )?
  onRecordCreated,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.05), // 極淺的背景遮罩
    builder: (BuildContext context) {
      return CreateTrainingRecordDialog(onRecordCreated: onRecordCreated);
    },
  );
}
