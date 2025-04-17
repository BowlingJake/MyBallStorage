import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart'; // Import provider
import '../viewmodels/weapon_library_viewmodel.dart'; // Import ViewModel
import '../models/bowling_ball.dart'; // Import BowlingBall
import '../shared/enums.dart'; // Import the shared enum
// Removed import for WeaponLibraryPage as it's not directly used for navigation FROM here.

// Define TournamentType enum here or import from a shared location
// enum TournamentType { open, championship } // Removed local definition

class AddMatchRecordPage extends StatefulWidget {
  // --- Add parameters to receive data ---
  final String tournamentName;
  final String tournamentLocation;
  final DateTime tournamentDate;
  final TournamentType tournamentType; // Added tournament type
  final List<BowlingBall> selectedBalls;

  const AddMatchRecordPage({
    super.key,
    required this.tournamentName,
    required this.tournamentLocation,
    required this.tournamentDate,
    required this.tournamentType, // Added requirement
    required this.selectedBalls,
  });

  @override
  State<AddMatchRecordPage> createState() => _AddMatchRecordPageState();
}

class _AddMatchRecordPageState extends State<AddMatchRecordPage> {
  // Keep form key if needed for score inputs
  // final _formKey = GlobalKey<FormState>(); 

  @override
  void initState() {
    super.initState();
    print('--- AddMatchRecordPage Init: Received ${widget.selectedBalls.length} balls, Type: ${widget.tournamentType} ---');
  }

  // Dispose is fine as is if no new controllers specific to this state were added

  void _saveFullRecord() {
    // TODO: Implement logic to save the full match record (basic info + scores etc.)
    print('--- Saving Full Match Record --- ');
    print('Name: ${widget.tournamentName}');
    print('Location: ${widget.tournamentLocation}');
    print('Date: ${DateFormat('yyyy-MM-dd').format(widget.tournamentDate)}');
    print('Type: ${widget.tournamentType}'); // Log type
    print('Balls: ${widget.selectedBalls.map((b) => b.ball).join(', ')}');
    // Add game scores etc.
    
    // Example: Pop back two steps after saving
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel might not be needed if card doesn't use it directly, but keep for potential future use
    // final viewModel = context.read<WeaponLibraryViewModel>(); 
    print('--- AddMatchRecordPage Build --- ');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('記錄比賽分數 - ${widget.tournamentName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), 
            tooltip: '完成並儲存',
            onPressed: _saveFullRecord,
          ),
        ],
      ),
      body: ListView( // Use ListView for overall scrollability including scores
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Display Basic Info (Read Only) in Rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out items
            children: [
              Expanded( // Allow location to expand if needed
                child: Text(
                  '地點: ${widget.tournamentLocation}', 
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis, // Handle long locations
                ),
              ),
              const SizedBox(width: 16), // Add spacing
              Text(
                '日期: ${DateFormat('yyyy-MM-dd').format(widget.tournamentDate)}', 
                style: Theme.of(context).textTheme.titleMedium
              ),
            ],
          ),
          const SizedBox(height: 8), // Space between rows
          // Display Tournament Type
          Text(
            '類型: ${widget.tournamentType == TournamentType.open ? '公開賽' : '錦標賽'}', 
            style: Theme.of(context).textTheme.titleMedium
          ),
          const SizedBox(height: 16),
          
          // Display Selected Balls (using the GridView)
          Text(
            '使用球具:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          // Replace ListView with GridView
          GridView.builder(
            shrinkWrap: true, // Important inside ListView
            physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 10.0, // Spacing between rows
              childAspectRatio: 1.8, // Adjust aspect ratio for card look (width > height)
            ),
            itemCount: widget.selectedBalls.length,
            itemBuilder: (context, index) {
              final ball = widget.selectedBalls[index];
              // Call the new card builder method
              return _buildArsenalStyleBallCard(context, ball); 
            },
          ),
          const Divider(height: 32, thickness: 1),

          // --- Add Game Score Input Fields Here ---
          Text(
            '輸入各局分數:',
             style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // TODO: Add TextFormFields for each game, potentially dynamically
          TextFormField(
             decoration: const InputDecoration(labelText: '第一局分數', border: OutlineInputBorder()),
             keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
           TextFormField(
             decoration: const InputDecoration(labelText: '第二局分數', border: OutlineInputBorder()),
             keyboardType: TextInputType.number,
          ),
          // ... add more game inputs ...
          
        ],
      ),
    );
  }

  // --- New Ball Card Widget (Adapted from MyArsenalPage) ---
  Widget _buildArsenalStyleBallCard(BuildContext context, BowlingBall ball) {
    // Determine special background (Example based on MyArsenalPage)
    bool isMotiv = ball.brand == 'Motiv Bowling';
    bool isStorm = ball.brand == 'Storm Bowling'; // Make sure brand name matches
    bool hasSpecialBackground = isMotiv || isStorm;

    // Define text styles based on background
    final baseTextStyle = TextStyle(
      color: hasSpecialBackground ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
      shadows: hasSpecialBackground ? [const Shadow(blurRadius: 1.0, color: Colors.black54, offset: Offset(0.5, 0.5))] : null,
    );
    final boldTextStyle = baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold); // Slightly smaller for grid
    final smallTextStyle = baseTextStyle.copyWith(fontSize: 11, color: hasSpecialBackground ? Colors.white70 : Colors.grey);
    final detailTextStyle = baseTextStyle.copyWith(fontSize: 12);

    // Card structure (Simplified: No InkWell, no delete, no selection state)
    return Card( // Wrap in a Card for elevation/border
      elevation: 2.0,
      margin: EdgeInsets.zero, // Grid spacing handles margin
      color: hasSpecialBackground ? (isMotiv ? Colors.red[800] : Colors.blue[800]) : null, // Example background colors
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
          children: [
            // Left part (Image Placeholder) - Simplified
            Container(
              width: 50, // Smaller image for grid
              height: 50,
              decoration: BoxDecoration(
                 color: hasSpecialBackground ? Colors.black.withOpacity(0.2) : Colors.grey[300],
                 borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(child: Icon(Icons.sports_handball, size: 30, color: Colors.white70)), // Placeholder icon
            ),
            const SizedBox(width: 8),
            // Right part (Details)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                children: [
                  Text(
                    ball.ball,
                    style: boldTextStyle,
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ball.brand,
                    style: smallTextStyle,
                    overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                   // Simplified details - Add more if needed
                  Text(
                    'Core: ${ball.core}', // Directly use core name if available
                    style: detailTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                   Text(
                    'Cover: ${ball.coverstockcategory}',
                    style: detailTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Removed _buildSimpleSelectedBallChip method
} 