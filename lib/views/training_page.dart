import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 假設您的 PinSelectorPopupWidget 在 lib/widgets/dialogs/
import '../widgets/pin_selector_popup_widget.dart';
// 1. 匯入您儲存的 ScoreFrameWidget
//    假設您的 ScoreFrameWidget.dart 在 lib/widgets/
import '../widgets/bowling_score_table.dart';
import '../theme/text_styles.dart';
import '../widgets/primary_button.dart';
import '../widgets/dialogs/add_practice_dialog.dart';
import '../widgets/primary_button.dart';
import 'practice_record_card.dart';
import '../viewmodels/practice_viewmodel.dart';
import '../models/practice_record.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  Future<void> _showAddPracticeDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddPracticeDialog(),
    );
    if (result != null) {
      final vm = context.read<PracticeViewModel>();
      final newRecord = PracticeRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: result['date'] as String,
        location: result['location'] as String,
        oilPattern: result['oilPattern'] as String?,
        games: [],
      );
      vm.addRecord(newRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = context.watch<PracticeViewModel>().records;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Text('練習紀錄', style: AppTextStyles.title),
                const Spacer(),
                MyCustomButton(
                  text: '新增',
                  onPressed: () => _showAddPracticeDialog(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? Center(
                    child: Text(
                      '尚未新增練習紀錄\n請點右上角「新增」',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return PracticeRecordCard(
                        record: records[index],
                        index: index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
