import '../shared/enums.dart'; // Import the shared enum
// import '../views/basic_tournament_info_page.dart'; // REMOVED old import 

class Tournament {
  final String id;
  final String name;
  final String location;
  final DateTime date;
  final TournamentType type;
  final List<String> selectedBallNames;
  final List<int> games; // List to store scores for each game

  Tournament({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.type,
    required this.selectedBallNames,
    required this.games,
  });

  // --- Optional: Methods for JSON serialization (if needed for saving) ---

  // Convert a Tournament object into a Map object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'date': date.toIso8601String(), // Store date as ISO8601 string
        'type': type.toString(), // Store enum as string
        'selectedBallNames': selectedBallNames,
        'games': games,
      };

  // Create a Tournament object from a Map object.
  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String), // Parse ISO8601 string back to DateTime
      type: TournamentType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => TournamentType.open), // Default if parsing fails
      selectedBallNames: List<String>.from(json['selectedBallNames'] as List),
      games: List<int>.from(json['games'] as List),
    );
  }
}
