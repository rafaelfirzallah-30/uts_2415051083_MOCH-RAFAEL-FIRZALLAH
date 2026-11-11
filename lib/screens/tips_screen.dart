import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<Map<String, String>> _tips = const [
    {
      'title': 'Minum Air Saat Bangun Tidur',
      'body': 'Segelas air hangat atau suhu ruang di pagi hari membantu mengaktifkan organ tubuh dan menggantikan cairan yang hilang saat tidur.',
      'icon': 'wb_sunny_rounded',
    },
    {
      'title': 'Cukupi 2 Liter Air Sehari',
      'body': 'Kebutuhan rata-rata orang dewasa adalah sekitar 2 liter atau 8 gelas per hari untuk menjaga konsentrasi dan stamina.',
      'icon': 'water_drop_rounded',
    },
    {
      'title': 'Jangan Tunggu Haus',
      'body': 'Haus adalah tanda bahwa tubuh sudah mulai dehidrasi. Minumlah secara berkala sepanjang hari.',
      'icon': 'timer_rounded',
    },
    {
      'title': 'Perhatikan Warna Urine',
      'body': 'Warna kuning jernih menandakan tubuh terhidrasi baik, sedangkan kuning pekat menunjukkan Anda perlu minum lebih banyak air.',
      'icon': 'health_and_safety_rounded',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Edukasi Hidrasi'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tips.length,
        itemBuilder: (context, index) {
          final tip = _tips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tips_and_updates_rounded,
                      color: AppTheme.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tip['body']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.lightText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
