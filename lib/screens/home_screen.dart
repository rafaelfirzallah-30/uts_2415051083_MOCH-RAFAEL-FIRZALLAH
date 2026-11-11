import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../widgets/hydration_summary_card.dart';
import '../widgets/quick_drink_button.dart';
import '../widgets/drink_item_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Temporary state for initial UI demonstration
  int _currentIntake = 750;
  final int _targetIntake = AppConstants.defaultDailyTargetMl;

  final List<Map<String, dynamic>> _dummyLogs = [
    {
      'type': 'Air Mineral',
      'volume': 250,
      'time': '07:30',
      'note': 'Gelas pertama bangun tidur',
    },
    {
      'type': 'Teh',
      'volume': 200,
      'time': '10:00',
      'note': 'Teh hijau hangat',
    },
    {
      'type': 'Air Mineral',
      'volume': 300,
      'time': '12:45',
      'note': 'Setelah makan siang',
    },
  ];

  void _addQuickIntake(int volume) {
    setState(() {
      _currentIntake += volume;
      _dummyLogs.insert(0, {
        'type': 'Air Mineral',
        'volume': volume,
        'time': 'Baru saja',
        'note': 'Quick log',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppConstants.appSubtitle,
                  style: TextStyle(fontSize: 11, color: AppTheme.lightText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Pengingat Minum',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Reusable Hydration Summary Card
            HydrationSummaryCard(
              currentIntakeMl: _currentIntake,
              targetMl: _targetIntake,
            ),
            const SizedBox(height: 24),

            // 2. Quick Log Section
            const Text(
              'Catat Cepat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AppConstants.quickIntakePresets.map((volume) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: QuickDrinkButton(
                      volumeMl: volume,
                      onTap: () => _addQuickIntake(volume),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Today's Drink Logs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Minum Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of drink items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dummyLogs.length,
              itemBuilder: (context, index) {
                final log = _dummyLogs[index];
                return DrinkItemTile(
                  beverageType: log['type'] as String,
                  volumeMl: log['volume'] as int,
                  time: log['time'] as String,
                  note: log['note'] as String?,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Catat Minum',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
