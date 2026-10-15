class WorkoutHistoryModel {
  final int id;
  final String title;
  final DateTime completedAt;
  final int durationMinutes;
  final int caloriesBurned;

  const WorkoutHistoryModel({
    required this.id,
    required this.title,
    required this.completedAt,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  factory WorkoutHistoryModel.fromMap(Map<String, dynamic> map) {
    return WorkoutHistoryModel(
      id: (map['id'] as num).toInt(),
      title: (map['workout_title'] as String?) ?? 'Latihan Gerak.in',
      completedAt: DateTime.parse(map['completed_at'] as String).toLocal(),
      durationMinutes: (map['duration_minutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (map['calories_burned'] as num?)?.toInt() ?? 0,
    );
  }
}
