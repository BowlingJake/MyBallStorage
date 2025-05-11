import 'dart:convert';

class PracticeRecord {
  final String id;
  final String date;
  final String location;
  final String? oilPattern;
  final List<Map<String, dynamic>> games; // 每局分數資料

  PracticeRecord({
    required this.id,
    required this.date,
    required this.location,
    this.oilPattern,
    required this.games,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'location': location,
    'oilPattern': oilPattern,
    'games': games,
  };

  factory PracticeRecord.fromJson(Map<String, dynamic> json) => PracticeRecord(
    id: json['id'] as String,
    date: json['date'] as String,
    location: json['location'] as String,
    oilPattern: json['oilPattern'] as String?,
    games: List<Map<String, dynamic>>.from(json['games'] as List),
  );

  static List<PracticeRecord> listFromJson(String jsonStr) {
    final List<dynamic> decoded = json.decode(jsonStr);
    return decoded.map((e) => PracticeRecord.fromJson(e)).toList();
  }

  static String listToJson(List<PracticeRecord> records) {
    return json.encode(records.map((e) => e.toJson()).toList());
  }
} 