import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/workout_history_model.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.id;
  }

  /// Menyimpan latihan yang telah diselesaikan.
  Future<void> saveWorkoutHistory({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
  }) async {
    await _client.from('workout_history').insert({
      'user_id': _userId,
      'workout_title': title,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
    });
  }

  /// Mengambil riwayat khusus pengguna yang sedang login.
  Future<List<WorkoutHistoryModel>> getWorkoutHistory() async {
    final response = await _client
        .from('workout_history')
        .select(
          'id, workout_title, completed_at, '
          'duration_minutes, calories_burned',
        )
        .eq('user_id', _userId)
        .order('completed_at', ascending: false);

    return (response as List)
        .map(
          (item) =>
              WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
