import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../models/drink_log.dart';
import '../repositories/drink_repository.dart';

class DrinkProvider extends ChangeNotifier {
  final DrinkRepository _repository;

  // 1. State: loading, data, error
  bool _isLoading = false;
  String? _errorMessage;
  List<DrinkLog> _logs = [];

  // 2. Shared State: Target Harian, Filter Kategori, & Query Pencarian
  int _dailyTargetMl = AppConstants.defaultDailyTargetMl;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  DrinkProvider({DrinkRepository? repository})
      : _repository = repository ?? DrinkRepository() {
    loadLogsFromDatabase();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DrinkLog> get logs => List.unmodifiable(_logs);
  int get dailyTargetMl => _dailyTargetMl;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // READ: Mengambil data riwayat dari Database melalui Repository
  Future<void> loadLogsFromDatabase() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.fetchLogs();
      _logs = data;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat data dari database: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
