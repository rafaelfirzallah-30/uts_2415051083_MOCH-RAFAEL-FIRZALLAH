import '../models/hydration_tip.dart';
import '../services/api_service.dart';

class TipRepository {
  final ApiService _apiService;

  TipRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<HydrationTip> getRandomAdvice() async {
    return await _apiService.fetchRandomAdvice();
  }

  Future<List<HydrationTip>> getHydrationTips() async {
    return await _apiService.fetchHydrationArticles();
  }
}
