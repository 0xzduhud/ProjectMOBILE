import 'package:flutter/material.dart';

import 'workout_detail_page.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  static const List<Map<String, dynamic>> workouts = [
    {
      'title': 'Home Workout Pemula',
      'category': 'Full Body',
      'duration': 10,
      'description': 'Latihan seluruh tubuh dengan gerakan dasar.',
      'instructions': [
        'Lakukan pemanasan selama 2 menit.',
        'Lakukan jumping jack selama 30 detik.',
        'Lakukan squat sebanyak 10 kali.',
        'Lakukan wall push-up sebanyak 10 kali.',
        'Lakukan plank selama 20 detik.',
        'Akhiri dengan peregangan ringan.',
      ],
    },
    {
      'title': 'Latihan Kaki',
      'category': 'Lower Body',
      'duration': 12,
      'description': 'Latihan sederhana untuk otot kaki.',
      'instructions': [
        'Lakukan pemanasan kaki.',
        'Lakukan squat sebanyak 10 kali.',
        'Lakukan reverse lunge sebanyak 8 kali per kaki.',
        'Lakukan calf raise sebanyak 12 kali.',
        'Istirahat sesuai kebutuhan.',
        'Akhiri dengan peregangan kaki.',
      ],
    },
    {
      'title': 'Latihan Perut',
      'category': 'Core',
      'duration': 10,
      'description': 'Latihan dasar untuk kekuatan otot inti.',
      'instructions': [
        'Lakukan pemanasan ringan.',
        'Lakukan crunch sebanyak 10 kali.',
        'Lakukan plank selama 20 detik.',
        'Lakukan dead bug sebanyak 10 kali.',
        'Istirahat selama 30 detik.',
        'Ulangi sesuai kemampuan.',
      ],
    },
    {
      'title': 'Kardio Ringan',
      'category': 'Cardio',
      'duration': 15,
      'description': 'Gerakan ringan untuk meningkatkan aktivitas fisik.',
      'instructions': [
        'Mulai dengan jalan di tempat selama 2 menit.',
        'Lakukan step touch selama 1 menit.',
        'Lakukan marching knee raise selama 1 menit.',
        'Ulangi gerakan dengan tempo nyaman.',
        'Turunkan intensitas secara bertahap.',
        'Akhiri dengan pendinginan.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      appBar: AppBar(title: const Text('Pilihan Workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temukan latihanmu',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Pilih latihan sesuai kebutuhan dan kemampuanmu.'),
          const SizedBox(height: 20),
          ...workouts.map((workout) {
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F3EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF16856B),
                  ),
                ),
                title: Text(
                  workout['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${workout['category']} • '
                    '${workout['duration']} menit\n'
                    '${workout['description']}',
                  ),
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutDetailPage(
                        title: workout['title'] as String,
                        category: workout['category'] as String,

                        durationMinutes: workout['duration'] as int,

                        description: workout['description'] as String,
                        instructions: List<String>.from(
                          workout['instructions'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
