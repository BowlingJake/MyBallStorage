import 'package:bowlingarsenal_app/controllers/onboarding_controller.dart';
import 'package:bowlingarsenal_app/views/onboarding/onboarding_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 進度指示器
            _buildProgressIndicator(context, controller.currentPage),

            // 頁面內容
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  OnboardingPages.buildWelcomePage(context),
                  OnboardingPages.buildNicknamePage(
                    controller: controller.nicknameController,
                    onChanged: () {}, // 由 Controller 的 listener 處理
                  ),
                  OnboardingPages.buildHandPage(
                    options: controller.handOptions,
                    selectedValue: controller.selectedHand,
                    onChanged: controllerNotifier.setSelectedHand,
                  ),
                  OnboardingPages.buildBallPathPage(
                    options: controller.ballPathOptions,
                    selectedValue: controller.selectedBallPath,
                    onChanged: controllerNotifier.setSelectedBallPath,
                  ),
                  OnboardingPages.buildPAPPage(
                    controller: controller.papController,
                    onChanged: () {}, // 由 Controller 的 listener 處理
                    onSkip: controllerNotifier.skipPAP,
                  ),
                ],
              ),
            ),

            // 導航按鈕
            _buildNavigationButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, int currentPage) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color:
                    index <= currentPage
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (controller.currentPage > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: controllerNotifier.previousPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
                child: const Text('上一步'),
              ),
            ),
          if (controller.currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.canProceed()
                  ? () => controllerNotifier.nextPage(context, ref)
                  : null,
              child: Text(controller.currentPage == 4 ? '完成設定' : '下一步'),
            ),
          ),
        ],
      ),
    );
  }
}
