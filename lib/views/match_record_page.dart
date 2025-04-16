import 'package:flutter/material.dart';
// Import the new page we will create
import 'add_match_record_page.dart'; 

class MatchRecordPage extends StatelessWidget {
  const MatchRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('比賽記錄')),
      body: const Center(child: Text('這裡是比賽記錄頁 - 尚未有紀錄')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMatchRecordPage()),
          );
        },
        label: const Text('新增紀錄'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
