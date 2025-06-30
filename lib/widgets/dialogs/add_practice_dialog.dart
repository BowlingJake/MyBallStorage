import 'package:flutter/material.dart';
import '../../theme/text_styles.dart';
import '../primary_button.dart';

enum _PracticeStep { details, oilPattern, scoring }
enum InputMethod { simple, advanced }
enum ScoringSystem { traditional, current }

class AddPracticeDialog extends StatefulWidget {
  const AddPracticeDialog({super.key});

  @override
  State<AddPracticeDialog> createState() => _AddPracticeDialogState();
}

class _AddPracticeDialogState extends State<AddPracticeDialog> {
  final PageController _pageController = PageController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _oilPatternController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  InputMethod _inputMethod = InputMethod.simple;
  ScoringSystem _scoringSystem = ScoringSystem.traditional;

  _PracticeStep _currentStep = _PracticeStep.details;

  @override
  void dispose() {
    _pageController.dispose();
    _locationController.dispose();
    _oilPatternController.dispose();
    super.dispose();
  }

  void _onStepChanged(int page) {
    setState(() {
      _currentStep = _PracticeStep.values[page];
    });
  }

  void _next() {
    if (_currentStep.index < _PracticeStep.values.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previous() {
    if (_currentStep.index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title, style: AppTextStyles.title),
      content: SizedBox(
        width: double.maxFinite,
        height: 250, // Give a fixed height to the PageView container
        child: PageView(
          controller: _pageController,
          onPageChanged: _onStepChanged,
          children: [
            _buildDetailsPage(),
            _buildOilPatternPage(),
            _buildScoringPage(),
          ],
        ),
      ),
      actions: _buildActions(),
    );
  }

  String get _title {
    switch (_currentStep) {
      case _PracticeStep.details:
        return '新增練習紀錄 (1/3)';
      case _PracticeStep.oilPattern:
        return '油路資訊 (2/3)';
      case _PracticeStep.scoring:
        return '計分方式 (3/3)';
    }
  }

  List<Widget> _buildActions() {
    return [
      if (_currentStep != _PracticeStep.details)
        TextButton(
          onPressed: _previous,
          child: const Text('上一步', style: AppTextStyles.button),
        ),
      const Spacer(),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消', style: AppTextStyles.button),
      ),
      MyCustomButton(
        text: _currentStep == _PracticeStep.scoring ? '完成' : '下一步',
        onPressed: () {
          if (_currentStep == _PracticeStep.scoring) {
            // Final step: validate and pop with results
            if (_locationController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請返回第一步填寫練習地點', style: AppTextStyles.body)),
              );
              return;
            }
            Navigator.pop(context, {
              'date': '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
              'location': _locationController.text,
              'oilPattern': _oilPatternController.text,
              'inputMethod': _inputMethod,
              'scoringSystem': _scoringSystem,
            });
          } else {
            // Move to next step
            _next();
          }
        },
      ),
    ];
  }

  Widget _buildDetailsPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: '練習日期',
                labelStyle: AppTextStyles.body,
              ),
              child: Text(
                '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                style: AppTextStyles.body,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: '練習地點*',
              labelStyle: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOilPatternPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oilPatternController,
            decoration: const InputDecoration(
              labelText: '練習油尺（選填）',
              labelStyle: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('輸入方式', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          SegmentedButton<InputMethod>(
            segments: const [
              ButtonSegment(value: InputMethod.simple, label: Text('簡易'), icon: Icon(Icons.speed)),
              ButtonSegment(value: InputMethod.advanced, label: Text('詳細'), icon: Icon(Icons.grid_on)),
            ],
            selected: {_inputMethod},
            onSelectionChanged: (newSelection) {
              setState(() => _inputMethod = newSelection.first);
            },
          ),
          const SizedBox(height: 24),
          const Text('計分系統', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          SegmentedButton<ScoringSystem>(
            segments: const [
              ButtonSegment(value: ScoringSystem.traditional, label: Text('傳統')),
              ButtonSegment(value: ScoringSystem.current, label: Text('現代')),
            ],
            selected: {_scoringSystem},
            onSelectionChanged: (newSelection) {
              setState(() => _scoringSystem = newSelection.first);
            },
          ),
        ],
      ),
    );
  }
} 