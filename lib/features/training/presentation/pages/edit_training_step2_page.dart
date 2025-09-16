import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_2_oil_pattern.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/features/training/data/training_sessions_repository.dart';

/// 編輯訓練記錄 - 第二步：油圖設定頁面
class EditTrainingStep2Page extends ConsumerStatefulWidget {
  const EditTrainingStep2Page({
    super.key,
    required this.trainingSession,
  });

  final TrainingDaySummary trainingSession;

  @override
  ConsumerState<EditTrainingStep2Page> createState() => _EditTrainingStep2PageState();
}

class _EditTrainingStep2PageState extends ConsumerState<EditTrainingStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _trainingRepo = TrainingSessionsRepository();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Edit Oil Pattern',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/training/edit/step-1', extra: widget.trainingSession),
            tooltip: 'Back',
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
                    child: Step2OilPattern(
                      initialData: widget.trainingSession,
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
          for (int i = 0; i < 2; i++) ...[
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i <= 1
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

  Widget _buildStepHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Text(
          'Oil Pattern Configuration',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final state = ref.watch(trainingFormProvider(widget.trainingSession));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AppStandardButton.secondary(
                text: 'Back',
                onPressed: () => context.go('/training/edit/step-1', extra: widget.trainingSession),
                height: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppStandardButton(
                text: 'Save Changes',
                icon: Icons.save,
                onPressed: _handleSave,
                enabled: state.isStep1Valid && state.isStep2Valid,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      TopNotification.showError(context, 'Please fill in all required fields');
      return;
    }

    final state = ref.read(trainingFormProvider(widget.trainingSession));
    if (!state.isStep1Valid || !state.isStep2Valid) {
      TopNotification.showError(context, 'Please complete all required fields');
      return;
    }

    try {
      // 更新訓練會話資料
      await _trainingRepo.updateTrainingSession(
        sessionId: widget.trainingSession.id,
        title: state.title,
        centerName: state.centerName,
        date: state.date!,
        isHousePattern: state.isHousePattern,
        oilPatternName: state.oilPatternName,
        oilPatternLength: state.oilPatternLength.isNotEmpty ? int.tryParse(state.oilPatternLength) : null,
        scoringMethod: state.selectedScoringMethod,
        fillMethod: state.selectedInputMethod,
      );

      // 清理表單狀態
      final notifier = ref.read(trainingFormProvider(widget.trainingSession).notifier);
      notifier.reset();

      TopNotification.showSuccess(context, 'Training session updated successfully');

      // 獲取更新後的資料並返回詳情頁面
      // 由於我們需要最新的資料，直接使用 go 導航到詳情頁面
      // 注意：這裡我們應該從資料庫重新載入資料，但暫時先用原有的資料結構
      final updatedSession = widget.trainingSession.copyWith(
        title: state.title,
        center: state.centerName,
        date: state.date!,
        isHousePattern: state.isHousePattern,
        oilPatternName: state.oilPatternName.isNotEmpty ? state.oilPatternName : null,
        oilPatternLength: state.oilPatternLength.isNotEmpty ? int.tryParse(state.oilPatternLength) : null,
        scoringMethod: state.selectedScoringMethod,
        inputMethod: state.selectedInputMethod,
      );

      // 使用 go 導航確保詳情頁面使用最新資料
      context.go('/training/detail/${widget.trainingSession.id}', extra: updatedSession);
    } catch (e) {
      TopNotification.showError(context, 'Failed to update training session: $e');
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