import '../shared/enums.dart'; // Import the shared enum
// import '../views/basic_tournament_info_page.dart'; // REMOVED old import 

class Tournament {
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime? endDate; // Added endDate, nullable for single-day events
  final TournamentType type;
  final OpenTournamentFormat? openFormat; // Added open format
  final int? mqSessions;                 // Added MQ sessions
  final int? mqGamesPerSession;          // Added MQ games per session
  final List<String> selectedBallNames;
  final List<int> games; // List to store scores for each game

  Tournament({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    this.endDate,      // Optional end date
    required this.type,
    this.openFormat,       // Optional
    this.mqSessions,       // Optional
    this.mqGamesPerSession, // Optional
    required this.selectedBallNames,
    required this.games,
  });

  // --- Optional: Methods for JSON serialization (if needed for saving) ---

  // Convert a Tournament object into a Map object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(), // Store null if endDate is null
        'type': type.toString(), // Store enum as string
        'openFormat': openFormat?.toString(), // Store enum as string or null
        'mqSessions': mqSessions,
        'mqGamesPerSession': mqGamesPerSession,
        'selectedBallNames': selectedBallNames,
        'games': games,
      };

  // Create a Tournament object from a Map object.
  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null, // Parse endDate if not null
      type: TournamentType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => TournamentType.open), // Default if parsing fails
      openFormat: json['openFormat'] == null 
          ? null 
          : OpenTournamentFormat.values.firstWhere(
              (e) => e.toString() == json['openFormat'], 
              orElse: () => OpenTournamentFormat.classic // Provide a default non-null value for orElse
            ),
      mqSessions: json['mqSessions'] as int?,
      mqGamesPerSession: json['mqGamesPerSession'] as int?,
      selectedBallNames: List<String>.from(json['selectedBallNames'] as List),
      games: List<int>.from(json['games'] as List),
    );
  }
}
