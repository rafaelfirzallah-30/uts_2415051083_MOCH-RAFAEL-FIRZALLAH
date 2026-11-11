import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../providers/drink_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditTargetDialog(BuildContext context, DrinkProvider provider) {
    final controller = TextEditingController(text: provider.dailyTargetMl.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Target Minum'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Target Harian (ml)',
            suffixText: 'ml',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTarget = int.tryParse(controller.text);
              if (newTarget != null && newTarget > 0) {
                provider.setDailyTarget(newTarget);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Target harian diubah menjadi $newTarget ml')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drinkProvider = context.watch<DrinkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Avatar Card
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppTheme.accentLight,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rafael Firzallah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Project UTS Pemrograman Mobile',
                    style: TextStyle(fontSize: 13, color: AppTheme.lightText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // UTS Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Mahasiswa',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Mata Kuliah', 'Pemrograman Mobile (UTS)'),
                    _buildInfoRow('Tema Project', 'Aplikasi Pengingat & Pencatat Minum'),
                    _buildInfoRow('Aplikasi', AppConstants.appName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings Card with Shared State
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.water_drop_outlined, color: AppTheme.primaryBlue),
                    title: const Text('Target Minum Harian'),
                    subtitle: const Text('Klik untuk mengubah target'),
                    trailing: Text(
                      '${drinkProvider.dailyTargetMl} ml',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                    onTap: () => _showEditTargetDialog(context, drinkProvider),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.alarm_rounded, color: AppTheme.primaryBlue),
                    title: const Text('Interval Pengingat'),
                    trailing: const Text('Setiap 2 Jam', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue),
                    title: const Text('Versi Aplikasi'),
                    trailing: const Text('v1.0.0'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.lightText, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
