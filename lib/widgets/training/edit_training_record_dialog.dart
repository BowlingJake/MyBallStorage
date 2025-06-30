import 'package:flutter/material.dart';
import 'dart:ui';
import '../app_standard_button.dart';
import '../../models/training_record.dart';

// 編輯訓練記錄彈窗 - 樣式與新增彈窗同步
class EditTrainingRecordDialog extends StatefulWidget {
  final TrainingDaySummary summary;
  final Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod, String inputMethod)? onRecordUpdated;

  const EditTrainingRecordDialog({
    Key? key,
    required this.summary,
    this.onRecordUpdated,
  }) : super(key: key);

  @override
  State<EditTrainingRecordDialog> createState() => _EditTrainingRecordDialogState();
}

class _EditTrainingRecordDialogState extends State<EditTrainingRecordDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // 表單控制器
  late final TextEditingController _titleController;
  late final TextEditingController _centerNameController;
  late final TextEditingController _oilPatternNameController;
  late final TextEditingController _oilPatternLengthController;
  late DateTime _selectedDate;
  late bool _isHousePattern;
  late String _selectedScoringMethod;
  late String _selectedInputMethod;
  
  // 2步表單流程狀態
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
    // 預填入現有數據
    _titleController = TextEditingController(text: widget.summary.title);
    _centerNameController = TextEditingController(text: widget.summary.center);
    _oilPatternNameController = TextEditingController(text: widget.summary.oilPatternName ?? '');
    _oilPatternLengthController = TextEditingController(text: widget.summary.oilPatternLength ?? '');
    _selectedDate = widget.summary.date;
    _isHousePattern = widget.summary.isHousePattern;
    _selectedScoringMethod = widget.summary.scoringMethod;
    _selectedInputMethod = widget.summary.inputMethod;
    
    _initAnimations();
    _validateStep1();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
      _step1Valid = _titleController.text.isNotEmpty && _centerNameController.text.isNotEmpty;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
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
    
    if (_currentStep < 1) {
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

  void _updateRecord() {
    if (_formKey.currentState!.validate()) {
      widget.onRecordUpdated?.call(
          _titleController.text,
          _selectedDate,
          _centerNameController.text,
          _oilPatternNameController.text.isEmpty ? null : _oilPatternNameController.text,
          _oilPatternLengthController.text.isEmpty ? null : _oilPatternLengthController.text,
          _isHousePattern,
          _selectedScoringMethod,
          _selectedInputMethod, // 使用從模型中獲取的輸入方式
        );
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Training session updated successfully!'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildDialog(),
    );
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
            maxHeight: size.height * 0.7,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
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
              Icons.edit_note,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Training Session',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withOpacity(0.1),
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
        return 'Advanced Settings';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < 2; i++) ...[
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i <= _currentStep
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            ),
            if (i < 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1(),
            _buildStep2(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildStepHeader(
          icon: Icons.edit,
          title: 'Session & Location',
          subtitle: 'Basic information',
        ),
        const SizedBox(height: 16),
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
        _buildStepHeader(
          icon: Icons.settings,
          title: 'Advanced Settings',
          subtitle: 'Optional configurations',
        ),
        const SizedBox(height: 16),
        _buildOilPatternSelector(),
        const SizedBox(height: 16),
        _buildScoringMethodSelector(),
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
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 16,
          ),
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
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        color: theme.colorScheme.surface.withOpacity(0.1),
      ),
      child: TextFormField(
        controller: controller,
        style: theme.textTheme.bodyMedium,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7), size: 18),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(icon: Icons.water_drop, title: 'Oil Pattern'),
        const SizedBox(height: 8),
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

  Widget _buildScoringMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(icon: Icons.calculate, title: 'Scoring Method'),
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

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected 
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
          if (_currentStep > 0) ...[
            Expanded(
              child: AppStandardButton(
                text: 'Previous',
                icon: Icons.arrow_back,
                onPressed: _previousStep,
                isPrimary: false,
                height: 40,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: AppStandardButton(
              text: _currentStep == 1 ? 'Update Session' : 'Next',
              icon: _currentStep == 1 ? Icons.check : Icons.arrow_forward,
              onPressed: (_currentStep == 0 ? _step1Valid : true)
                  ? (_currentStep == 1 ? _updateRecord : _nextStep)
                  : () {},
              enabled: _currentStep == 0 ? _step1Valid : true,
              isPrimary: true,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// 顯示編輯訓練記錄彈窗的輔助函數
void showEditTrainingRecordDialog(
  BuildContext context, 
  TrainingDaySummary summary,
  Function(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod, String inputMethod)? onRecordUpdated,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.05), // 極淺的背景遮罩
    builder: (BuildContext context) {
      return EditTrainingRecordDialog(
        summary: summary,
        onRecordUpdated: onRecordUpdated,
      );
    },
  );
} 