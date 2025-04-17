import 'package:flutter/material.dart';
import 'dart:collection'; // For UnmodifiableListView
import '../models/tournament.dart'; // Import the Tournament model

class TournamentViewModel extends ChangeNotifier {
  // Private list to store tournaments
  final List<Tournament> _tournaments = [];

  // Public getter for accessing the list (unmodifiable)
  UnmodifiableListView<Tournament> get tournaments => UnmodifiableListView(_tournaments);

  // Method to add a new tournament
  void addTournament(Tournament tournament) {
    _tournaments.add(tournament);
    // Optional: Sort tournaments after adding, e.g., by date descending
    _tournaments.sort((a, b) => b.date.compareTo(a.date)); 
    notifyListeners(); // Notify listeners about the change
  }

  // --- Optional: Methods for loading/saving data ---
  // Future<void> loadTournaments() async {
  //   // TODO: Implement loading from SharedPreferences, database, etc.
  //   // Example: Load from SharedPreferences (requires json_encode/decode)
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final String? tournamentsString = prefs.getString('tournaments');
  //   // if (tournamentsString != null) {
  //   //   final List<dynamic> decodedList = jsonDecode(tournamentsString);
  //   //   _tournaments = decodedList.map((json) => Tournament.fromJson(json)).toList();
  //   // }
  //   notifyListeners(); // Notify after loading
  // }

  // Future<void> saveTournaments() async {
  //   // TODO: Implement saving to SharedPreferences, database, etc.
  //   // Example: Save to SharedPreferences
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final String encodedList = jsonEncode(_tournaments.map((t) => t.toJson()).toList());
  //   // await prefs.setString('tournaments', encodedList);
  // }

  // --- Optional: Methods for deleting/updating ---
  // void removeTournament(String id) {
  //   _tournaments.removeWhere((t) => t.id == id);
  //   notifyListeners();
  //   // saveTournaments(); // Save after removing
  // }

  // void updateTournament(Tournament updatedTournament) {
  //   final index = _tournaments.indexWhere((t) => t.id == updatedTournament.id);
  //   if (index != -1) {
  //     _tournaments[index] = updatedTournament;
  //     notifyListeners();
  //     // saveTournaments(); // Save after updating
  //   }
  // }

}
