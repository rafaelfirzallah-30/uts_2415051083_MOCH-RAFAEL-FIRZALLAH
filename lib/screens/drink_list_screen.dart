import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/drink_log.dart';
import '../widgets/drink_item_tile.dart';
import 'drink_detail_screen.dart';
import 'add_drink_screen.dart';

class DrinkListScreen extends StatefulWidget {
  const DrinkListScreen({super.key});

  @override
  State<DrinkListScreen> createState() => _DrinkListScreenState();
}

class _DrinkListScreenState extends State<DrinkListScreen> {
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final List<DrinkLog> _allLogs = [
    DrinkLog(
      id: '1',
      beverageType: 'Air Mineral',
      volumeMl: 250,
      loggedAt: DateTime.now().subtract(const Duration(hours: 6)),
      note: 'Gelas pertama bangun tidur',
    ),
    DrinkLog(
      id: '2',
      beverageType: 'Teh',
      volumeMl: 200,
      loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      note: 'Teh hijau hangat',
    ),
    DrinkLog(
      id: '3',
      beverageType: 'Air Mineral',
      volumeMl: 300,
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
      note: 'Setelah makan siang',
    ),
    DrinkLog(
      id: '4',
      beverageType: 'Kopi',
      volumeMl: 150,
      loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      note: 'Kopi hitam tanpa gula',
    ),
    DrinkLog(
      id: '5',
      beverageType: 'Jus Buah',
      volumeMl: 250,
      loggedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      note: 'Jus jeruk segar',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _allLogs.where((log) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          log.beverageType.toLowerCase() == _selectedCategory.toLowerCase();
      final query = _searchController.text.toLowerCase();
      final matchesSearch = query.isEmpty ||
          log.beverageType.toLowerCase().contains(query) ||
          log.note.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

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
                          setState(() => _searchController.clear());
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: ['Semua', ...AppConstants.beverageCategories].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
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
