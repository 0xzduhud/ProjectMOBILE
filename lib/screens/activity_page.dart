import 'package:flutter/material.dart';

import '../models/workout_history_model.dart';
import '../services/database_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final DatabaseService _databaseService = DatabaseService();

  late Future<List<WorkoutHistoryModel>> _historyFuture;

  static const Color green = Color(0xFF16856B);
  static const Color background = Color(0xFFF5F8F6);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _databaseService.getWorkoutHistory();
  }

  Future<void> _refresh() async {
    setState(_loadHistory);
    await _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Aktivitas Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: background,
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () => setState(_loadHistory),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<WorkoutHistoryModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aktivitas belum dapat dimuat.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Periksa koneksi internet dan status login.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => setState(_loadHistory),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final history = snapshot.data ?? [];
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final totalWorkouts = history.length;

          final totalMinutes = history.fold<int>(
            0,
            (sum, item) => sum + item.durationMinutes,
          );

          final totalCalories = history.fold<int>(
            0,
            (sum, item) => sum + item.caloriesBurned,
          );

          final activeDays = history
              .map((item) {
                final date = item.completedAt;
                return '${date.year}-${date.month}-${date.day}';
              })
              .toSet()
              .length;

          // Menghitung durasi untuk tujuh hari terakhir.
          final weekData = List.generate(7, (index) {
            final date = today.subtract(Duration(days: 6 - index));

            final minutes = history
                .where((item) {
                  final completed = item.completedAt;

                  return completed.year == date.year &&
                      completed.month == date.month &&
                      completed.day == date.day;
                })
                .fold<int>(0, (sum, item) => sum + item.durationMinutes);

            return _DayActivity(date: date, minutes: minutes);
          });

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Perkembanganmu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF19332D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pantau konsistensi latihan dan perkembanganmu.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Statistik pertama.
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.fitness_center,
                        title: 'Latihan selesai',
                        value: '$totalWorkouts',
                        unit: 'kali',
                        color: green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department,
                        title: 'Kalori terbakar',
                        value: '$totalCalories',
                        unit: 'kkal*',
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Statistik kedua.
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.timer_outlined,
                        title: 'Total durasi',
                        value: '$totalMinutes',
                        unit: 'menit',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month_outlined,
                        title: 'Hari aktif',
                        value: '$activeDays',
                        unit: 'hari',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const Text(
                  'Aktivitas 7 Hari Terakhir',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF19332D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Durasi olahraga setiap hari dalam menit.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 190,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: weekData.map((day) {
                        final maxMinutes = weekData.fold<int>(
                          0,
                          (max, item) =>
                              item.minutes > max ? item.minutes : max,
                        );

                        return Expanded(
                          child: _ActivityBar(
                            label: _dayName(day.date.weekday),
                            minutes: day.minutes,
                            maxMinutes: maxMinutes,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '*Kalori merupakan estimasi, bukan hasil '
                  'pengukuran sensor.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total $totalWorkouts latihan telah tercatat.',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _dayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return days[weekday - 1];
  }
}

class _DayActivity {
  final DateTime date;
  final int minutes;

  const _DayActivity({required this.date, required this.minutes});
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19332D),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ActivityBar extends StatelessWidget {
  final String label;
  final int minutes;
  final int maxMinutes;

  const _ActivityBar({
    required this.label,
    required this.minutes,
    required this.maxMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final double barHeight = maxMinutes == 0
        ? 4.0
        : (minutes / maxMinutes * 105).clamp(4.0, 105.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$minutes',
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: minutes == 0
                  ? const Color(0xFFE4ECE8)
                  : const Color(0xFF16856B),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
