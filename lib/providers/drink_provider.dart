import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../models/drink_log.dart';

class DrinkProvider extends ChangeNotifier {
  // 1. Minimum State: loading, data, error
  bool _isLoading = false;
  String? _errorMessage;
  List<DrinkLog> _logs = [];

  // 2. Shared State: Target Harian, Filter Kategori, & Query Pencarian
  int _dailyTargetMl = AppConstants.defaultDailyTargetMl;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  DrinkProvider() {
    _loadInitialData();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DrinkLog> get logs => List.unmodifiable(_logs);
  int get dailyTargetMl => _dailyTargetMl;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Inisialisasi data awal (dummy state)
  void _loadInitialData() {
    _isLoading = true;
    _errorMessage = null;

    final now = DateTime.now();
    _logs = [
      DrinkLog(
        id: '1',
        beverageType: 'Air Mineral',
        volumeMl: 250,
        loggedAt: now.subtract(const Duration(hours: 4)),
        note: 'Gelas pertama bangun tidur',
      ),
      DrinkLog(
        id: '2',
        beverageType: 'Teh',
        volumeMl: 200,
        loggedAt: now.subtract(const Duration(hours: 2)),
        note: 'Teh hijau hangat',
      ),
      DrinkLog(
        id: '3',
        beverageType: 'Air Mineral',
        volumeMl: 300,
        loggedAt: now.subtract(const Duration(minutes: 45)),
        note: 'Setelah makan siang',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Perhitungan total konsumsi hari ini (Computed Shared State)
  int get todayTotalIntakeMl {
    final now = DateTime.now();
    return _logs
        .where((log) =>
            log.loggedAt.year == now.year &&
            log.loggedAt.month == now.month &&
            log.loggedAt.day == now.day)
        .fold(0, (sum, log) => sum + log.volumeMl);
  }

  // Progress persentase (0.0 sampai 1.0)
  double get todayProgress {
    if (_dailyTargetMl <= 0) return 0.0;
    return (todayTotalIntakeMl / _dailyTargetMl).clamp(0.0, 1.0);
  }

  int get todayProgressPercentage => (todayProgress * 100).toInt();

  int get remainingIntakeMl {
    final diff = _dailyTargetMl - todayTotalIntakeMl;
    return diff > 0 ? diff : 0;
  }

  // Log minum yang terfilter (Shared Filter State)
  List<DrinkLog> get filteredLogs {
    return _logs.where((log) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          log.beverageType.toLowerCase() == _selectedCategory.toLowerCase();
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          log.beverageType.toLowerCase().contains(query) ||
          log.note.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Aksi Filter & Pencarian
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDailyTarget(int newTarget) {
    if (newTarget > 0) {
      _dailyTargetMl = newTarget;
      notifyListeners();
    }
  }

  // Operasi State (Tambah, Edit, Hapus)
  void addDrinkLog(DrinkLog log) {
    _logs.insert(0, log);
    notifyListeners();
  }

  void quickAddWater(int volumeMl) {
    final newLog = DrinkLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      beverageType: 'Air Mineral',
      volumeMl: volumeMl,
      loggedAt: DateTime.now(),
      note: 'Catat cepat',
    );
    addDrinkLog(newLog);
  }

  void updateDrinkLog(DrinkLog updatedLog) {
    final index = _logs.indexWhere((log) => log.id == updatedLog.id);
    if (index != -1) {
      _logs[index] = updatedLog;
      notifyListeners();
    }
  }

  void deleteDrinkLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }
}
