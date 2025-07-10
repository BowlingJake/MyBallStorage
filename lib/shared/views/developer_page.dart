import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_manager.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  late ScoringManager _scoringManager;
  late ScoringDemoData _demoData;
  int _selectedDemoIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _scoringManager = ScoringManager();
    _demoData = ScoringManager.createDemoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開發者 - 計分策略對比'),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: _buildDemo(context),
      ),
    );
  }

  Widget _buildDemo(BuildContext context) {
    final demoGames = _demoData.getAllDemoGames();
    final currentDemo = demoGames[_selectedDemoIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 示範數據選擇器
        _buildDemoSelector(demoGames),
        
        const SizedBox(height: 20),
        
        // 當前示範數據資訊
        _buildDemoInfo(currentDemo),
        
        const SizedBox(height: 30),
        
        // 計分對比
        _buildScoringComparison(currentDemo.rolls),
        
        const SizedBox(height: 40),
        
        // 使用說明
        _buildUsageInstructions(),
      ],
    );
  }
  
  Widget _buildDemoSelector(List<DemoGameData> demoGames) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00B2A9).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '選擇示範遊戲：',
            style: TextStyle(
              color: Color(0xFF00B2A9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: demoGames.asMap().entries.map((entry) {
              final index = entry.key;
              final demo = entry.value;
              final isSelected = index == _selectedDemoIndex;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedDemoIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00B2A9) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00B2A9),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    demo.name,
                    style: TextStyle(
                      color: isSelected ? Colors.black : const Color(0xFF00B2A9),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDemoInfo(DemoGameData demo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demo.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            demo.description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            '投球數據: ${demo.rolls.join(', ')}',
            style: const TextStyle(
              color: Color(0xFF00B2A9),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScoringComparison(List<int> rolls) {
    // 計算兩種模式的結果
    final traditionalManager = ScoringManager(mode: ScoringMode.traditional);
    final currentManager = ScoringManager(mode: ScoringMode.current);
    
    final traditionalFrames = traditionalManager.calculateScores(rolls);
    final currentFrames = currentManager.calculateScores(rolls);
    
    final traditionalTotal = traditionalFrames.isNotEmpty ? traditionalFrames.last.cumulativeScore : 0;
    final currentTotal = currentFrames.isNotEmpty ? currentFrames.last.cumulativeScore : 0;
    
    return Column(
      children: [
        // 傳統計分
        _buildScoringSection(
          title: '${traditionalManager.currentStrategyName} (總分: $traditionalTotal)',
          description: traditionalManager.currentStrategyDescription,
          frames: traditionalFrames,
          color: const Color(0xFF00B2A9),
        ),
        
        const SizedBox(height: 30),
        
        // Current計分
        _buildScoringSection(
          title: '${currentManager.currentStrategyName} (總分: $currentTotal)',
          description: currentManager.currentStrategyDescription,
          frames: currentFrames,
          color: const Color(0xFFFF6B35),
        ),
        
        const SizedBox(height: 20),
        
        // 分數差異
        if (traditionalTotal != currentTotal)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  '分數差異: ${(traditionalTotal - currentTotal).abs()} 分',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildScoringSection({
    required String title,
    required String description,
    required List<BowlingFrame> frames,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          BowlingScoreCardWidget(
            frames: frames,
            accentColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF00B2A9).withOpacity(0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '策略模式使用方法：',
            style: TextStyle(
              color: Color(0xFF00B2A9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '1. 導入管理器：',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'import "lib/features/training/logic/scoring/scoring_manager.dart";',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
          ),
          SizedBox(height: 8),
          Text(
            '2. 建立計分管理器：',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'final manager = ScoringManager(mode: ScoringMode.traditional);',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
          ),
          SizedBox(height: 8),
          Text(
            '3. 計算分數：',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'final frames = manager.calculateScores([10, 7, 3, 9, 0, ...]);',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
          ),
          SizedBox(height: 8),
          Text(
            '4. 切換模式：',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'manager.switchMode(ScoringMode.current);',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
          ),
          SizedBox(height: 16),
          Text(
            '兩種計分模式的主要差異：',
            style: TextStyle(
              color: Color(0xFF00B2A9),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• 傳統模式：Strike和Spare依賴後續投球結果',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            '• Current模式：Strike固定30分，Spare=10+第一球，第10格無獎勵球',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
