import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart'; // Import provider
import '../viewmodels/weapon_library_viewmodel.dart'; // Import ViewModel
import '../models/bowling_ball.dart'; // Import BowlingBall
import '../shared/enums.dart'; // Import the shared enum
import 'record_scores_page.dart'; // Import the new page

class AddMatchRecordPage extends StatefulWidget {
  // --- Add parameters to receive data ---
  final String tournamentId; // Need ID to update the correct tournament
  final String tournamentName;
  final String tournamentLocation;
  final DateTime tournamentDate; // Keep original date for display
  final TournamentType tournamentType;
  final OpenTournamentFormat? openFormat;    // Added format details
  final int? mqGamesPerSession;             // Added format details
  final List<BowlingBall> selectedBalls;

  const AddMatchRecordPage({
    super.key,
    required this.tournamentId,
    required this.tournamentName,
    required this.tournamentLocation,
    required this.tournamentDate,
    required this.tournamentType,
    this.openFormat,
    this.mqGamesPerSession,
    required this.selectedBalls,
  });

  @override
  State<AddMatchRecordPage> createState() => _AddMatchRecordPageState();
}

class _AddMatchRecordPageState extends State<AddMatchRecordPage> {
  @override
  void initState() {
    super.initState();
  }

  // Method to determine the number of games per session
  int _getGamesPerSession() {
    if (widget.tournamentType == TournamentType.open && widget.openFormat == OpenTournamentFormat.mq) {
      return widget.mqGamesPerSession ?? 6; // Use MQ setting, default to 6 if null (shouldn't happen with validation)
    } else {
      // Default for Championship or Open Classic
      return 6; // Assuming 6 games for other formats, adjust if needed
    }
  }

  void _navigateToRecordScores() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordScoresPage(
          tournamentId: widget.tournamentId,
          tournamentName: widget.tournamentName,
          gamesPerSession: _getGamesPerSession(),
          // Pass other necessary info if needed by RecordScoresPage
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記錄比賽分數 - ${widget.tournamentName}'),
      ),
      body: Column( // Use Column to place button at the bottom
        children: [
          Expanded( // Make ListView take available space
            child: ListView(
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
                // Display Tournament Type and Format
                Text(
                  '類型: ${widget.tournamentType == TournamentType.open ? '公開賽' : '錦標賽'}'
                  + (widget.tournamentType == TournamentType.open && widget.openFormat != null
                      ? ' (${widget.openFormat == OpenTournamentFormat.mq ? 'MQ' : '經典賽'})'
                      : ''), // Add format if applicable
                  style: Theme.of(context).textTheme.titleMedium
                ),
                const SizedBox(height: 16),

                // Display Selected Balls (using the GridView)
                Text(
                  '使用球具:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true, // Important inside ListView
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 18.0, // Adjusted spacing between rows by adding 8px
                    childAspectRatio: 2.5, // Adjust aspect ratio for card look (width > height)
                  ),
                  itemCount: widget.selectedBalls.length,
                  itemBuilder: (context, index) {
                    final ball = widget.selectedBalls[index];
                    return _buildArsenalStyleBallCard(context, ball);
                  },
                ),
                const Divider(height: 32, thickness: 1),

                // Section title for scores (scores will be added on the next page)
                Text(
                  '比賽成績:',
                   style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // TODO: Display recorded scores here later (e.g., from TournamentViewModel)
                const Center(child: Text('尚未登錄成績', style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
          // Button to navigate to score recording page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('登錄比賽成績'),
              onPressed: _navigateToRecordScores,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  // --- New Ball Card Widget (Adapted from MyArsenalPage) ---
Widget _buildArsenalStyleBallCard(BuildContext context, BowlingBall ball) {
  final isMotiv = ball.brand == 'Motiv Bowling';
  final isStorm = ball.brand == 'Storm Bowling';
  final hasSpecialBg = isMotiv || isStorm;

  // 共用文字風格
  final baseStyle = TextStyle(
    color: hasSpecialBg
      ? Colors.white
      : Theme.of(context).textTheme.bodyMedium?.color,
    shadows: hasSpecialBg
      ? [const Shadow(blurRadius:1, color:Colors.black54, offset: Offset(0.5,0.5))]
      : null,
  );
  final boldStyle   = baseStyle.copyWith(fontSize:16, fontWeight: FontWeight.bold);
  final smallStyle  = baseStyle.copyWith(fontSize:14, color: hasSpecialBg ? Colors.white70 : Colors.grey);
  final detailStyle = baseStyle.copyWith(fontSize:11);

  return Card(
    elevation: 2,
    margin: EdgeInsets.zero,
    color: hasSpecialBg ? (isMotiv ? Colors.red[800] : Colors.blue[800]) : null,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      // 上下間距縮窄、左右保 8px
      padding: const EdgeInsets.symmetric(vertical:4, horizontal:4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,  // 照片往上對齊
        children: [
          // 左側照片區
          Container(
            width:60, height:60,
            decoration: BoxDecoration(
              color: hasSpecialBg
                ? Colors.black.withOpacity(0.2)
                : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Icon(Icons.sports_handball, size:20, color:Colors.white70),
            ),
          ),
          const SizedBox(width:8),
          // 右側文字區
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ball.ball,
                  style: boldStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
            ),
                Text(
                  ball.brand,
                  style: smallStyle,
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