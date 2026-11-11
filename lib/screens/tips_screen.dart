import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/tip_provider.dart';
import '../widgets/state_handler_view.dart';

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
          return StateHandlerView(
            isLoading: provider.isLoading,
            loadingMessage: 'Menghubungi REST API & memuat tips hidrasi...',
            errorMessage: provider.errorMessage,
            onRetry: () => provider.refresh(),
            isEmpty: provider.isEmpty,
            emptyTitle: 'Tips Tidak Ditemukan',
            emptyMessage: 'Belum ada tips hidrasi dari REST API saat ini.',
            emptyActionLabel: 'Muat Ulang',
            onEmptyAction: () => provider.refresh(),
            child: RefreshIndicator(
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
            ),
          );
        },
      ),
    );
  }
}
