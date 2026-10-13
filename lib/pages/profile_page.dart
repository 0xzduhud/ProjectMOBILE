import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFDDF2E1),
              child: Icon(Icons.person, size: 55, color: Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Pengguna FitTrack',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'Kelola profil dan pengaturanmu',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 28),

          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Informasi Profil'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),

          const ListTile(
            leading: Icon(Icons.emoji_events_outlined),
            title: Text('Achievement'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),

          const ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('Saran dan Kesan Mata Kuliah'),
            subtitle: Text('Pemrograman Aplikasi Mobile'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur logout akan diaktifkan '
                    'setelah login dibuat.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
