import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/text_styles.dart';
import '../widgets/primary_button.dart';
import '../widgets/bowling_score_table.dart';
import '../models/score_data.dart';
import '../models/practice_record.dart';
import '../viewmodels/practice_viewmodel.dart';

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
                      MyCustomButton(
                        text: '新增練習成績',
                        onPressed: _isLastGameTableComplete() ? _addNewGameTable : null,
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
                        return Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 4),
                                child: Text('第${gameIdx + 1}局', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              BowlingScoreTable(
                                scoreData: _games[gameIdx],
                                onScoreChanged: (data) => _onScoreChanged(gameIdx, data),
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
} 