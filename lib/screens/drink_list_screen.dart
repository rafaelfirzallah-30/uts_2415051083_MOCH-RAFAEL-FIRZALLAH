import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../providers/drink_provider.dart';
import '../widgets/drink_item_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrinkProvider>();
    final filteredLogs = provider.filteredLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Minum'),
        actions: [
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
                hintText: 'Cari catatan minum atau catatan...',
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

          // List Items
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada riwayat minum ditemukan',
                      style: TextStyle(color: AppTheme.lightText),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final item = filteredLogs[index];
                      return DrinkItemTile(
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
