import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_feedback.dart';
import '../core/app_theme.dart';
import '../providers/drink_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showTargetSliderDialog(BuildContext context, DrinkProvider provider) {
    double currentTarget = provider.dailyTargetMl.toDouble();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              icon: const Icon(Icons.water_drop_rounded, color: AppTheme.primaryBlue, size: 36),
              title: const Text('Atur Target Harian', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Geser slider untuk menentukan target kebutuhan cairan harian Anda:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppTheme.lightText),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${currentTarget.toInt()} ml',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: currentTarget,
                    min: 1000,
                    max: 4000,
                    divisions: 30, // kelipatan 100 ml
                    label: '${currentTarget.toInt()} ml',
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setDialogState(() {
                        currentTarget = val;
                      });
                    },
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setDailyTarget(currentTarget.toInt());
                    Navigator.pop(ctx);
                    AppFeedback.showSuccess(
                      context,
                      'Target harian berhasil diubah ke ${currentTarget.toInt()} ml!',
                    );
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
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
                    subtitle: const Text('Klik untuk mengubah dengan slider interaktif'),
                    trailing: Text(
                      '${drinkProvider.dailyTargetMl} ml',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                    onTap: () => _showTargetSliderDialog(context, drinkProvider),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.alarm_rounded, color: AppTheme.primaryBlue),
                    title: const Text('Interval Pengingat'),
                    trailing: const Text('Setiap 2 Jam', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      AppFeedback.showInfo(context, 'Interval pengingat diatur setiap 2 jam.');
                    },
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
