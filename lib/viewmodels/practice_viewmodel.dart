import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/practice_record.dart';

class PracticeViewModel extends ChangeNotifier {
  static const String _storageKey = 'practice_records';
  final List<PracticeRecord> _records = [];

  UnmodifiableListView<PracticeRecord> get records => UnmodifiableListView(_records);

  Future<void> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      _records.clear();
      _records.addAll(PracticeRecord.listFromJson(jsonStr));
      notifyListeners();
    }
  }

  Future<void> saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, PracticeRecord.listToJson(_records));
  }

  void addRecord(PracticeRecord record) {
    _records.add(record);
    saveRecords();
    notifyListeners();
  }

  void updateRecord(PracticeRecord record) {
    final idx = _records.indexWhere((r) => r.id == record.id);
    if (idx != -1) {
      _records[idx] = record;
      saveRecords();
      notifyListeners();
    }
  }

  void removeRecord(String id) {
    _records.removeWhere((r) => r.id == id);
    saveRecords();
    notifyListeners();
  }
} 