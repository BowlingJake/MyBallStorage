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
import '../widgets/editable_bowling_score_table.dart';

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
  List<bool> _framesModified = List.filled(10, false);
  Set<int> _modifiedFrames = {};
  BowlingScoreData? _editingGameData;
  Set<int> _editingModifiedFrames = {};

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _selectedGameForEdit = gameIdx;
    });
  }

  void _showEditDialogForSelectedGame() {
    if (_selectedGameForEdit < 0) return;
    BowlingScoreData editingData = BowlingScoreData.fromJson(_games[_selectedGameForEdit].toJson());
    Set<int> modifiedFrames = {};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('修改第 ${_selectedGameForEdit + 1} 局'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: EditableBowlingScoreTable(
                    scoreData: editingData,
                    modifiedFrames: modifiedFrames,
                    onCellEdit: (frameIdx) {
                      setStateDialog(() {
                        modifiedFrames.add(frameIdx);
                      });
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: modifiedFrames.isNotEmpty
                      ? () {
                          setState(() {
                            _games[_selectedGameForEdit] = editingData;
                            _saveGames();
                            _selectedGameForEdit = -1;
                            _isEditMode = false;
                          });
                          Navigator.of(dialogContext).pop();
                        }
                      : null,
                  child: const Text('確認'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cancelEditGame() {
    setState(() {
      _selectedGameForEdit = -1;
      _isEditMode = false;
    });
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
                              onPressed: _selectedGameForEdit >= 0 ? _showEditDialogForSelectedGame : null,
                            ),
                            const SizedBox(width: 8),
                            MyCustomButton(
                              text: '取消',
                              onPressed: _toggleEditMode,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            MyCustomButton(
                              text: '新增練習成績',
                              onPressed: _isLastGameTableComplete() ? _addNewGameTable : null,
                            ),
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
                          child: Container(
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
                                IgnorePointer(
                                  ignoring: _isEditMode,
                                  child: BowlingScoreTable(
                                    scoreData: _games[gameIdx],
                                    onScoreChanged: (data) => _onScoreChanged(gameIdx, data),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  if (_isEditMode)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                      ],
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