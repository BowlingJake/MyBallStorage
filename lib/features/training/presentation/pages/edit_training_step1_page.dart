import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_form_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/create_session/step_1_session_details.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/custom_date_picker_dialog.dart';
import 'package:bowlingarsenal_app/features/training/data/training_sessions_repository.dart';

/// 編輯訓練記錄 - 會話詳情頁面
class EditTrainingStep1Page extends ConsumerStatefulWidget {
  const EditTrainingStep1Page({
    super.key,
    required this.trainingSession,
  });

  final TrainingDaySummary trainingSession;

  @override
  ConsumerState<EditTrainingStep1Page> createState() => _EditTrainingStep1PageState();
}

class _EditTrainingStep1PageState extends ConsumerState<EditTrainingStep1Page> {
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
            'Edit Training Session',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/training/detail/${widget.trainingSession.id}', extra: widget.trainingSession);
              }
            },
            tooltip: 'Cancel',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
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
                    child: Step1SessionDetails(
                      onDateSelected: () => _selectDate(context),
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

  Widget _buildStepHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Text(
          'Edit Session Details',
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
                text: 'Cancel',
                onPressed: _handleCancel,
                height: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppStandardButton(
                text: 'Next',
                icon: Icons.arrow_forward,
                onPressed: _handleNext,
                enabled: state.isStep1Valid,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel() {
    // 清理表單狀態並返回詳情頁面
    final notifier = ref.read(trainingFormProvider(widget.trainingSession).notifier);
    notifier.reset();

    // 使用 go 替代 pop 來確保導航正確
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/training/detail/${widget.trainingSession.id}', extra: widget.trainingSession);
    }
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) {
      TopNotification.showError(context, 'Please fill in all required fields');
      return;
    }

    final state = ref.read(trainingFormProvider(widget.trainingSession));
    if (!state.isStep1Valid) {
      TopNotification.showError(context, 'Please enter session title and bowling center');
      return;
    }

    // 導航到第二步
    context.go('/training/edit/step-2', extra: widget.trainingSession);
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

  Future<void> _selectDate(BuildContext context) async {
    final state = ref.read(trainingFormProvider(widget.trainingSession));
    final notifier = ref.read(trainingFormProvider(widget.trainingSession).notifier);

    final picked = await CustomDatePickerDialog.show(
      context,
      initialDate: state.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      notifier.updateDate(picked);
    }
  }
}