import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/drink_log.dart';
import '../widgets/hydration_summary_card.dart';
import '../widgets/quick_drink_button.dart';
import '../widgets/drink_item_tile.dart';
import 'add_drink_screen.dart';
import 'drink_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToList;

  const HomeScreen({super.key, this.onNavigateToList});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIntake = 750;
  final int _targetIntake = AppConstants.defaultDailyTargetMl;

  final List<DrinkLog> _dummyLogs = [
    DrinkLog(
      id: '1',
      beverageType: 'Air Mineral',
      volumeMl: 250,
      loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      note: 'Gelas pertama bangun tidur',
    ),
    DrinkLog(
      id: '2',
      beverageType: 'Teh',
      volumeMl: 200,
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
      note: 'Teh hijau hangat',
    ),
    DrinkLog(
      id: '3',
      beverageType: 'Air Mineral',
      volumeMl: 300,
      loggedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      note: 'Setelah makan siang',
    ),
  ];

  void _addQuickIntake(int volume) {
    setState(() {
      _currentIntake += volume;
      _dummyLogs.insert(
        0,
        DrinkLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          beverageType: 'Air Mineral',
          volumeMl: volume,
          loggedAt: DateTime.now(),
          note: 'Quick log',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil menambah $volume ml air!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openDetail(DrinkLog item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrinkDetailScreen(drinkLog: item),
      ),
    );
  }

  void _openAddDrink() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDrinkScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppConstants.appSubtitle,
                  style: TextStyle(fontSize: 10, color: AppTheme.lightText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(
                Responsive.isWide(context) ? 'Wide' : 'Compact',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
              visualDensity: VisualDensity.compact,
              backgroundColor: AppTheme.accentLight,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Pengingat Minum',
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= Responsive.breakpointWide;
          return isWide ? _buildWideLayout() : _buildCompactLayout();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDrink,
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Catat Minum',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 1. COMPACT LAYOUT (< 600px, e.g. Smartphone Portrait)
  Widget _buildCompactLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HydrationSummaryCard(
            currentIntakeMl: _currentIntake,
            targetMl: _targetIntake,
          ),
          const SizedBox(height: 20),
          _buildQuickLogHeader(),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.quickIntakePresets.map((volume) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 82,
                    child: QuickDrinkButton(
                      volumeMl: volume,
                      onTap: () => _addQuickIntake(volume),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildHistoryHeader(),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyLogs.length,
            itemBuilder: (context, index) {
              final log = _dummyLogs[index];
              return DrinkItemTile(
                beverageType: log.beverageType,
                volumeMl: log.volumeMl,
                time: log.formattedTime,
                note: log.note,
                onTap: () => _openDetail(log),
              );
            },
          ),
        ],
      ),
    );
  }

  // 2. WIDE / EXPANDED LAYOUT (>= 600px, Tablet & Landscape)
  Widget _buildWideLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HydrationSummaryCard(
                  currentIntakeMl: _currentIntake,
                  targetMl: _targetIntake,
                ),
                const SizedBox(height: 20),
                _buildQuickLogHeader(),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.quickIntakePresets.map((volume) {
                    return SizedBox(
                      width: 85,
                      child: QuickDrinkButton(
                        volumeMl: volume,
                        onTap: () => _addQuickIntake(volume),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Right Column
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHistoryHeader(),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dummyLogs.length,
                  itemBuilder: (context, index) {
                    final log = _dummyLogs[index];
                    return DrinkItemTile(
                      beverageType: log.beverageType,
                      volumeMl: log.volumeMl,
                      time: log.formattedTime,
                      note: log.note,
                      onTap: () => _openDetail(log),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLogHeader() {
    return const Text(
      'Catat Cepat',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppTheme.darkText,
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'Riwayat Minum Hari Ini',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: widget.onNavigateToList,
          child: const Text('Lihat Semua'),
        ),
      ],
    );
  }
}
