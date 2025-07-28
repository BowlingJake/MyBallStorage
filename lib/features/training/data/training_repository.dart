import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrainingRepository {
  final SupabaseClient _supabase;

  TrainingRepository(this._supabase);

  Future<void> updateGameNotes(String gameId, String? notes) async {
    try {
      await _supabase
          .from('games')
          .update({'notes': notes})
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to update game notes: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _supabase
          .from('games')
          .delete()
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  Future<List<TrainingRecord>> getTrainingRecords() async {
    try {
      final response = await _supabase
          .from('training_records')
          .select('*')
          .order('timestamp', ascending: false);
      
      return response
          .map((json) => TrainingRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch training records: $e');
    }
  }

  Future<void> updateTrainingRecord(TrainingRecord record) async {
    try {
      await _supabase
          .from('training_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      throw Exception('Failed to update training record: $e');
    }
  }
}