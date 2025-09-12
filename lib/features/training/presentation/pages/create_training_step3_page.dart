import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_3_scoring_setup.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';

/// 創建訓練記錄 - 第三步：計分設定頁面
class CreateTrainingStep3Page extends ConsumerStatefulWidget {
  const CreateTrainingStep3Page({
    super.key,
    this.initialData,
  });

  final TrainingDaySummary? initialData;

  @override
  ConsumerState<CreateTrainingStep3Page> createState() => _CreateTrainingStep3PageState();
}

class _CreateTrainingStep3PageState extends ConsumerState<CreateTrainingStep3Page> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.initialData != null ? 'Edit Training Session' : 'New Training Session',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/training/create/step-2'),
            tooltip: 'Previous Step',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            // 進度指示器
            _buildProgressIndicator(),
            
            // 步驟標題
            _buildStepHeader(),
            
            // 表單內容
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Step3ScoringSetup(
                      initialData: widget.initialData,
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部按鈕
            _buildFooter(),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: 3, // Training section
          onTap: (index) => _handleBottomNavigation(index),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i <= 2
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

  Widget _buildStepHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Text(
          'Scoring Preferences & Methods',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        child: Row(
          children: [
            // 上一步按鈕
            Expanded(
              child: AppStandardButton.secondary(
                text: 'Previous',
                icon: Icons.arrow_back,
                onPressed: () => context.go('/training/create/step-2'),
                height: 40,
              ),
            ),
            const SizedBox(width: 16),
            
            // 完成按鈕
            Expanded(
              child: AppStandardButton(
                text: widget.initialData != null ? 'Update Session' : 'Create Session',
                icon: Icons.check,
                onPressed: _handleComplete,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleComplete() async {
    if (!_formKey.currentState!.validate()) {
      TopNotification.showError(context, 'Please complete all required fields');
      return;
    }

    final formNotifier = ref.read(trainingFormProvider(widget.initialData).notifier);
    final formState = formNotifier.submit();
    
    if (formState == null) {
      TopNotification.showError(context, 'Please complete all required fields');
      return;
    }

    try {
      final trainingController = ref.read(trainingControllerProvider.notifier);
      
      if (widget.initialData != null) {
        // 更新現有記錄
        await trainingController.updateTrainingRecord(
          widget.initialData!.id,
          title: formState.title,
          date: formState.date!,
          center: formState.centerName,
          oilPatternName: formState.oilPatternName.isEmpty ? null : formState.oilPatternName,
          oilPatternLength: formState.oilPatternLength.isEmpty ? null : int.tryParse(formState.oilPatternLength),
          isHousePattern: formState.isHousePattern,
          scoringMethod: formState.selectedScoringMethod,
          inputMethod: formState.selectedInputMethod,
        );
        if (mounted) {
          TopNotification.showSuccess(context, 'Training session updated successfully!');
        }
      } else {
        // 創建新記錄
        final newSession = await trainingController.createTrainingSession(
          title: formState.title,
          date: formState.date!,
          center: formState.centerName,
          oilPatternName: formState.oilPatternName.isEmpty ? null : formState.oilPatternName,
          oilPatternLength: formState.oilPatternLength.isEmpty ? null : int.tryParse(formState.oilPatternLength),
          isHousePattern: formState.isHousePattern,
          scoringMethod: formState.selectedScoringMethod,
          inputMethod: formState.selectedInputMethod,
        );
        if (mounted) {
          TopNotification.showSuccess(context, 'Training session created successfully!');
          
          // 將TrainingSession轉換為TrainingDaySummary以傳遞給詳情頁面
          final trainingDaySummary = TrainingDaySummary(
            id: newSession.id,
            title: newSession.title,
            date: newSession.date,
            center: newSession.center,
            oilPatternName: newSession.oilPatternName,
            oilPatternLength: newSession.oilPatternLength,
            isHousePattern: newSession.isHousePattern,
            scoringMethod: newSession.scoringMethod,
            inputMethod: newSession.inputMethod,
            games: [], // 新創建的session沒有games
            createdAt: DateTime.now(),
          );
          
          // 導航到新創建的訓練詳情頁面
          context.go(
            '/training/detail/${newSession.id}',
            extra: trainingDaySummary,
          );
        }
        return;
      }
      
      // 編輯情況：返回到訓練頁面
      if (mounted) {
        context.go('/training');
      }
    } catch (e) {
      print('Create training session error: $e'); // Debug 資訊
      if (mounted) {
        TopNotification.showError(context, 'Failed to save training session: ${e.toString()}');
      }
    }
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/my-arsenal');
        break;
      case 3:
        context.go('/training');
        break;
      case 4:
        context.go('/tournament');
        break;
    }
  }
}