import 'package:flutter/material.dart';

class MatchRecordPage extends StatelessWidget {
  const MatchRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('比賽記錄')),
      body: const Center(child: Text('這裡是比賽記錄頁')),
    );
  }
}
