import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/tip_provider.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Edukasi Hidrasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Data API',
            onPressed: () {
              context.read<TipProvider>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<TipProvider>(
        builder: (context, provider, child) {
          // 1. Loading State
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat tips dari REST API...',
                    style: TextStyle(color: AppTheme.lightText, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          // 2. Error State
          if (provider.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      color: Colors.redAccent,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal Memuat Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Terjadi kesalahan jaringan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.lightText, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => provider.refresh(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Empty State
          if (provider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 56, color: AppTheme.lightText),
                  const SizedBox(height: 12),
                  const Text('Tidak ada tips tersedia saat ini.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Muat Ulang'),
                  ),
                ],
              ),
            );
          }

          // 4. Data State (UI with RefreshIndicator)
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.tips.length,
              itemBuilder: (context, index) {
                final tip = provider.tips[index];
                final isDaily = index == 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isDaily ? AppTheme.accentLight : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDaily ? AppTheme.primaryBlue : AppTheme.accentLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isDaily ? Icons.auto_awesome_rounded : Icons.tips_and_updates_rounded,
                            color: isDaily ? Colors.white : AppTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      tip.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isDaily ? AppTheme.primaryBlue : AppTheme.lightText,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tip.source,
                                      style: const TextStyle(fontSize: 10, color: AppTheme.darkText),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tip.advice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.darkText,
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
        },
      ),
    );
  }
}
