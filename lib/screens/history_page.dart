import 'package:flutter/material.dart';

import '../models/workout_history_model.dart';
import '../services/database_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseService _databaseService = DatabaseService();

  late Future<List<WorkoutHistoryModel>> _historyFuture;

  static const Color _green = Color(0xFF16856B);
  static const Color _background = Color(0xFFF5F8F6);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _databaseService.getWorkoutHistory();
  }

  Future<void> _refreshHistory() async {
    setState(_loadHistory);
    await _historyFuture;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDay(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Aktivitas Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _background,
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () {
              setState(_loadHistory);
            },
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
                      size: 52,
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
                      'Periksa koneksi internet dan konfigurasi '
                      'Supabase, lalu coba lagi.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(_loadHistory);
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final history = snapshot.data ?? [];

          final totalWorkouts = history.length;
          final totalMinutes = history.fold<int>(
            0,
            (total, item) => total + item.durationMinutes,
          );
          final totalCalories = history.fold<int>(
            0,
            (total, item) => total + item.caloriesBurned,
          );

          final activeDays = history
              .map(
                (item) =>
                    '${item.completedAt.year}-'
                    '${item.completedAt.month}-'
                    '${item.completedAt.day}',
              )
              .toSet()
              .length;

          final today = DateTime.now();
          final todayDate = DateTime(today.year, today.month, today.day);

          // Grafik tujuh hari, termasuk hari ini.
          final weekData = List.generate(7, (index) {
            final date = todayDate.subtract(Duration(days: 6 - index));

            final minutes = history
                .where((item) {
                  return item.completedAt.year == date.year &&
                      item.completedAt.month == date.month &&
                      item.completedAt.day == date.day;
                })
                .fold<int>(0, (total, item) => total + item.durationMinutes);

            return _DayActivity(date: date, minutes: minutes);
          });

          return RefreshIndicator(
            onRefresh: _refreshHistory,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                const Text(
                  'Perkembanganmu',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF19332D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Setiap latihan adalah langkah menuju '
                  'kebiasaan yang lebih sehat.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Ringkasan statistik.
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.fitness_center,
                        title: 'Latihan selesai',
                        value: '$totalWorkouts',
                        unit: 'kali',
                        color: _green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.local_fire_department,
                        title: 'Kalori',
                        value: '$totalCalories',
                        unit: 'kkal*',
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.timer_outlined,
                        title: 'Total durasi',
                        value: '$totalMinutes',
                        unit: 'menit',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.calendar_month_outlined,
                        title: 'Hari aktif',
                        value: '$activeDays',
                        unit: 'hari',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Grafik aktivitas mingguan.
                const Text(
                  'Aktivitas 7 Hari Terakhir',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF19332D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Durasi olahraga per hari dalam menit.',
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
                        return Expanded(
                          child: _BarColumn(
                            label: _formatDay(day.date),
                            minutes: day.minutes,
                            maxMinutes: weekData.fold<int>(
                              0,
                              (max, item) =>
                                  item.minutes > max ? item.minutes : max,
                            ),
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
                const SizedBox(height: 28),

                // Daftar riwayat.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Latihan',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF19332D),
                      ),
                    ),
                    Text(
                      '$totalWorkouts aktivitas',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (history.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.directions_run, size: 52, color: _green),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada aktivitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Selesaikan latihan pertamamu. '
                          'Catatannya akan muncul di sini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                else
                  ...history.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F3EC),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: _green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatDate(item.completedAt),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '${item.durationMinutes} menit'
                                  '  •  ${item.caloriesBurned} kkal*',
                                  style: const TextStyle(
                                    color: _green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.verified, color: _green),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DayActivity {
  final DateTime date;
  final int minutes;

  const _DayActivity({required this.date, required this.minutes});
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final Color color;

  const _SummaryCard({
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
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 14),
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

class _BarColumn extends StatelessWidget {
  final String label;
  final int minutes;
  final int maxMinutes;

  const _BarColumn({
    required this.label,
    required this.minutes,
    required this.maxMinutes,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16856B);

    final barHeight = maxMinutes == 0
        ? 4.0
        : (minutes / maxMinutes * 105).clamp(4.0, 105.0);

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
              color: minutes == 0 ? const Color(0xFFE4ECE8) : green,
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
