import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'edit_drink_screen.dart';

class DrinkDetailScreen extends StatelessWidget {
  final Map<String, dynamic> drinkData;

  const DrinkDetailScreen({
    super.key,
    required this.drinkData,
  });

  @override
  Widget build(BuildContext context) {
    final String type = drinkData['type'] as String? ?? 'Air Mineral';
    final int volume = drinkData['volume'] as int? ?? 250;
    final String time = drinkData['time'] as String? ?? '-';
    final String note = drinkData['note'] as String? ?? 'Tidak ada catatan';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan Minum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Data',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDrinkScreen(drinkData: drinkData),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Hapus Data',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: Text('Hapus catatan $type ($volume ml)?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Catatan $type berhasil dihapus')),
                        );
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryCyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$volume ml',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detail fields Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.access_time_rounded, 'Waktu Minum', time),
                    const Divider(height: 24),
                    _buildDetailRow(Icons.category_outlined, 'Jenis Minuman', type),
                    const Divider(height: 24),
                    _buildDetailRow(Icons.local_drink_outlined, 'Volume Cairan', '$volume ml'),
                    const Divider(height: 24),
                    _buildDetailRow(Icons.note_alt_outlined, 'Catatan Tambahan', note),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppTheme.lightText),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
