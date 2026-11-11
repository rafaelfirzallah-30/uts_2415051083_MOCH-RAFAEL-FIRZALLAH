import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/drink_log.dart';
import '../providers/drink_provider.dart';
import '../widgets/drink_item_tile.dart';
import '../widgets/state_handler_view.dart';
import 'drink_detail_screen.dart';
import 'add_drink_screen.dart';

class DrinkListScreen extends StatefulWidget {
  const DrinkListScreen({super.key});

  @override
  State<DrinkListScreen> createState() => _DrinkListScreenState();
}

class _DrinkListScreenState extends State<DrinkListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<bool?> _confirmDeleteDialog(BuildContext context, DrinkLog item) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 36),
        title: const Text('Hapus Catatan?'),
        content: Text('Hapus catatan ${item.beverageType} (${item.volumeMl} ml) dari database?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrinkProvider>();
    final filteredLogs = provider.filteredLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Minum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Database',
            onPressed: () => provider.loadLogsFromDatabase(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Catatan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDrinkScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari jenis minuman atau catatan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (val) {
                provider.setSearchQuery(val);
              },
            ),
          ),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: ['Semua', ...AppConstants.beverageCategories].map((cat) {
                final isSelected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      provider.setCategoryFilter(cat);
                    },
                    selectedColor: AppTheme.accentLight,
                    checkmarkColor: AppTheme.primaryBlue,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 12),

          // Reusable State Handler View (Loading, Error, Empty, Data)
          Expanded(
            child: StateHandlerView(
              isLoading: provider.isLoading,
              loadingMessage: 'Memuat riwayat minum dari database...',
              errorMessage: provider.errorMessage,
              onRetry: () => provider.loadLogsFromDatabase(),
              isEmpty: filteredLogs.isEmpty,
              emptyTitle: 'Tidak Ada Riwayat',
              emptyMessage: provider.selectedCategory != 'Semua' || _searchController.text.isNotEmpty
                  ? 'Tidak ditemukan catatan yang cocok dengan filter atau kata kunci pencarian.'
                  : 'Belum ada catatan konsumsi air minum. Mulai catat hidrasi harian Anda sekarang!',
              emptyActionLabel: 'Tambah Catatan Minum',
              onEmptyAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDrinkScreen()),
                );
              },
              child: RefreshIndicator(
                onRefresh: () => provider.loadLogsFromDatabase(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final item = filteredLogs[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Hapus',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.delete_sweep_rounded, color: Colors.white),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await _confirmDeleteDialog(context, item);
                      },
                      onDismissed: (direction) async {
                        final success = await provider.deleteDrinkLogInDatabase(item.id);
                        if (context.mounted && success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Catatan ${item.beverageType} (${item.volumeMl} ml) berhasil dihapus.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: DrinkItemTile(
                        beverageType: item.beverageType,
                        volumeMl: item.volumeMl,
                        time: item.formattedTime,
                        note: item.note,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrinkDetailScreen(drinkLog: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
