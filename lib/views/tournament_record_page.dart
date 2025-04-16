import 'package:flutter/material.dart';
// Import the new page for basic info
import 'basic_tournament_info_page.dart'; // Import the new page

// Define enum for dialog result (REMOVED)
// enum AddRecordType { open, championship }

class TournamentRecordPage extends StatelessWidget {
  const TournamentRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('賽事記錄')), // Renamed AppBar slightly
      body: const Center(child: Text('這裡是賽事記錄頁 - 尚未有紀錄')), // Renamed body text slightly
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Directly navigate to the basic info page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BasicTournamentInfoPage()),
          );
        },
        label: const Text('建立賽事'), // Renamed button label
        icon: const Icon(Icons.add),
      ),
    );
  }
}
