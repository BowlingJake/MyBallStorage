import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:intl/intl.dart';       // Import intl for date formatting
import '../viewmodels/tournament_viewmodel.dart'; // Import ViewModel
import '../models/tournament.dart';          // Import Model
import 'basic_tournament_info_page.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
import '../models/bowling_ball.dart';
import 'add_match_record_page.dart';
import '../shared/enums.dart'; // Import the shared enum

// Define enum for dialog result (REMOVED)
// enum AddRecordType { open, championship }

class TournamentRecordPage extends StatelessWidget {
  const TournamentRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the TournamentViewModel for changes
    final tournamentViewModel = context.watch<TournamentViewModel>();
    final tournaments = tournamentViewModel.tournaments;

    return Scaffold(
      appBar: AppBar(title: const Text('賽事記錄')),
      body: tournaments.isEmpty
          // If no tournaments, show a message
          ? const Center(
              child: Text(
                '尚未建立任何賽事紀錄',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ))
          // If there are tournaments, show them in a list
          : ListView.builder(
              padding: const EdgeInsets.all(12.0), // Add padding around the list
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                final tournament = tournaments[index];
                // Build a card for each tournament
                return _buildTournamentCard(context, tournament);
              },
            ),
      // Keep the FAB to add new tournaments
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BasicTournamentInfoPage()),
          );
        },
        label: const Text('建立賽事'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // --- Helper Widget to build a tournament card ---
  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0), // Space between cards
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // --- Navigate to AddMatchRecordPage on tap ---
          print('Navigating for tournament: ${tournament.name}');
          
          // Access the ViewModel to get ball objects
          final weaponViewModel = context.read<WeaponLibraryViewModel>();
          final List<BowlingBall> selectedBallObjects = tournament.selectedBallNames
              .map((name) {
                // Find the ball in the ViewModel's arsenal list
                try {
                  return weaponViewModel.myArsenal.firstWhere((ball) => ball.ball == name);
                } catch (e) {
                  // Handle case where ball might not be found (e.g., deleted after tournament creation)
                  print('Error finding ball: $name in tournament record. Error: $e');
                  return null; // Return null if not found
                }
              })
              .where((ball) => ball != null) // Filter out any nulls
              .cast<BowlingBall>()
              .toList();

          // Optional: Check if all balls were found
          if (selectedBallObjects.length != tournament.selectedBallNames.length) {
             print('Warning: Could not find all ball objects for tournament ${tournament.id}');
             // Decide how to handle this - maybe show a message or proceed anyway?
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMatchRecordPage(
                tournamentId: tournament.id,
                tournamentName: tournament.name,
                tournamentLocation: tournament.location,
                tournamentDate: tournament.startDate,
                tournamentType: tournament.type,
                openFormat: tournament.openFormat,
                mqGamesPerSession: tournament.mqGamesPerSession,
                selectedBalls: selectedBallObjects,
              ),
            ),
          );
        },
        onLongPress: () {
          // Navigate to BasicTournamentInfoPage in edit mode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BasicTournamentInfoPage(
                tournamentToEdit: tournament,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left side: Icon or tournament type indicator
              Icon(
                tournament.type == TournamentType.open 
                    ? Icons.public 
                    : Icons.shield, // Example icons
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              // Right side: Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          // Format date range
                          tournament.endDate == null || tournament.startDate == tournament.endDate
                            ? DateFormat('yyyy-MM-dd').format(tournament.startDate) // Single day
                            : '${DateFormat('yyyy-MM-dd').format(tournament.startDate)} - ${DateFormat('yyyy-MM-dd').format(tournament.endDate!)}', // Date range
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tournament.location,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                     // Optionally display number of games or avg score later
                     // const SizedBox(height: 4),
                     // Text('已記錄 ${tournament.games.length} 局', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              // Trailing arrow icon
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
