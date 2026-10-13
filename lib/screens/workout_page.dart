import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = [
      {
        'title': 'Full Body Workout',
        'subtitle': 'Latihan seluruh tubuh',
        'duration': '20 menit',
        'icon': Icons.fitness_center,
        'color': const Color(0xFFDDF3E9),
      },
      {
        'title': 'Cardio',
        'subtitle': 'Tingkatkan kebugaran jantung',
        'duration': '15 menit',
        'icon': Icons.directions_run,
        'color': const Color(0xFFFFE8D6),
      },
      {
        'title': 'Stretching',
        'subtitle': 'Peregangan dan fleksibilitas',
        'duration': '10 menit',
        'icon': Icons.self_improvement,
        'color': const Color(0xFFE7E5FF),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pilihan Workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mau olahraga apa hari ini?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Pilih latihan sesuai kebutuhanmu.'),
          const SizedBox(height: 20),
          for (final workout in workouts)
            Card(
              margin: const EdgeInsets.only(bottom: 14),
              color: Colors.white,
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: workout['color'] as Color,
                  child: Icon(
                    workout['icon'] as IconData,
                    color: const Color(0xFF16856B),
                  ),
                ),
                title: Text(
                  workout['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${workout['subtitle']}\n${workout['duration']}'),
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${workout['title']} akan dikembangkan pada tahap detail workout.',
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
