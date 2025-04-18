import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:provider/provider.dart';
import '../viewmodels/tournament_viewmodel.dart'; // Assuming we update scores via this ViewModel
import '../models/tournament.dart'; // Might need Tournament model later

class RecordScoresPage extends StatefulWidget {
  final String tournamentId;
  final String tournamentName;
  final int gamesPerSession;

  const RecordScoresPage({
    super.key,
    required this.tournamentId,
    required this.tournamentName,
    required this.gamesPerSession,
  });

  @override
  State<RecordScoresPage> createState() => _RecordScoresPageState();
}

class _RecordScoresPageState extends State<RecordScoresPage> {
  final _formKey = GlobalKey<FormState>();
  // List to hold controllers for each game score input
  late List<TextEditingController> _scoreControllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on the number of games
    _scoreControllers = List.generate(
      widget.gamesPerSession,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveScores() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    if (_formKey.currentState!.validate()) {
      // Collect scores from controllers
      List<int> scores = [];
      bool parseError = false;
      for (int i = 0; i < _scoreControllers.length; i++) {
        final text = _scoreControllers[i].text;
        final score = int.tryParse(text);
        if (score == null || score < 0 || score > 300) { // Basic validation
          parseError = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('G${i + 1} 的分數無效 (請輸入 0-300 之間的數字)')),
          );
          break; // Stop processing on first error
        } else {
          scores.add(score);
        }
      }

      if (!parseError) {
        print('--- Saving Scores for Tournament ${widget.tournamentId} ---');
        print('Scores: $scores');
        // TODO: Implement actual saving logic using TournamentViewModel
        // Example (needs TournamentViewModel method like updateTournamentScores):
        // try {
        //   final viewModel = context.read<TournamentViewModel>();
        //   await viewModel.updateTournamentScores(widget.tournamentId, scores);
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('分數已儲存')),
        //   );
        //   Navigator.pop(context); // Go back after saving
        // } catch (e) {
        //    ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('儲存分數時發生錯誤: $e')),
        //   );
        // }
        
        // Placeholder action: just pop for now
        ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('分數已記錄 (待儲存)')),
           );
        Navigator.pop(context); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登錄分數 - ${widget.tournamentName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '儲存分數',
            onPressed: _saveScores,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView( // Allow scrolling if many games
           padding: const EdgeInsets.all(16.0),
           child: Wrap( // Use Wrap for horizontal arrangement that wraps
             spacing: 12.0, // Horizontal space between inputs
             runSpacing: 12.0, // Vertical space if wraps
             alignment: WrapAlignment.center, // Center items horizontally
             children: List.generate(widget.gamesPerSession, (index) {
                return SizedBox(
                  width: 100, // Fixed width for each input box
                  child: TextFormField(
                    controller: _scoreControllers[index],
                    decoration: InputDecoration(
                      labelText: 'G${index + 1}', // Label like G1, G2, ...
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Only allow digits
                       LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '必填';
                      }
                       final score = int.tryParse(value);
                       if (score == null || score < 0 || score > 300) {
                         return '0-300'; // Short error message inside the box
                       }
                      return null;
                    },
                  ),
                );
             }),
           ),
        ),
      ),
       // Optional: Add a persistent save button at the bottom
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton.icon(
      //     icon: const Icon(Icons.save),
      //     label: const Text('儲存分數'),
      //     onPressed: _saveScores,
      //     style: ElevatedButton.styleFrom(
      //       minimumSize: const Size(double.infinity, 50),
      //     ),
      //   ),
      // ),
    );
  }
} 