import 'package:flutter/material.dart';
import '../models/hydration_tip.dart';
import '../repositories/tip_repository.dart';

class TipProvider extends ChangeNotifier {
  final TipRepository _repository;

  // 1. Minimum State: Loading, Data, Error
  bool _isLoading = false;
  String? _errorMessage;
  List<HydrationTip> _tips = [];
  HydrationTip? _dailyAdvice;

  TipProvider({TipRepository? repository})
      : _repository = repository ?? TipRepository() {
    fetchTips();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<HydrationTip> get tips => List.unmodifiable(_tips);
  HydrationTip? get dailyAdvice => _dailyAdvice;

  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _errorMessage == null && _tips.isEmpty;

  // Mengambil data dari REST API melalui Repository
  Future<void> fetchTips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.getHydrationTips();
      _tips = results;
      if (results.isNotEmpty) {
        _dailyAdvice = results.first;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat tips hidrasi: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data secara manual
  Future<void> refresh() async {
    await fetchTips();
  }
}
