import 'dart:ui';

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
          children: [_buildStep1(), _buildStep2(), _buildStep3()],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // 步驟標題
        _buildStepHeader(
          icon: Icons.edit,
          title: 'Session & Location',
          subtitle: 'Basic information',
        ),

        const SizedBox(height: 16),

        // 練習標題和球館名稱（並排）
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                controller: _titleController,
                label: 'Session Title',
                hint: 'Morning Practice',
                icon: Icons.title,
                onChanged: (_) => _validateStep1(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCompactTextField(
                controller: _centerNameController,
                label: 'Bowling Center',
                hint: 'Strike Zone',
                icon: Icons.location_on,
                onChanged: (_) => _validateStep1(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 日期選擇
        _buildDateSelector(),

        const Spacer(),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // 步驟標題
        _buildStepHeader(
          icon: Icons.water_drop,
          title: 'Oil Pattern',
          subtitle: 'Lane conditions',
        ),

        const SizedBox(height: 16),

        // 油圖設定
        _buildOilPatternSelector(),

        const Spacer(),
      ],
    );
  }

  Widget _buildStep3() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // 步驟標題
        _buildStepHeader(
          icon: Icons.settings,
          title: 'Scoring Setup',
          subtitle: 'Choose your input method and scoring system',
        ),

        const SizedBox(height: 16),

        // 輸入方式選擇
        _buildInputMethodSelector(),

        const SizedBox(height: 16),

        // 計分系統選擇
        _buildScoringSystemSelector(),

        const SizedBox(height: 16),

        // 建議說明（放在底部）
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Advanced scoring provides more detailed statistics',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),
      ],
    );
  }

  Widget _buildStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 16),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        color: theme.colorScheme.surface.withOpacity(0.1),
      ),
      child: TextFormField(
        controller: controller,
        style: theme.textTheme.bodyMedium,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: theme.colorScheme.primary.withOpacity(0.7),
            size: 18,
          ),
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          color: theme.colorScheme.surface.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training Date',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_selectedDate.year}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOilPatternSelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.water_drop, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'Oil Pattern',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // House/Sport切換
        Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                'House',
                _isHousePattern,
                () => setState(() => _isHousePattern = true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleButton(
                'Custom',
                !_isHousePattern,
                () => setState(() => _isHousePattern = false),
              ),
            ),
          ],
        ),

        if (!_isHousePattern) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildCompactTextField(
                  controller: _oilPatternNameController,
                  label: 'Pattern',
                  hint: 'Cheetah',
                  icon: Icons.label,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactTextField(
                  controller: _oilPatternLengthController,
                  label: 'Length',
                  hint: '35ft',
                  icon: Icons.straighten,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInputMethodSelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.input, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'Input Method',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildInputMethodCard(
                'Simple',
                'Only input total score',
                'Quick basic recording',
                Icons.speed,
                _selectedInputMethod == 'simple',
                () => setState(() => _selectedInputMethod = 'simple'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInputMethodCard(
                'Advanced',
                'Frame-by-frame input',
                'Complete statistics',
                Icons.grid_on,
                _selectedInputMethod == 'advanced',
                () => setState(() => _selectedInputMethod = 'advanced'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoringSystemSelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calculate, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'Scoring System',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                'Traditional',
                _selectedScoringMethod == 'traditional',
                () => setState(() => _selectedScoringMethod = 'traditional'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleButton(
                'Current',
                _selectedScoringMethod == 'current',
                () => setState(() => _selectedScoringMethod = 'current'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputMethodCard(
    String title,
    String subtitle,
    String description,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color:
                      isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
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
