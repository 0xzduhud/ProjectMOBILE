import 'package:flutter/material.dart';

import '../services/database_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final int durationMinutes;
  final String description;
  final List<String> instructions;

  const WorkoutDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.description,
    required this.instructions,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final DatabaseService _databaseService = DatabaseService();

  bool _isSaving = false;

  Future<void> _completeWorkout() async {
    if (_isSaving) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Selesaikan latihan?'),
          content: Text(
            'Simpan ${widget.title} sebagai aktivitas '
            'yang telah selesai?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Belum'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Selesaikan'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);

    try {
      // Estimasi sederhana: sekitar 5 kkal per menit.
      // Ini bukan hasil pengukuran sensor.
      final estimatedCalories = widget.durationMinutes * 5;

      await _databaseService.saveWorkoutHistory(
        title: widget.title,
        durationMinutes: widget.durationMinutes,
        caloriesBurned: estimatedCalories,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Latihan berhasil disimpan ke aktivitas!'),
          backgroundColor: Color(0xFF16856B),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menyimpan aktivitas. Periksa koneksi '
            'dan status login kamu, lalu coba lagi.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16856B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      appBar: AppBar(
        title: const Text('Detail Latihan'),
        backgroundColor: const Color(0xFFF5F8F6),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F3EC),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.fitness_center, size: 70, color: green),
          ),
          const SizedBox(height: 22),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19332D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.category} • '
            '${widget.durationMinutes} menit',
            style: const TextStyle(color: green, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Panduan Latihan',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          ...widget.instructions.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFFE2F3EC),
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isSaving ? null : _completeWorkout,
            style: FilledButton.styleFrom(
              backgroundColor: green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_isSaving ? 'Menyimpan...' : 'Selesaikan Latihan'),
          ),
        ],
      ),
    );
  }
}
