import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'my_arsenal_page.dart'; // Import MyArsenalPage
import 'package:provider/provider.dart'; // Import Provider
import '../viewmodels/weapon_library_viewmodel.dart'; // Import ViewModel
import '../models/bowling_ball.dart'; // Import BowlingBall model

// Define an enum for tournament types (can be reused here)
enum TournamentType { open, championship }

class BasicTournamentInfoPage extends StatefulWidget {
  const BasicTournamentInfoPage({super.key});

  @override
  State<BasicTournamentInfoPage> createState() => _BasicTournamentInfoPageState();
}

class _BasicTournamentInfoPageState extends State<BasicTournamentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TournamentType? _selectedTournamentType;
  List<String> _selectedTournamentBallNames = []; // Store list of names

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAndProceed() {
     FocusScope.of(context).unfocus(); // Dismiss keyboard
     if (_formKey.currentState!.validate()) {
        if (_selectedDate == null) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('請選擇賽事日期')),
           );
           return;
        }
        if (_selectedTournamentType == null) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('請選擇賽事種類')),
           );
           return;
        }
        // Update validation for selected balls list
        if (_selectedTournamentBallNames.isEmpty) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('請選擇至少一顆賽事用球')),
           );
           return;
        }

        // Data is valid, print it for now
        final name = _nameController.text;
        final location = _locationController.text;
        final date = _selectedDate!;
        final type = _selectedTournamentType!;
        final ballNames = _selectedTournamentBallNames; // Get the list

        print('--- 賽事基本資料 ---');
        print('名稱: $name');
        print('地點: $location');
        print('日期: ${DateFormat('yyyy-MM-dd').format(date)}');
        print('種類: ${type == TournamentType.open ? '公開賽' : '錦標賽'}');
        print('選用球: ${ballNames.join(', ')}'); // Print selected ball names
        print('------------------');

        // TODO: Navigate to the next page based on type, passing the data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('基本資料已儲存 (下一步待實作: ${type == TournamentType.open ? '公開賽' : '錦標賽'} 細節頁面)')),
        );
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
        .map((name) => viewModel.getBallByName(name)) // Assuming getBallByName exists
        .where((ball) => ball != null) // Filter out any nulls (shouldn't happen ideally)
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

            // Location and Date Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 賽事地點
                Expanded(
                  flex: 2,
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
                const SizedBox(width: 12),
                // 賽事日期選擇器
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '賽事日期',
                        icon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(),
                        errorText: _selectedDate == null && _formKey.currentState?.validate() == false ? '必填' : null, // Basic indicator
                      ),
                      child: Text(
                        _selectedDate == null
                            ? '選擇日期'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey[600] : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            ElevatedButton.icon(
               icon: const Icon(Icons.arrow_forward),
               label: const Text('儲存並下一步'),
               onPressed: _saveAndProceed,
            )
          ],
        ),
      ),
    );
  }
} 