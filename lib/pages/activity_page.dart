import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedActivity = 'Jalan kaki';

  final List<String> activities = [
    'Jalan kaki',
    'Lari',
    'Bersepeda',
    'Workout',
    'Push up',
  ];

  final TextEditingController durationController = TextEditingController();

  @override
  void dispose() {
    durationController.dispose();
    super.dispose();
  }

  void saveActivity() {
    final duration = int.tryParse(durationController.text);

    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan durasi yang valid.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$selectedActivity selama $duration menit berhasil dicatat '
          'untuk contoh tampilan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas Olahraga')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Catat Olahraga',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Pilih jenis olahraga yang kamu lakukan.'),

          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: selectedActivity,
            decoration: const InputDecoration(
              labelText: 'Jenis olahraga',
              border: OutlineInputBorder(),
            ),
            items: activities.map((activity) {
              return DropdownMenuItem(value: activity, child: Text(activity));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedActivity = value);
              }
            },
          ),

          const SizedBox(height: 16),
          TextField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Durasi (menit)',
              hintText: 'Contoh: 30',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: saveActivity,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Catat Aktivitas'),
          ),

          const SizedBox(height: 16),
          const Text(
            'Catatan: data pada tahap ini belum disimpan ke database.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
