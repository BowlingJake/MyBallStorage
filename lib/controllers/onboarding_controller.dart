import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/providers/providers.dart';

class OnboardingController extends ChangeNotifier {
  // State variables
  late final PageController pageController;
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController papController = TextEditingController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  String _selectedHand = '';
  String get selectedHand => _selectedHand;

  String _selectedBallPath = '';
  String get selectedBallPath => _selectedBallPath;

  final List<String> handOptions = ['右手', '左手'];
  final List<String> ballPathOptions = ['直球', '飛碟球', '曲球', '勾球'];

  OnboardingController() {
    pageController = PageController();
    // Add listeners to re-evaluate `canProceed` when text changes
    nicknameController.addListener(notifyListeners);
    papController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    nicknameController.removeListener(notifyListeners);
    papController.removeListener(notifyListeners);
    pageController.dispose();
    nicknameController.dispose();
    papController.dispose();
    super.dispose();
  }

  // Methods
  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context, WidgetRef ref) {
    if (_currentPage < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding(context, ref);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Save user profile
    await ref.read(userProfileProvider.notifier).updateProfile(
          nickname: nicknameController.text,
          hand: _selectedHand,
          ballPath: _selectedBallPath,
          pap: papController.text,
        );

    // Mark Onboarding as complete
    await ref.read(onboardingProvider.notifier).completeOnboarding();

    // Navigate to home
    context.go('/');
  }

  bool canProceed() {
    switch (_currentPage) {
      case 0:
        return true; // Welcome page
      case 1:
        return nicknameController.text.isNotEmpty;
      case 2:
        return _selectedHand.isNotEmpty;
      case 3:
        return _selectedBallPath.isNotEmpty;
      case 4:
        return papController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void setSelectedHand(String value) {
    _selectedHand = value;
    notifyListeners();
  }

  void setSelectedBallPath(String value) {
    _selectedBallPath = value;
    notifyListeners();
  }

  void skipPAP() {
    papController.text = '待設定';
    // The listener will trigger notifyListeners
  }
}

// Provider definition
final onboardingControllerProvider = ChangeNotifierProvider<OnboardingController>((ref) {
  final controller = OnboardingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
}); 