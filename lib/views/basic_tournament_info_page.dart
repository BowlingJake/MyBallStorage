import 'package:flutter/material.dart';
import '../shared/enums.dart'; // for TournamentType
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../models/bowling_ball.dart';
import '../models/tournament.dart'; // Correct model import
import '../viewmodels/tournament_viewmodel.dart';
import '../viewmodels/weapon_library_viewmodel.dart'; // For ball selection
import 'ball_library_page.dart'; // For navigating to ball selection
import '../shared/dialogs/layout_dialog.dart'; // For layout dialog
import '../theme/text_styles.dart';

// Removed TournamentType and OpenTournamentFormat enums if they were defined here
// Assuming they are defined in tournament_model.dart or elsewhere
class BasicTournamentInfoPage extends StatefulWidget {
  final Tournament? tournamentToEdit;

  const BasicTournamentInfoPage({super.key, this.tournamentToEdit});

  @override
  _BasicTournamentInfoPageState createState() => _BasicTournamentInfoPageState();
}

class _BasicTournamentInfoPageState extends State<BasicTournamentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<String> _selectedTournamentBallNames = [];

  @override
  void initState() {
    super.initState();
    // Initialize fields with tournament data if in edit mode
    if (widget.tournamentToEdit != null) {
      final tournament = widget.tournamentToEdit!;
      _nameController.text = tournament.name;
      _locationController.text = tournament.location;
      _selectedStartDate = tournament.startDate;
      _selectedEndDate = tournament.endDate;
      _selectedTournamentBallNames = List.from(tournament.selectedBallNames);
    }
  }

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
      final ballNames = _selectedTournamentBallNames;
      
      final newTournament = Tournament(
        id: widget.tournamentToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        location: location,
        startDate: startDate,
        endDate: endDate,
        type: TournamentType.open,
        selectedBallNames: ballNames,
        games: widget.tournamentToEdit?.games ?? [],
      );

      try {
        final tournamentViewModel = context.read<TournamentViewModel>();
        if (widget.tournamentToEdit != null) {
          tournamentViewModel.updateTournament(newTournament);
        } else {
          tournamentViewModel.addTournament(newTournament);
        }

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
    return GestureDetector(
      onLongPress: () {
        // Import the layout dialog functionality
        showBallActionDialog(
          context,
          ball,
          () {
            setState(() {});
          },
          directToLayout: true,
        );
      },
      child: Card(
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
      appBar: AppBar(title: const Text('建立賽事 - 基本資料', style: AppTextStyles.title)),
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
                labelStyle: AppTextStyles.body,
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
                      labelStyle: AppTextStyles.body,
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
                    labelStyle: AppTextStyles.body,
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

            // Ball Selection Button
            ElevatedButton.icon(
              icon: const Icon(Icons.sports_baseball), 
              label: const Text('選擇賽事用球 (可複選)', style: AppTextStyles.button),
              onPressed: () async {
                  // Expect a List<String> now
                  final selectedNames = await Navigator.push<List<String>?>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BallLibraryPage(isSelectionMode: true),
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
                 child: const Text('尚未選擇賽事用球', style: AppTextStyles.caption),
              ),

            const SizedBox(height: 24),

            // Save Button
            Padding(
              padding: const EdgeInsets.only(top: 32.0), // Add space before button
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('儲存並下一步', style: AppTextStyles.button),
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