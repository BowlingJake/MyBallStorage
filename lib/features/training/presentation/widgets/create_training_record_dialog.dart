import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_form_state.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_1_session_details.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_2_oil_pattern.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_3_scoring_setup.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

typedef OnRecordCreatedCallback = void Function(TrainingFormState record);

void showCreateTrainingRecordDialog(
  BuildContext context, {
  TrainingDaySummary? initialData,
  required OnRecordCreatedCallback onRecordCreated,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.05), // 極淺的背景遮罩
    builder: (BuildContext context) {
      return CreateTrainingRecordDialog(
        initialData: initialData,
        onRecordCreated: onRecordCreated,
      );
    },
  );
}

// 重構的新增訓練記錄彈窗 - 遵循APP標準視覺風格
class CreateTrainingRecordDialog extends ConsumerStatefulWidget {
  const CreateTrainingRecordDialog({
    super.key, 
    this.initialData,
    required this.onRecordCreated,
  });
  
  final TrainingDaySummary? initialData;
  final OnRecordCreatedCallback onRecordCreated;

  @override
  ConsumerState<CreateTrainingRecordDialog> createState() =>
      _CreateTrainingRecordDialogState();
}

class _CreateTrainingRecordDialogState extends ConsumerState<CreateTrainingRecordDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // 3步表單流程狀態
  final PageController _pageController = PageController();

  // 動畫控制器
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
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
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final state = ref.read(trainingFormProvider(widget.initialData));
    final notifier = ref.read(trainingFormProvider(widget.initialData).notifier);
    final theme = Theme.of(context);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: state.date ?? DateTime.now(),
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
    if (picked != null) {
      notifier.updateDate(picked);
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
                  widget.initialData != null ? 'Edit Training Session' : 'New Training Session', // 恢復原始標題
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    // 顏色由主題自動決定
                  ),
                ),
                const SizedBox(height: 2),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(trainingFormProvider(widget.initialData));
                    return Text(
                      _getStepTitle(state.currentStep),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
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

  String _getStepTitle(int currentStep) {
    switch (currentStep) {
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
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(trainingFormProvider(widget.initialData));
          return Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color:
                          i <= state.currentStep
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 8),
              ],
            ],
          );
        },
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
              onDateSelected: () => _selectDate(context),
              initialData: widget.initialData,
            ),
            Step2OilPattern(
              initialData: widget.initialData,
            ),
            Step3ScoringSetup(
              initialData: widget.initialData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(trainingFormProvider(widget.initialData));
          final notifier = ref.read(trainingFormProvider(widget.initialData).notifier);
          return Row(
            children: [
              // 上一步按鈕
              if (state.currentStep > 0) ...[
                Expanded(
                  child: AppStandardButton(
                    text: 'Previous',
                    icon: Icons.arrow_back,
                    onPressed: () {
                      if (state.currentStep > 0) {
                        notifier.previousStep();
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // 下一步/完成按鈕
              Expanded(
                child: AppStandardButton(
                  text: state.currentStep == 2 ? 'Create Session' : 'Next',
                  icon: state.currentStep == 2 ? Icons.check : Icons.arrow_forward,
                  onPressed:
                      (state.currentStep == 0 ? state.isStep1Valid : true)
                          ? (state.currentStep == 2 
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    final result = notifier.submit();
                                    if (result != null) {
                                      widget.onRecordCreated(result);
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
                                }
                              : () {
                                  if (state.currentStep == 0 && !state.isStep1Valid) {
                                    _showValidationMessage('Please enter session title and bowling center');
                                    return;
                                  }

                                  if (state.currentStep < 2) {
                                    notifier.nextStep();
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                })
                          : () {},
                  enabled: state.currentStep == 0 ? state.isStep1Valid : true,
                  isPrimary: false,
                  height: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}








