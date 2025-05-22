import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/text_styles.dart';
import '../widgets/primary_button.dart';
import '../widgets/bowling_score_table.dart';
import '../widgets/score_game_widget.dart';
import '../models/score_data.dart';
import '../models/practice_record.dart';
import '../viewmodels/practice_viewmodel.dart';
import '../widgets/pin_selector_popup_widget.dart';
import 'dart:async';

class PracticeRecordCard extends StatefulWidget {
  final PracticeRecord record;
  final int index;
  const PracticeRecordCard({super.key, required this.record, required this.index});

  @override
  State<PracticeRecordCard> createState() => _PracticeRecordCardState();
}

class _PracticeRecordCardState extends State<PracticeRecordCard> {
  bool _expanded = false;
  late List<BowlingScoreData> _games;
  bool _isDeleteMode = false;
  late List<bool> _selectedGamesToDelete;
  
  bool _isEditMode = false;
  int _selectedGameForEdit = -1;
  late BowlingScoreData _originalGameData;
  late BowlingScoreData _modifiedGameData;
  bool _hasBeenModified = false;

  @override
  void initState() {
    super.initState();
    // 反序列化 record.games
    _games = widget.record.games.map((g) => BowlingScoreData.fromJson(g)).toList();
  }

  void _addNewGameTable() {
    setState(() {
      _games.add(BowlingScoreData.newGame());
      _saveGames();
    });
  }

  void _onScoreChanged(int gameIdx, BowlingScoreData data) {
    setState(() {
      _games[gameIdx] = data;
      _saveGames();
    });
  }

  void _saveGames() {
    // 將 _games 寫回 record.games 並呼叫 PracticeViewModel.updateRecord
    final vm = context.read<PracticeViewModel>();
    final updated = PracticeRecord(
      id: widget.record.id,
      date: widget.record.date,
      location: widget.record.location,
      oilPattern: widget.record.oilPattern,
      games: _games.map((g) => g.toJson()).toList(),
    );
    vm.updateRecord(updated);
  }

  bool _isLastGameTableComplete() {
    if (_games.isEmpty) return true;
    final last = _games.last.frames;
    // 只要每一格 isComplete 都為 true 就算完成
    return last.every((f) => f.isComplete);
  }

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      if (_isDeleteMode) {
        _selectedGamesToDelete = List<bool>.filled(_games.length, false);
      }
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (_isEditMode) {
        _selectedGameForEdit = -1;
        _hasBeenModified = false;
      } else {
        _selectedGameForEdit = -1;
        _hasBeenModified = false;
      }
    });
  }

  void _selectGameForEdit(int gameIdx) {
    if (!_isEditMode || gameIdx >= _games.length) return;
    
    // 保存原始數據的副本
    _selectedGameForEdit = gameIdx;
    _originalGameData = BowlingScoreData.fromJson(_games[gameIdx].toJson());
    _modifiedGameData = BowlingScoreData.fromJson(_games[gameIdx].toJson());
    
    // 新增：通過彈窗顯示可編輯的格子
    _showEditFramesDialog(gameIdx);
  }
  
  // 新增：顯示可編輯格子的彈窗
  void _showEditFramesDialog(int gameIdx) {
    // 標記哪些格子被修改過
    List<bool> framesModified = List.filled(10, false);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('修改第 ${gameIdx + 1} 局'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('點擊格子進行修改', style: TextStyle(color: Colors.blue)),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double availableWidth = constraints.maxWidth;
                          final double frameWidth = availableWidth / 5; // 一行顯示5個格子
                          
                          return SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(10, (frameIdx) {
                                final frame = _modifiedGameData.frames[frameIdx];
                                final bool isTenth = (frameIdx == 9);
                                final bool hasData = frame.rolls.isNotEmpty;
                                
                                return GestureDetector(
                                  onTap: hasData ? () {
                                    // 關閉當前彈窗，以便顯示Pin selector
                                    Navigator.pop(dialogContext);
                                    
                                    // 修改格子
                                    _handleFrameEdit(frameIdx).then((_) {
                                      // 修改完成後，重新打開彈窗
                                      setStateDialog(() {
                                        framesModified[frameIdx] = true;
                                      });
                                      _showEditFramesDialog(gameIdx);
                                    });
                                  } : null,
                                  child: Container(
                                    width: frameWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: framesModified[frameIdx] ? Colors.red : 
                                               (hasData ? Colors.blue : Colors.grey),
                                        width: framesModified[frameIdx] ? 2 : 1,
                                      ),
                                      color: hasData ? 
                                             (framesModified[frameIdx] ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1)) : 
                                             Colors.grey.withOpacity(0.1),
                                    ),
                                    child: Stack(
                                      children: [
                                        ScoreFrameWidget(
                                          frameNumber: frameIdx + 1,
                                          isTenthFrame: isTenth,
                                          ball1Score: frame.rolls.isNotEmpty ? (isTenth ? _getTenthFrameDisplayScore(0, frame) : frame.rolls[0].displayScore) : null,
                                          ball2Score: frame.rolls.length > 1 ? (isTenth ? _getTenthFrameDisplayScore(1, frame) : frame.rolls[1].displayScore) : null,
                                          ball3Score: isTenth && frame.rolls.length > 2 ? _getTenthFrameDisplayScore(2, frame) : null,
                                          frameTotalScore: frame.totalScore?.toString(),
                                          availableWidth: frameWidth,
                                          isCurrentFrame: false,
                                        ),
                                        if (!hasData)
                                          Positioned.fill(
                                            child: Container(
                                              color: Colors.grey.withOpacity(0.5),
                                              child: Center(
                                                child: Text(
                                                  '無數據',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    // 放棄修改
                    _selectedGameForEdit = -1;
                    _hasBeenModified = false;
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('完成修改'),
                  onPressed: () {
                    // 保存修改
                    _hasBeenModified = framesModified.any((modified) => modified);
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  // 修改：處理修改某個格子
  Future<void> _handleFrameEdit(int frameIdx) async {
    if (_selectedGameForEdit < 0 || _selectedGameForEdit >= _games.length) return;
    if (frameIdx < 0 || frameIdx >= 10) return;
    
    // 檢查該格是否有數據
    final frame = _modifiedGameData.frames[frameIdx];
    if (frame.rolls.isEmpty) {
      // 沒有數據的格子不能修改
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('此格沒有數據，無法修改'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // 顯示 Pin selector 讓用戶修改該格
    await _showPinSelectorForFrame(frameIdx);
  }

  // 修改：顯示 Pin selector 讓用戶修改某個格子
  Future<void> _showPinSelectorForFrame(int frameIdx) {
    // 確保已選擇一個局
    if (_selectedGameForEdit < 0 || _selectedGameForEdit >= _games.length) {
      return Future.value(); // 返回已完成的 Future
    }
    
    final frame = _modifiedGameData.frames[frameIdx];
    
    // 如果沒有數據，不能修改
    if (frame.rolls.isEmpty) {
      return Future.value(); // 返回已完成的 Future
    }
    
    // 根據當前局的情況設置初始 pins down
    Set<int> initialPinsDown = {};
    
    // 記錄原始數據，如果用戶取消修改可以恢復
    final List<Roll> originalRolls = List.from(frame.rolls);
    final bool wasComplete = frame.isComplete;
    
    // 清空該格的數據，準備重新輸入
    _modifiedGameData.frames[frameIdx].rolls.clear();
    _modifiedGameData.frames[frameIdx].isComplete = false;
    
    // 更新狀態，標記為已修改
    setState(() {
      _hasBeenModified = true;
    });
    
    // 使用 Completer 來創建可解析的 Future
    Completer<void> completer = Completer<void>();
    
    // 顯示 Pin selector
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: initialPinsDown,
          pinStandingAssetPath: 'assets/images/pin_standing.svg',
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',
        );
      },
    ).then((dynamic result) {
      // 將 dynamic 結果轉換為 Set<int>?
      Set<int>? pinsHit;
      if (result is Set<int>) {
        pinsHit = result;
      }
      
      if (pinsHit != null) {
        // 用戶選擇了瓶子
        final int pinsDown = pinsHit.length;
        
        // 創建新的 Roll 記錄
        final Roll newRoll = Roll(
          pinsDown: pinsDown,
          pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(pinsHit),
          displayScore: _getDisplayScoreForEdit(pinsDown, frameIdx),
          pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        );
        
        setState(() {
          _modifiedGameData.frames[frameIdx].rolls.add(newRoll);
          _hasBeenModified = true;
          
          if (frameIdx < 9) {
            if (_modifiedGameData.frames[frameIdx].rolls.length == 1 && pinsDown < 10) {
              // 確保傳遞非空集合
              Set<int> firstBallPins = Set.from(pinsHit ?? {}); // 如果 pinsHit 為空，使用空集合
              _showSecondPinSelectorForFrame(frameIdx, firstBallPins).then((_) {
                // 第二球完成後，完成 Future
                completer.complete();
              });
            } else {
              _modifiedGameData.frames[frameIdx].isComplete = true;
              completer.complete();
            }
          } else {
            if (_modifiedGameData.frames[frameIdx].rolls.length == 1) {
              if (pinsDown == 10) {
                _showSecondPinSelectorForFrame(frameIdx, {}).then((_) {
                  completer.complete();
                });
              } else {
                // 確保傳遞非空集合
                Set<int> firstBallPins = Set.from(pinsHit ?? {}); // 如果 pinsHit 為空，使用空集合
                _showSecondPinSelectorForFrame(frameIdx, firstBallPins).then((_) {
                  completer.complete();
                });
              }
            } else if (_modifiedGameData.frames[frameIdx].rolls.length == 2) {
              // 處理第10格的第三球邏輯...
              completer.complete();
            } else {
              _modifiedGameData.frames[frameIdx].isComplete = true;
              completer.complete();
            }
          }
          
          _modifiedGameData.calculateScores();
        });
      } else {
        // 用戶取消了選擇，恢復原始數據
        setState(() {
          _modifiedGameData.frames[frameIdx].rolls.clear();
          _modifiedGameData.frames[frameIdx].rolls.addAll(originalRolls);
          _modifiedGameData.frames[frameIdx].isComplete = wasComplete;
          // 重新計算分數
          _modifiedGameData.calculateScores();
        });
        // 完成 Future
        completer.complete();
      }
    });
    
    // 返回可等待的 Future
    return completer.future;
  }

  // 修改第二球選擇器方法也返回 Future
  Future<void> _showSecondPinSelectorForFrame(int frameIdx, Set<int> firstBallPins) {
    // 使用 Completer 來創建可解析的 Future
    Completer<void> completer = Completer<void>();
    
    Set<int> initialPinsDown = {};
    
    if (firstBallPins.isNotEmpty) {
      initialPinsDown = {1,2,3,4,5,6,7,8,9,10}.difference(
        {1,2,3,4,5,6,7,8,9,10}.difference(firstBallPins)
      );
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: initialPinsDown,
          pinStandingAssetPath: 'assets/images/pin_standing.svg',
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',
        );
      },
    ).then((dynamic result) {
      // 將 dynamic 結果轉換為 Set<int>?
      Set<int>? pinsHit;
      if (result is Set<int>) {
        pinsHit = result;
      }
      
      if (pinsHit != null) {
        final int pinsDown = pinsHit.length;
        final Set<int> nonNullPinsHit = Set.from(pinsHit ?? {}); // 確保使用非空集合
        
        final Roll newRoll = Roll(
          pinsDown: pinsDown,
          pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(nonNullPinsHit.union(firstBallPins)),
          displayScore: _getDisplayScoreForEdit(pinsDown, frameIdx),
          pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(firstBallPins),
        );
        
        setState(() {
          _modifiedGameData.frames[frameIdx].rolls.add(newRoll);
          _hasBeenModified = true;
          
          if (frameIdx == 9) {
            final first = _modifiedGameData.frames[frameIdx].rolls[0].pinsDown;
            final second = pinsDown;
            
            if (first == 10 || first + second == 10) {
              if (first == 10 && second == 10) {
                _showThirdPinSelectorForFrame(frameIdx, {}).then((_) {
                  completer.complete();
                });
              } else if (first == 10) {
                // 使用非空 Set 作為參數
                Set<int> remainingPins = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(nonNullPinsHit);
                _showThirdPinSelectorForFrame(frameIdx, remainingPins).then((_) {
                  completer.complete();
                });
              } else {
                _showThirdPinSelectorForFrame(frameIdx, {}).then((_) {
                  completer.complete();
                });
              }
            } else {
              _modifiedGameData.frames[frameIdx].isComplete = true;
              completer.complete();
            }
          } else {
            _modifiedGameData.frames[frameIdx].isComplete = true;
            completer.complete();
          }
          
          _modifiedGameData.calculateScores();
        });
      } else {
        // 用戶取消選擇
        completer.complete();
      }
    });
    
    // 返回可等待的 Future
    return completer.future;
  }

  // 修改第三球選擇器方法也返回 Future
  Future<void> _showThirdPinSelectorForFrame(int frameIdx, Set<int> remainingPins) {
    // 使用 Completer 來創建可解析的 Future
    Completer<void> completer = Completer<void>();
    
    // 如果不是第10格，返回
    if (frameIdx != 9) {
      completer.complete();
      return completer.future;
    }
    
    // 設置初始 pins down
    Set<int> initialPinsDown = remainingPins;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: initialPinsDown,
          pinStandingAssetPath: 'assets/images/pin_standing.svg',
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',
        );
      },
    ).then((dynamic result) {
      // 將 dynamic 結果轉換為 Set<int>?
      Set<int>? pinsHit;
      if (result is Set<int>) {
        pinsHit = result;
      }
      
      if (pinsHit != null) {
        final int pinsDown = pinsHit.length;
        
        // 創建新的 Roll 記錄
        final Roll newRoll = Roll(
          pinsDown: pinsDown,
          pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(pinsHit),
          displayScore: _getDisplayScoreForEdit(pinsDown, frameIdx),
          pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(remainingPins),
        );
        
        setState(() {
          _modifiedGameData.frames[frameIdx].rolls.add(newRoll);
          _modifiedGameData.frames[frameIdx].isComplete = true;
          _hasBeenModified = true;
          
          // 重新計算分數
          _modifiedGameData.calculateScores();
        });
      }
      
      // 無論如何，都完成 Future
      completer.complete();
    });
    
    // 返回可等待的 Future
    return completer.future;
  }

  String _getDisplayScoreForEdit(int pinsDown, int frameIdx) {
    final Frame currentFrame = _modifiedGameData.frames[frameIdx];
    if (pinsDown == 10 && currentFrame.rolls.isEmpty) return "X";
    if (currentFrame.rolls.length == 1) {
      final int previousPins = currentFrame.rolls[0].pinsDown;
      if (previousPins + pinsDown == 10) return "/";
    }
    return pinsDown.toString();
  }

  void _saveModifiedGame() {
    if (!_isEditMode || _selectedGameForEdit < 0 || !_hasBeenModified) return;
    
    setState(() {
      _games[_selectedGameForEdit] = _modifiedGameData;
      _saveGames();
      
      _selectedGameForEdit = -1;
      _hasBeenModified = false;
    });
    
    _toggleEditMode();
  }

  void _deleteSelectedGames() {
    if (!_isDeleteMode) return;
    for (int i = _selectedGamesToDelete.length - 1; i >= 0; i--) {
      if (_selectedGamesToDelete[i]) {
        _games.removeAt(i);
      }
    }
    _saveGames();
    _toggleDeleteMode();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${widget.record.date} @ ${widget.record.location}',
                style: AppTextStyles.subtitle,
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      if (_isDeleteMode)
                        Row(
                          children: [
                            MyCustomButton(
                              text: '確認刪除',
                              onPressed: () {
                                if (_selectedGamesToDelete.any((isSelected) => isSelected)) {
                                  _deleteSelectedGames();
                                } else {
                                  _toggleDeleteMode();
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            MyCustomButton(
                              text: '取消',
                              onPressed: _toggleDeleteMode,
                            ),
                          ],
                        )
                      else if (_isEditMode)
                        Row(
                          children: [
                            MyCustomButton(
                              text: '確認修改',
                              onPressed: _hasBeenModified ? _saveModifiedGame : null,
                            ),
                            const SizedBox(width: 8),
                            MyCustomButton(
                              text: '取消',
                              onPressed: _toggleEditMode,
                            ),
                          ],
                        )
                      else
                        MyCustomButton(
                          text: '新增練習成績',
                          onPressed: _isLastGameTableComplete() ? _addNewGameTable : null,
                        ),
                      if (!_isDeleteMode && !_isEditMode && _games.isNotEmpty)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MyCustomButton(
                                text: '修改成績',
                                onPressed: _toggleEditMode,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MyCustomButton(
                                text: '刪除成績',
                                onPressed: _toggleDeleteMode,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  if (_games.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Text('尚無練習成績', style: AppTextStyles.caption),
                    )
                  else
                    Column(
                      children: List.generate(_games.length, (gameIdx) {
                        final bool isSelected = _isDeleteMode 
                          ? (_selectedGamesToDelete.length > gameIdx && _selectedGamesToDelete[gameIdx])
                          : (_isEditMode && _selectedGameForEdit == gameIdx);
                        final bool isModified = _isEditMode && _selectedGameForEdit == gameIdx && _hasBeenModified;

                        return GestureDetector(
                          onTap: _isDeleteMode
                              ? () {
                                  setState(() {
                                    if (_selectedGamesToDelete.length > gameIdx) {
                                      _selectedGamesToDelete[gameIdx] = !_selectedGamesToDelete[gameIdx];
                                    }
                                  });
                                }
                              : (_isEditMode && _selectedGameForEdit < 0 ? () => _selectGameForEdit(gameIdx) : null),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 0, bottom: 0),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.withOpacity(0.3) : null,
                                  border: isModified 
                                      ? Border.all(color: Colors.red, width: 2)
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 4, top: 8),
                                      child: Row(
                                        children: [
                                          Text('第${gameIdx + 1}局', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                          if (isModified)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text('(已修改)', style: AppTextStyles.caption.copyWith(color: Colors.red)),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // 正常顯示 BowlingScoreTable
                                    BowlingScoreTable(
                                      scoreData: _games[gameIdx],
                                      onScoreChanged: (data) => _onScoreChanged(gameIdx, data),
                                    ),
                                  ],
                                ),
                              ),
                              if (_isDeleteMode && isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Icon(Icons.check_circle, color: Colors.blue, size: 24),
                                ),
                              if (_isEditMode && _selectedGameForEdit == gameIdx)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Icon(Icons.edit, color: Colors.blue, size: 24),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  String? _getTenthFrameDisplayScore(int ballIndex, Frame frame) {
    if (frame.rolls.length <= ballIndex) return null;
    final roll = frame.rolls[ballIndex];
    
    if (ballIndex == 0) {
      if (roll.pinsDown == 10) return "X";
      return roll.pinsDown.toString();
    } else if (ballIndex == 1) {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls[0].pinsDown < 10 && frame.rolls[0].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    } else {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls[1].pinsDown < 10 && frame.rolls[1].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    }
  }
} 