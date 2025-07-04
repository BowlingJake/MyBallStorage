import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:bowlingarsenal_app/views/onboarding/onboarding_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  // 表單控制器
  final _nicknameController = TextEditingController();
  final _papController = TextEditingController();

  String _selectedHand = '';
  String _selectedBallPath = '';

  final List<String> _handOptions = ['右手', '左手'];
  final List<String> _ballPathOptions = ['直球', '飛碟球', '曲球', '勾球'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _papController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // 儲存使用者檔案
    await ref
        .read(userProfileProvider.notifier)
        .updateProfile(
          nickname: _nicknameController.text,
          hand: _selectedHand,
          ballPath: _selectedBallPath,
          pap: _papController.text,
        );

    // 標記 Onboarding 完成
    await ref.read(onboardingProvider.notifier).completeOnboarding();

    // 導航到主頁
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return true; // 歡迎頁面
      case 1:
        return _nicknameController.text.isNotEmpty;
      case 2:
        return _selectedHand.isNotEmpty;
      case 3:
        return _selectedBallPath.isNotEmpty;
      case 4:
        return _papController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _updateState() {
    setState(() {});
  }

  void _skipPAP() {
    _papController.text = '待設定';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 進度指示器
            _buildProgressIndicator(),

            // 頁面內容
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingPages.buildWelcomePage(context),
                  OnboardingPages.buildNicknamePage(
                    controller: _nicknameController,
                    onChanged: _updateState,
                  ),
                  OnboardingPages.buildHandPage(
                    options: _handOptions,
                    selectedValue: _selectedHand,
                    onChanged: (value) {
                      setState(() {
                        _selectedHand = value;
                      });
                    },
                  ),
                  OnboardingPages.buildBallPathPage(
                    options: _ballPathOptions,
                    selectedValue: _selectedBallPath,
                    onChanged: (value) {
                      setState(() {
                        _selectedBallPath = value;
                      });
                    },
                  ),
                  OnboardingPages.buildPAPPage(
                    controller: _papController,
                    onChanged: _updateState,
                    onSkip: _skipPAP,
                  ),
                ],
              ),
            ),

            // 導航按鈕
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
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
                    index <= _currentPage
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

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _previousPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
                child: const Text('上一步'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextPage : null,
              child: Text(_currentPage == 4 ? '完成設定' : '下一步'),
            ),
          ),
        ],
      ),
    );
  }
}
