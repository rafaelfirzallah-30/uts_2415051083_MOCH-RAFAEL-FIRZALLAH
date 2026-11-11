import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/drink_log.dart';
import '../providers/drink_provider.dart';
import '../widgets/hydration_summary_card.dart';
import '../widgets/quick_drink_button.dart';
import '../widgets/drink_item_tile.dart';
import 'add_drink_screen.dart';
import 'drink_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToList;

  const HomeScreen({super.key, this.onNavigateToList});

  void _openDetail(BuildContext context, DrinkLog item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrinkDetailScreen(drinkLog: item),
      ),
    );
  }

  void _openAddDrink(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDrinkScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkProvider>(
      builder: (context, provider, child) {
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
              return isWide
                  ? _buildWideLayout(context, provider)
                  : _buildCompactLayout(context, provider);
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openAddDrink(context),
            backgroundColor: AppTheme.primaryBlue,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Catat Minum',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  // 1. COMPACT LAYOUT (< 600px)
  Widget _buildCompactLayout(BuildContext context, DrinkProvider provider) {
    final recentLogs = provider.logs.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HydrationSummaryCard(
            currentIntakeMl: provider.todayTotalIntakeMl,
            targetMl: provider.dailyTargetMl,
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
                      onTap: () {
                        provider.quickAddWater(volume);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Berhasil menambah $volume ml air!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildHistoryHeader(),
          const SizedBox(height: 8),
          recentLogs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Belum ada catatan minum hari ini',
                      style: TextStyle(color: AppTheme.lightText),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentLogs.length,
                  itemBuilder: (context, index) {
                    final log = recentLogs[index];
                    return DrinkItemTile(
                      beverageType: log.beverageType,
                      volumeMl: log.volumeMl,
                      time: log.formattedTime,
                      note: log.note,
                      onTap: () => _openDetail(context, log),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // 2. WIDE / EXPANDED LAYOUT (>= 600px)
  Widget _buildWideLayout(BuildContext context, DrinkProvider provider) {
    final recentLogs = provider.logs.take(6).toList();

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
                  currentIntakeMl: provider.todayTotalIntakeMl,
                  targetMl: provider.dailyTargetMl,
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
                        onTap: () {
                          provider.quickAddWater(volume);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil menambah $volume ml air!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
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
                recentLogs.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Belum ada catatan minum hari ini',
                            style: TextStyle(color: AppTheme.lightText),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentLogs.length,
                        itemBuilder: (context, index) {
                          final log = recentLogs[index];
                          return DrinkItemTile(
                            beverageType: log.beverageType,
                            volumeMl: log.volumeMl,
                            time: log.formattedTime,
                            note: log.note,
                            onTap: () => _openDetail(context, log),
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
          onPressed: onNavigateToList,
          child: const Text('Lihat Semua'),
        ),
      ],
    );
  }
}
