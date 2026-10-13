import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFDDF3E9),
            child: Icon(Icons.person, size: 55, color: Color(0xFF16856B)),
          ),
          const SizedBox(height: 14),
          const Text(
            'Pengguna Gerak.in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Akun demo',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 28),
          Card(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saran dan Kesan Mata Kuliah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Saran: Semoga pembelajaran Pemrograman Aplikasi '
                    'Mobile semakin banyak disertai praktik pembuatan '
                    'aplikasi secara bertahap.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Kesan: Mata kuliah ini membantu saya memahami '
                    'proses pengembangan aplikasi mobile menggunakan '
                    'Flutter dan Dart.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
