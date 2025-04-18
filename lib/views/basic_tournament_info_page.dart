import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'my_arsenal_page.dart'; // Import MyArsenalPage
import 'package:provider/provider.dart'; // Import Provider
import '../viewmodels/weapon_library_viewmodel.dart'; // Import ViewModel
import '../models/bowling_ball.dart'; // Import BowlingBall model
import '../models/tournament.dart'; // Assume Tournament model exists
import '../viewmodels/tournament_viewmodel.dart'; // Assume TournamentViewModel exists
import 'add_match_record_page.dart'; // Import AddMatchRecordPage
import '../shared/enums.dart'; // Import the shared enum

// Define an enum for tournament types (can be reused here)
// enum TournamentType { open, championship } // Removed local definition

class BasicTournamentInfoPage extends StatefulWidget {
  const BasicTournamentInfoPage({super.key});

  @override
  State<BasicTournamentInfoPage> createState() => _BasicTournamentInfoPageState();
}

class _BasicTournamentInfoPageState extends State<BasicTournamentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TournamentType? _selectedTournamentType;
  OpenTournamentFormat? _selectedOpenFormat; // Added state for open format
  int? _selectedMqSessions; // Added state for MQ sessions
  int? _selectedMqGamesPerSession; // Added state for MQ games per session
  List<String> _selectedTournamentBallNames = []; // Store list of names

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedStartDate != null && _selectedEndDate != null
          ? DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!)
          : (_selectedStartDate != null 
              ? DateTimeRange(start: _selectedStartDate!, end: _selectedStartDate!) 
              : null),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  void _saveAndProceed() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_selectedStartDate == null || _selectedEndDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請選擇賽事開始與結束日期')),
        );
        return;
      }
      if (_selectedEndDate!.isBefore(_selectedStartDate!)) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('結束日期不能早於開始日期')),
        );
        return;
      }
      if (_selectedTournamentType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請選擇賽事種類')),
        );
        return;
      }
      if (_selectedTournamentType == TournamentType.open && _selectedOpenFormat == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請選擇公開賽的賽事形式')),
        );
        return;
      }
      if (_selectedOpenFormat == OpenTournamentFormat.mq) {
        if (_selectedMqSessions == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('請選擇 MQ 賽事的合計場數')),
          );
          return;
        }
        if (_selectedMqGamesPerSession == null) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('請選擇 MQ 賽事每場的局數')),
          );
          return;
        }
      }
      if (_selectedTournamentBallNames.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請選擇至少一顆賽事用球')),
        );
        return;
      }

      final name = _nameController.text;
      final location = _locationController.text;
      final startDate = _selectedStartDate!;
      final endDate = _selectedEndDate!;
      final type = _selectedTournamentType!;
      final openFormat = _selectedOpenFormat;
      final mqSessions = _selectedMqSessions;
      final mqGamesPerSession = _selectedMqGamesPerSession;
      final ballNames = _selectedTournamentBallNames;

      final newTournament = Tournament(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        location: location,
        startDate: startDate,
        endDate: endDate,
        type: type,
        openFormat: openFormat,
        mqSessions: mqSessions,
        mqGamesPerSession: mqGamesPerSession,
        selectedBallNames: ballNames,
        games: [],
      );

      try {
        final tournamentViewModel = context.read<TournamentViewModel>();
        tournamentViewModel.addTournament(newTournament);

        Navigator.pop(context);

      } catch (e) {
        print("Error saving tournament: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('儲存賽事時發生錯誤')),
        );
      }
    }
  }

  // --- Helper: Build Small Ball Card ---
  Widget _buildSmallBallCard(BuildContext context, BowlingBall ball) {
    // Simplified card representation
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep column tight
          children: [
            // Placeholder for image
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.sports_baseball_outlined, size: 30, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(ball.ball, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(ball.brand, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel to get ball objects from names
    final viewModel = context.watch<WeaponLibraryViewModel>();
    // Find the actual BowlingBall objects based on selected names
    final List<BowlingBall> selectedBalls = _selectedTournamentBallNames
        .map((name) {
          // Find the ball in the ViewModel's arsenal list
          try {
            return viewModel.myArsenal.firstWhere((ball) => ball.ball == name);
          } catch (e) {
            // Handle case where ball might not be found (less likely here but good practice)
            print('Error finding ball: $name in basic info page. Error: $e');
            return null; // Return null if not found
          }
        })
        .where((ball) => ball != null) // Filter out any nulls
        .cast<BowlingBall>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('建立賽事 - 基本資料'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // 賽事名稱
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '賽事名稱',
                icon: Icon(Icons.emoji_events),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '請輸入賽事名稱';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Location and Date Row - Now just Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 賽事地點
                Expanded(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: '賽事地點',
                      icon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    // Optional validator
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date Range Picker Input
             InkWell(
                onTap: () => _selectDateRange(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '賽事期間',
                    icon: const Icon(Icons.date_range),
                    border: const OutlineInputBorder(),
                    errorText: (_selectedStartDate == null || _selectedEndDate == null) && _formKey.currentState?.validate() == false 
                               ? '必填' 
                               : null, // Basic indicator
                  ),
                  child: Text(
                    _selectedStartDate == null || _selectedEndDate == null
                        ? '選擇開始與結束日期'
                        : '${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)} - ${DateFormat('yyyy-MM-dd').format(_selectedEndDate!)}',
                    style: TextStyle(
                      color: _selectedStartDate == null ? Colors.grey[600] : null,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Tournament Type Selection
            Row(
              children: <Widget>[
                const Text('賽事種類:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Radio<TournamentType?>(
                  value: TournamentType.open,
                  groupValue: _selectedTournamentType,
                  onChanged: (TournamentType? value) {
                    setState(() {
                      _selectedTournamentType = value;
                    });
                  },
                ),
                const Text('公開賽'),
                const SizedBox(width: 8),
                Radio<TournamentType?>(
                  value: TournamentType.championship,
                  groupValue: _selectedTournamentType,
                  onChanged: (TournamentType? value) {
                    setState(() {
                      _selectedTournamentType = value;
                    });
                  },
                ),
                const Text('錦標賽'),
              ],
            ),
            // Conditionally show Open Tournament Format selection
            if (_selectedTournamentType == TournamentType.open)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 40.0), // Indent slightly
                child: Row(
                  children: <Widget>[
                    const Text('賽事形式:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Radio<OpenTournamentFormat?>(
                      value: OpenTournamentFormat.mq,
                      groupValue: _selectedOpenFormat,
                      onChanged: (OpenTournamentFormat? value) {
                        setState(() {
                          _selectedOpenFormat = value;
                        });
                      },
                    ),
                    const Text('組合預賽(MQ)'),
                    const SizedBox(width: 8),
                    Radio<OpenTournamentFormat?>(
                      value: OpenTournamentFormat.classic,
                      groupValue: _selectedOpenFormat,
                      onChanged: (OpenTournamentFormat? value) {
                        setState(() {
                          _selectedOpenFormat = value;
                        });
                      },
                    ),
                    const Text('經典賽'),
                  ],
                ),
              ),
            // Conditionally show MQ specific options
            if (_selectedOpenFormat == OpenTournamentFormat.mq)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 40.0), // Indent same as format row
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align dropdowns nicely
                  children: [
                    // Dropdown for number of sessions
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: _selectedMqSessions,
                        hint: const Text('幾場合計'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          isDense: true,
                        ),
                        items: [1, 2, 3].map((int value) {
                          return DropdownMenuItem<int?>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedMqSessions = newValue;
                          });
                        },
                        validator: (value) => value == null ? '必選' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dropdown for games per session
                    Expanded(
                       child: DropdownButtonFormField<int?>(
                        value: _selectedMqGamesPerSession,
                        hint: const Text('每場局數'),
                         decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                           isDense: true,
                        ),
                        items: [3, 4, 5, 6].map((int value) {
                          return DropdownMenuItem<int?>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                             _selectedMqGamesPerSession = newValue;
                          });
                        },
                        validator: (value) => value == null ? '必選' : null,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Ball Selection Button
            ElevatedButton.icon(
              icon: const Icon(Icons.sports_baseball), 
              label: const Text('選擇賽事用球 (可複選)'), // Updated label
              onPressed: () async {
                  // Expect a List<String> now
                  final selectedNames = await Navigator.push<List<String>?>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyArsenalPage(isSelectionMode: true),
                      ),
                  );
                  if (selectedNames != null) {
                      setState(() {
                          _selectedTournamentBallNames = selectedNames;
                      });
                  } 
              },
            ),
            const SizedBox(height: 8),
            // Display selected ball cards
            if (selectedBalls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 0.0), // No indent needed for Wrap
                child: Wrap( // Use Wrap to display cards horizontally
                   spacing: 8.0, // Horizontal space between cards
                   runSpacing: 4.0, // Vertical space between lines
                   children: selectedBalls.map((ball) => _buildSmallBallCard(context, ball)).toList(),
                )
              )
            else
              Padding(
                 padding: const EdgeInsets.only(left: 16.0), 
                 child: const Text('尚未選擇賽事用球', style: TextStyle(color: Colors.grey)),
              ),

            const SizedBox(height: 24),

            // Save Button
            Padding(
              padding: const EdgeInsets.only(top: 32.0), // Add space before button
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('儲存並下一步'),
                onPressed: _saveAndProceed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
} 