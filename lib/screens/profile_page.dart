import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFE2F3EC),
            child: Icon(Icons.person, size: 54, color: Color(0xFF16856B)),
          ),
          const SizedBox(height: 18),
          Text(
            name?.isNotEmpty == true ? name! : 'Pengguna Gerak.in',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user?.email ?? 'Email tidak tersedia',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 32),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF16856B)),
              title: const Text('Tentang Gerak.in'),
              subtitle: const Text(
                'Aplikasi pemantauan aktivitas fisik '
                'dan rekomendasi latihan.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            child: const ListTile(
              leading: Icon(Icons.school_outlined, color: Color(0xFF16856B)),
              title: Text('Saran dan Kesan'),
              subtitle: Text('Pemrograman Aplikasi Mobile'),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                    'Apakah kamu yakin ingin keluar dari akun?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout != true || !context.mounted) return;

              try {
                await AuthService().logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout gagal. Coba lagi.')),
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
