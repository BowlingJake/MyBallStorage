import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_stats.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/enhanced_training_stats.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_equipment.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/enhanced_training_equipment.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/enhanced_game_item.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';
import 'package:bowlingarsenal_app/shared/utils/bowling/split_detector.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/engine/pin_state_policy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/engine/scoring_engine.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
import 'package:intl/intl.dart';
import 'package:bowlingarsenal_app/repositories/games_repository.dart';
import 'package:bowlingarsenal_app/features/training/data/converters/game_data_converter.dart';

enum TrainingDetailTab { games, equipment, statistics }

class TrainingDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final TrainingDaySummary trainingSession;

  const TrainingDetailPage({
    required this.sessionId,
    required this.trainingSession,
    super.key,
  });

  @override
  ConsumerState<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

// 本地 UI 狀態：每局的資料（僅用於前端互動，不影響資料層）
class _GameUIState {
  _GameUIState()
      : frames = List<BowlingFrame>.generate(10, (_) => const BowlingFrame()),
        rolls = <int>[],
        rollStates = <List<bool>>[];
  final List<BowlingFrame> frames;
  final List<int> rolls; // 每球擊倒球數
  final List<List<bool>> rollStates; // 每球對應的球瓶狀態（第一球/第二球/第十格第三球）
  int? gameNumber; // 與資料庫對應的局號
  String? gameId; // 資料庫 id
  ScoringEngine? _engine;

  void updateFrames(String scoringMethod) {
    _engine ??= ScoringEngine(mode: scoringMethod.toLowerCase() == 'current' ? ScoringMode.current : ScoringMode.traditional);
    
    try {
      frames.clear();
      final calculatedFrames = _engine!.calculateMergedFrames(rolls.take(rolls.length).toList(), []);
      frames.addAll(calculatedFrames);
    } catch (e) {
      // 如果計算失敗，保持空白frames
      frames.clear();
      frames.addAll(List<BowlingFrame>.generate(10, (_) => const BowlingFrame()));
    }
  }
}

class _TrainingDetailPageState extends ConsumerState<TrainingDetailPage>
    with SingleTickerProviderStateMixin {
  TrainingDetailTab _selectedTab = TrainingDetailTab.games;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final List<_GameUIState> _addedGames = [];
  bool _isEditMode = false;
  bool _showPinVisualization = true; // 僅保留內嵌一層
  bool _isFullscreen = false;
  final GamesRepository _gamesRepo = GamesRepository();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    _loadExistingGames();
  }

  /// 載入現有遊戲資料
  Future<void> _loadExistingGames() async {
    try {
      final games = await _gamesRepo.fetchGamesBySession(widget.trainingSession.id);
      if (games.isNotEmpty) {
        setState(() {
          _addedGames.clear();
          for (final gameData in games) {
            final game = _GameUIState();
            game.gameNumber = (gameData['game_number'] as int?) ?? (_addedGames.length + 1);
            game.gameId = gameData['id'] as String?;
            _loadGameFromData(game, gameData);
            _addedGames.add(game);
          }

          // 依 gameNumber 排序，避免順序錯亂
          _addedGames.sort((a, b) => (a.gameNumber ?? 0).compareTo(b.gameNumber ?? 0));
        });
      }
    } catch (e) {
      print('Failed to load games: $e');
    }
  }

  /// 從資料庫資料載入到 _GameUIState
  void _loadGameFromData(_GameUIState game, Map<String, dynamic> data) {
    try {
      final framesData = data['frames'] as List<dynamic>? ?? [];
      game.rolls.clear();
      game.rollStates.clear();
      
      // 使用轉換器從新的 JSON 格式載入資料
      final gameUIState = GameDataConverter.convertFromFramesJson(framesData);
      game.rolls.addAll(gameUIState.rolls);
      game.rollStates.addAll(gameUIState.rollStates);
      
      game.updateFrames(widget.trainingSession.scoringMethod);
    } catch (e) {
      print('Error loading game data: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(TrainingDetailTab tab) {
    if (_selectedTab != tab) {
      setState(() {
        _selectedTab = tab;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _addEmptyGame() {
    final newGame = _GameUIState();
    newGame.gameNumber = (_addedGames.isNotEmpty
        ? (_addedGames.map((g) => g.gameNumber ?? 0).fold<int>(0, (a, b) => a > b ? a : b))
        : 0) + 1;
    setState(() {
      _addedGames.add(newGame);
    });
    // 立即在後端建立空白紀錄，確保即使未輸入也保留
    () async {
      try {
        await _gamesRepo.upsertGame(
          trainingSessionId: widget.trainingSession.id,
          gameNumber: newGame.gameNumber!,
          scoringMode: widget.trainingSession.scoringMethod.toLowerCase(),
          frames: const <Map<String, dynamic>>[],
          equipment: const <Map<String, dynamic>>[],
          totalScore: 0,
          strikes: 0,
          spares: 0,
          isCompleted: false,
        );
      } catch (_) {}
    }();
  }

  Future<void> _deleteLastGame() async {
    if (_addedGames.isEmpty) return;
    
    final gameNumber = _addedGames.last.gameNumber ?? _addedGames.length;
    
    try {
      // 從資料庫中刪除遊戲（先取得遊戲ID，然後刪除）
      final games = await _gamesRepo.fetchGamesBySession(widget.trainingSession.id);
      final gameToDelete = games.where((g) => g['game_number'] == gameNumber).firstOrNull;
      
      if (gameToDelete != null) {
        await _gamesRepo.deleteGame(gameToDelete['id'] as String);
      }
    } catch (e) {
      print('Failed to delete game from database: $e');
    }
    
    setState(() {
      _addedGames.removeLast();
    });
  }

  Future<void> _onGameFrameTapped(int gameIndex, int frameIndex) async {
    if (gameIndex < 0 || gameIndex >= _addedGames.length) return;
    final game = _addedGames[gameIndex];
    // 若該局已完成，禁止再開啟輸入對話框（死狀態）
    if (_isGameCompleted(game)) {
      return;
    }
    
    // Edit模式檢查：只能編輯已有資料的格子
    if (_isEditMode) {
      if (!_hasDataInFrame(game, frameIndex)) {
        return; // 不允許編輯空白格子
      }
    }
    
    if (_isEditMode) {
      await _handleEditMode(game, frameIndex);
    } else {
      await _handleInputMode(game, frameIndex);
    }
  }

  /// 檢查某個frame是否有數據
  bool _hasDataInFrame(_GameUIState game, int frameIndex) {
    // 計算到此frame為止應該有多少個roll
    int expectedRolls = 0;
    for (int i = 0; i <= frameIndex && i < 9; i++) {
      if (i * 2 + 1 < game.rolls.length && game.rolls[i * 2] == 10) {
        expectedRolls += 1; // strike只有一球
      } else {
        expectedRolls += 2; // 其他情況兩球
      }
    }
    
    // 第10格特殊處理
    if (frameIndex == 9) {
      expectedRolls = game.rolls.length; // 第10格可能有1-3球
      return expectedRolls > 0;
    }
    
    return game.rolls.length >= expectedRolls;
  }

  /// 處理編輯模式（重新輸入整個frame的資料）
  Future<void> _handleEditMode(_GameUIState game, int frameIndex) async {
    // 1) 計算此 frame 在 rolls/rollStates 的範圍
    final range = _getFrameRollRange(game, frameIndex);
    final int start = range.$1;
    final int endExclusive = range.$2;

    // 2) 保存後續 frames 的尾端資料
    final List<int> tailRolls = endExclusive < game.rolls.length
        ? game.rolls.sublist(endExclusive)
        : <int>[];
    final List<List<bool>> tailStates = endExclusive < game.rollStates.length
        ? game.rollStates.sublist(endExclusive)
        : <List<bool>>[];

    // 3) 先移除本 frame 與之後的資料（暫存後續資料，稍後再接回）
    if (start < game.rolls.length) {
      game.rolls.removeRange(start, game.rolls.length);
    }
    if (start < game.rollStates.length) {
      game.rollStates.removeRange(start, game.rollStates.length);
    }

    // 4) 重新輸入完整的 frame 資料（會 append 到結尾）
    await _inputCompleteFrame(game, frameIndex);

    // 5) 把先前的尾端資料接回來，保留後面既有的 8/9/10 格
    if (tailRolls.isNotEmpty || tailStates.isNotEmpty) {
      setState(() {
        game.rolls.addAll(tailRolls);
        game.rollStates.addAll(tailStates);
        game.updateFrames(widget.trainingSession.scoringMethod);
      });
    }
  }

  /// 處理輸入模式（可以單球輸入，不強制完成frame）
  Future<void> _handleInputMode(_GameUIState game, int frameIndex) async {
    // 檢查是否應該從下一個可用位置開始輸入
    final nextInputFrame = _getNextInputFrame(game);
    if (nextInputFrame != frameIndex) {
      // 只允許點擊下一個應該輸入的frame
      return;
    }
    
    await _inputNextRoll(game, frameIndex);
  }

  /// 獲取下一個應該輸入的frame索引
  int _getNextInputFrame(_GameUIState game) {
    if (game.rolls.isEmpty) return 0;
    
    int currentFrame = 0;
    int rollIndex = 0;
    
    while (rollIndex < game.rolls.length && currentFrame < 9) {
      if (game.rolls[rollIndex] == 10) {
        // Strike，移到下一frame
        rollIndex += 1;
        currentFrame += 1;
      } else if (rollIndex + 1 < game.rolls.length) {
        // 有第二球，檢查是否完成frame
        rollIndex += 2;
        currentFrame += 1;
      } else {
        // 只有第一球，還需要第二球
        return currentFrame;
      }
    }
    
    // 到達第10格或所有格子都完成
    return currentFrame;
  }

  /// 輸入下一球
  Future<void> _inputNextRoll(_GameUIState game, int frameIndex) async {
    final controller = PinSelectionController();
    
    // 依據開發者頁面策略計算本格是否為邏輯第一球，並決定初始狀態
    bool isFirstRollOfFrame;
    List<bool>? initialPinState;
    if (frameIndex < 9) {
      isFirstRollOfFrame = _isFirstRollOfFrame(game, frameIndex);
      if (!isFirstRollOfFrame) {
        final firstRollIndex = _getFirstRollIndexOfFrame(game, frameIndex);
        if (firstRollIndex >= 0 && firstRollIndex < game.rollStates.length) {
          initialPinState = game.rollStates[firstRollIndex];
        }
      }
    } else {
      // 第10格：使用 PinStatePolicy 與現有 rolls/rollStates 的切片
      final start10 = _getFirstRollIndexOfFrame(game, 9);
      final rolls10 = start10 < game.rolls.length ? game.rolls.sublist(start10) : <int>[];
      final states10 = start10 < game.rollStates.length ? game.rollStates.sublist(start10) : <List<bool>>[];
      if (widget.trainingSession.scoringMethod.toLowerCase() == 'current') {
        initialPinState = PinStatePolicy.initialStateForFrame10Current(rolls10, states10);
      } else {
        initialPinState = PinStatePolicy.initialStateForFrame10Traditional(rolls10, states10);
      }
      isFirstRollOfFrame = PinStatePolicy.isLogicalFirst(initialPinState);
    }
    
    final result = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PinSelectionDialog(
        controller: controller,
        isFirstRoll: isFirstRollOfFrame,
        frameNumber: frameIndex + 1,
        initialPinState: initialPinState,
      ),
    );
    
    if (result != null) {
      setState(() {
        game.rolls.add(result.where((b) => b).length);
        game.rollStates.add(result);
        game.updateFrames(widget.trainingSession.scoringMethod);
      });
      // 背景同步（不影響 UI）
      _persistGameSilently(game);
    }
  }

  /// 輸入完整frame（用於編輯模式）
  Future<void> _inputCompleteFrame(_GameUIState game, int frameIndex) async {
    final controller = PinSelectionController();
    
    // 第一球
    final first = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PinSelectionDialog(
        controller: controller,
        isFirstRoll: true,
        frameNumber: frameIndex + 1,
      ),
    );
    if (first == null) return;
    final firstKnocked = first.where((b) => b).length;

    // 第二球（如果需要）
    List<bool>? second;
    if (firstKnocked < 10 || frameIndex == 9) {
      final secondController = PinSelectionController();
      
      // 決定第二球的初始狀態
      List<bool>? initialStateForSecond;
      if (frameIndex == 9) {
        // 第10格：根據計分模式決定
        final isTraditional = widget.trainingSession.scoringMethod.toLowerCase() == 'traditional';
        if (isTraditional && firstKnocked == 10) {
          // 傳統模式下第一球全倒，第二球應該是全新的球瓶
          initialStateForSecond = null;
        } else {
          // 其他情況：第二球基於第一球的結果
          initialStateForSecond = first;
        }
      } else {
        // 1-9格：第二球基於第一球的結果
        initialStateForSecond = first;
      }
      
      second = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: true,
        builder: (context) => PinSelectionDialog(
          controller: secondController,
          initialPinState: initialStateForSecond,
          isFirstRoll: frameIndex == 9 && firstKnocked == 10 && widget.trainingSession.scoringMethod.toLowerCase() == 'traditional',
          frameNumber: frameIndex + 1,
        ),
      );
    }

    // 第三球（第十格專用）
    List<bool>? third;
    if (frameIndex == 9) {
      final totalFirstTwo = firstKnocked + (second?.where((b) => b).length ?? 0);
      final needThird = firstKnocked == 10 || totalFirstTwo >= 10;
      if (needThird) {
        final thirdController = PinSelectionController();
        
        // 決定第三球的初始狀態
        List<bool>? initialStateForThird;
        final isTraditional = widget.trainingSession.scoringMethod.toLowerCase() == 'traditional';
        
        if (isTraditional) {
          if (firstKnocked == 10) {
            // 第一球全倒：第三球基於第二球的結果
            initialStateForThird = second;
          } else if (totalFirstTwo >= 10) {
            // 第一+二球spare：第三球是全新的球瓶
            initialStateForThird = null;
          }
        } else {
          // 現代模式：第三球總是全新的球瓶
          initialStateForThird = null;
        }
        
        third = await showDialog<List<bool>>(
          context: context,
          barrierDismissible: true,
          builder: (context) => PinSelectionDialog(
            controller: thirdController,
            initialPinState: initialStateForThird,
            isFirstRoll: initialStateForThird == null,
            frameNumber: frameIndex + 1,
          ),
        );
      }
    }

    setState(() {
      game.rolls.add(firstKnocked);
      game.rollStates.add(first);
      if (second != null) {
        game.rolls.add(second.where((b) => b).length);
        game.rollStates.add(second);
      }
      if (third != null) {
        game.rolls.add(third.where((b) => b).length);
        game.rollStates.add(third);
      }
      game.updateFrames(widget.trainingSession.scoringMethod);
    });
    // 背景同步（不影響 UI）
    _persistGameSilently(game);
  }

  /// 清除指定frame的資料
  void _clearFrameData(_GameUIState game, int frameIndex) {
    // 僅移除此 frame 已有的投球，不影響後續 frames
    final (int start, int endExclusive) = _getFrameRollRange(game, frameIndex);
    if (start < endExclusive) {
      game.rolls.removeRange(start, endExclusive);
      game.rollStates.removeRange(start, endExclusive);
    }
  }

  /// 回傳某一 frame 在 rolls/rollStates 中的 [start, endExclusive]
  (int, int) _getFrameRollRange(_GameUIState game, int frameIndex) {
    final int start = _getFirstRollIndexOfFrame(game, frameIndex);
    int endExclusive = start;

    if (frameIndex < 9) {
      if (start >= game.rolls.length) {
        endExclusive = start; // 該格尚無資料
      } else if (game.rolls[start] == 10) {
        endExclusive = start + 1; // strike 只有一球
      } else {
        endExclusive = (start + 1 < game.rolls.length) ? start + 2 : start + 1; // 可能只有1或2球
      }
    } else {
      // 第10格：從起點到陣列結尾（1~3 球）
      endExclusive = game.rolls.length;
    }

    // 對 rollStates 同樣適用（兩個長度應一致）
    endExclusive = endExclusive.clamp(start, game.rollStates.length);
    return (start, endExclusive);
  }

  // 將目前 game 狀態背景寫入 Supabase
  Future<void> _persistGameSilently(_GameUIState game) async {
    try {
      // 找到這個遊戲在列表中的索引，確定正確的遊戲編號
      final gameIndex = _addedGames.indexOf(game);
      final gameNumber = game.gameNumber ?? (gameIndex >= 0 ? gameIndex + 1 : 1);

      // 使用轉換器將 UI 狀態轉換為新的 JSON 格式
      final framesJson = GameDataConverter.convertToFramesJson(
        rolls: game.rolls,
        rollStates: game.rollStates,
        scoringMethod: widget.trainingSession.scoringMethod,
      );

      // 計算統計與總分/完成狀態
      final stats = GameDataConverter.calculateStats(framesJson);
      final int totalScore = _calculateTotalScore(game);
      final bool isCompleted = _isGameCompleted(game);

      await _gamesRepo.upsertGame(
        trainingSessionId: widget.trainingSession.id,
        gameNumber: gameNumber,
        scoringMode: widget.trainingSession.scoringMethod.toLowerCase(),
        frames: framesJson,
        equipment: const <Map<String, dynamic>>[], // 未來會擴展
        totalScore: totalScore,
        strikes: stats['strikes']!,
        spares: stats['spares']!,
        isCompleted: isCompleted,
      );
    } catch (e) {
      print('Error persisting game: $e');
      // 靜默失敗
    }
  }

  int _calculateTotalScore(_GameUIState game) {
    int? total;
    for (final f in game.frames) {
      if (f.cumulativeScore != null) {
        total = f.cumulativeScore;
      }
    }
    return total ?? 0;
  }

  bool _isGameCompleted(_GameUIState last) {
    // 先判斷前 1-9 格是否完整
    int frame = 0;
    int i = 0;
    while (i < last.rolls.length && frame < 9) {
      if (last.rolls[i] == 10) {
        frame++;
        i += 1;
      } else {
        if (i + 1 >= last.rolls.length) return false; // 第二球未投
        frame++;
        i += 2;
      }
    }
    if (frame < 9) return false;

    // 第10格完成判斷
    final remaining = last.rolls.length - i;
    final mode = widget.trainingSession.scoringMethod.toLowerCase();
    if (remaining <= 0) return false;

    if (mode == 'current') {
      // Current 模式：第10格Strike只需1球，非Strike需要2球
      final first = last.rolls[i];
      if (first == 10) {
        return true; // Strike，遊戲完成
      } else {
        return remaining >= 2; // 非Strike，需要2球才完成
      }
    } else {
      // Traditional 模式
      if (remaining < 2) return false; // 至少兩球
      final first = last.rolls[i];
      final second = last.rolls[i + 1];
      if (first == 10 || first + second == 10) {
        return remaining >= 3; // 需要第三球
      }
      return true; // 兩球已完成
    }
  }

  /// 判斷是否是frame的第一球
  bool _isFirstRollOfFrame(_GameUIState game, int frameIndex) {
    // 1-9格：模擬走訪前面各格以取得當格第一球索引
    if (frameIndex < 9) {
      final firstIndex = _getFirstRollIndexOfFrame(game, frameIndex);
      // 還沒有任何球：第一球
      if (firstIndex >= game.rolls.length) {
        return true;
      }
      // 已有第一球
      final firstScore = game.rolls[firstIndex];
      if (firstScore == 10) {
        // 該格 strike 視為已完成；若再次開啟輸入視窗，仍視為第一球以保留 Strike 按鈕可用
        return true;
      }
      // 若第二球尚未存在，則不是第一球
      if (firstIndex + 1 >= game.rolls.length) {
        return false;
      }
      // 已有兩球，當作重新編輯，視為第一球
      return true;
    }
    
    // 第10格：使用 PinStatePolicy 判斷
    final start10 = _getFirstRollIndexOfFrame(game, 9);
    final rolls10 = start10 < game.rolls.length ? game.rolls.sublist(start10) : <int>[];
    final states10 = start10 < game.rollStates.length ? game.rollStates.sublist(start10) : <List<bool>>[];
    final initial = widget.trainingSession.scoringMethod.toLowerCase() == 'current'
        ? PinStatePolicy.initialStateForFrame10Current(rolls10, states10)
        : PinStatePolicy.initialStateForFrame10Traditional(rolls10, states10);
    return PinStatePolicy.isLogicalFirst(initial);
  }

  /// 獲取frame第一球在rolls array中的索引
  int _getFirstRollIndexOfFrame(_GameUIState game, int frameIndex) {
    if (frameIndex == 0) return 0;
    
    int rollIndex = 0;
    for (int i = 0; i < frameIndex && i < 9; i++) {
      if (rollIndex < game.rolls.length && game.rolls[rollIndex] == 10) {
        rollIndex += 1;
      } else {
        rollIndex += 2;
      }
    }
    
    return rollIndex;
  }

  void _navigateToEditSession(BuildContext context) {
    // 導航到編輯頁面，傳入當前 session 資料
    context.go('/training/edit/step-1', extra: widget.trainingSession);
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0;
  }

  void _navigateToIndex(BuildContext context, int index) {
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

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    final theme = Theme.of(context);
    
    // 全螢幕模式
    if (_isFullscreen) {
      return _buildFullscreenMode(theme);
    }
    
    // 一般模式
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, theme),
        body: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: _buildDataSection(theme),
            ),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

  /// 建立全螢幕模式的UI
  Widget _buildFullscreenMode(ThemeData theme) {
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildDataSection(theme),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      title: Text(
        '${widget.trainingSession.title} - Details',
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
            context.go('/training');
          }
        },
        tooltip: 'Back',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          color: theme.colorScheme.onSurface,
          onPressed: () => _navigateToEditSession(context),
          tooltip: 'Edit Session',
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 資訊區 - 地點與日期（等寬，純文字）
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Alley',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.trainingSession.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy.MM.dd').format(widget.trainingSession.date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // 等寬的 Oil Pattern 與 Scoring Type
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Oil Pattern',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OvalTag(
                      text: widget.trainingSession.isHousePattern
                          ? 'House Pattern'
                          : '${widget.trainingSession.oilPatternName ?? 'Custom'}${widget.trainingSession.oilPatternLength != null ? ' (${widget.trainingSession.oilPatternLength}ft)' : ''}',
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      horizontalPadding: 6,
                      verticalPadding: 3,
                      borderWidth: 1.2,
                      backgroundOpacity: 0.08,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Scoring Type',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OvalTag(
                      text: widget.trainingSession.scoringMethod,
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      horizontalPadding: 6,
                      verticalPadding: 3,
                      borderWidth: 1.2,
                      backgroundOpacity: 0.08,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatternTypeChip(ThemeData theme) {
    // 假設從 training session 中獲取 pattern type
    // 這裡先用一個假設的值，您可能需要根據實際的資料模型調整
    final patternType = 'Current'; // 或者 'Traditional'
    final isTraditional = patternType.toLowerCase() == 'traditional';
    
    return OvalTag(
      text: patternType,
      color: isTraditional ? Colors.amber : Colors.green,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      horizontalPadding: 12,
      verticalPadding: 6,
      borderWidth: 1.5,
      backgroundOpacity: 0.1,
    );
  }

  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Games',
              TrainingDetailTab.games,
              theme.colorScheme.primary,
            ),
          ),
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Equipment',
              TrainingDetailTab.equipment,
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Statistics',
              TrainingDetailTab.statistics,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  // 數據區：將分頁與內容合併在同一容器
  Widget _buildDataSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Games',
                    TrainingDetailTab.games,
                    theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Equipment',
                    TrainingDetailTab.equipment,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Statistics',
                    TrainingDetailTab.statistics,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _showPinVisualization ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPinVisualization = !_showPinVisualization;
                    });
                  },
                  tooltip: _showPinVisualization ? 'Hide Pin Visualization' : 'Show Pin Visualization',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFullscreen = !_isFullscreen;
                    });
                  },
                  tooltip: _isFullscreen ? 'Exit Fullscreen' : 'Fullscreen',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildTabContent(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArsenalStyleTab(
    ThemeData theme,
    String label,
    TrainingDetailTab tab,
    Color color,
  ) {
    final isSelected = _selectedTab == tab;
    
    return GestureDetector(
      onTap: () => _onTabChanged(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    switch (_selectedTab) {
      case TrainingDetailTab.games:
        return _buildGamesTab(theme);
      case TrainingDetailTab.equipment:
        return _buildEquipmentTab(theme);
      case TrainingDetailTab.statistics:
        return _buildStatisticsTab(theme);
    }
  }

  Widget _buildGamesTab(ThemeData theme) {
    // 強制使用計分表格版本，不顯示摘要卡片清單
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _addedGames.isEmpty
                ? _buildEmptyStateWithAddButton(theme)
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    reverse: false,
                    itemCount: _addedGames.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final displayIndex = index;
                      final game = _addedGames[displayIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 6, right: 6),
                            child: Row(
                              children: [
                                Text(
                                  'Game ${displayIndex + 1}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                OvalTag(
                                  text: _isGameCompleted(game) ? 'Completed' : 'Incompleted',
                                  color: _isGameCompleted(game) ? Colors.green : Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  horizontalPadding: 6,
                                  verticalPadding: 2,
                                  borderWidth: 1.0,
                                  backgroundOpacity: 0.15,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditMode = !_isEditMode;
                                    });
                                  },
                                  child: Text(
                                    _isEditMode ? 'Done' : 'Edit',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // 讓計分板視覺在容器內等比例縮放，參考 Developer Page 的一行設計
                              final width = constraints.maxWidth;
                              return SizedBox(
                                width: width,
                                child: ScoringBoard(
                                  title: null,
                                  frames: game.frames,
                                  onFrameTapped: (i) => _onGameFrameTapped(displayIndex, i),
                                  showThirdBallInTenthFrame: widget.trainingSession.scoringMethod.toLowerCase() != 'current',
                                  singleRow: true,
                                  frameAspectRatio: 0.78,
                                  removeOuterContainer: true,
                                  padding: EdgeInsets.zero,
                                  useGlowText: false,
                                  frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
                                  frameBorderWidth: 1.0,
                                  frameBorderRadius: 4.0,
                                  showFrameShadow: false,
                                  showHeaderNumbers: true,
                                  headerBarHeight: 0.0,
                                  headerBarColor: null,
                                  tenthFrameFlex: 1,
                                  accentColor: theme.colorScheme.primary,
                                  // 內嵌球瓶視覺化（單層）與比例化配置（svg 將沿用高度比）
                                  showPinVisualization: true,
                                  pinVisualizationConfig: PinVisualizationConfig.compact(),
                                  // 傳入每格的球瓶狀態，以便內嵌 SVG 動態填滿/空心
                                  pinStatesPerFrame: List<List<bool>>.generate(10, (i) {
                                    return PinVisualizationHelper.getFramePinStates(
                                      rolls: game.rolls,
                                      rollStates: game.rollStates,
                                      frameIndex: i,
                                    );
                                  }),
                                  isSplitPerFrame: List<bool>.generate(10, (i) {
                                    // 取得第一球的純狀態
                                    final List<bool> firstRoll = PinVisualizationHelper.getFramePinStates(
                                      rolls: game.rolls,
                                      rollStates: game.rollStates,
                                      frameIndex: i,
                                    );
                                    return SplitDetector.isSplit(firstRoll);
                                  }),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 0),
                          // 倒瓶視覺列：顯示每格第一球的倒瓶
                          // 移除外層（第二層）球瓶列，避免重複顯示
                          const SizedBox(height: 12),
                          if (index == _addedGames.length - 1)
                            _buildGameActionButtons(theme),
                        ],
                      );
                    },
                  ),
                  ),
          ),
        ],
      );
  }

  Widget _buildEquipmentTab(ThemeData theme) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: EnhancedTrainingEquipment(
          summary: widget.trainingSession,
          theme: theme,
        ),
      ),
    );
  }

  Widget _buildStatisticsTab(ThemeData theme) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: EnhancedTrainingStats(
          summary: widget.trainingSession,
          theme: theme,
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWithAddButton(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No games recorded',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Games will appear here once recorded',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _addEmptyGame,
            child: Text(
              'Add Games',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _deleteLastGame,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Delete Games',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: _canAddNewGame() ? _addEmptyGame : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Add Games',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _canAddNewGame() ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _canAddNewGame() {
    if (_addedGames.isEmpty) return true;
    final last = _addedGames.last;

    // 使用統一的完成邏輯
    return _isGameCompleted(last);
  }
}