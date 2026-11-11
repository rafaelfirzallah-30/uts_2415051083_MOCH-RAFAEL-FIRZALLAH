import '../models/drink_log.dart';
import '../services/database_service.dart';

class DrinkRepository {
  final DatabaseService _databaseService;

  DrinkRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  // Read: Mengambil riwayat catatan minum dari database
  Future<List<DrinkLog>> fetchLogs() async {
    return await _databaseService.fetchDrinkLogs();
  }

  // Create: Menyimpan catatan minum baru ke database
  Future<DrinkLog> addLog(DrinkLog log) async {
    return await _databaseService.insertDrinkLog(log);
  }

  // Update: Memperbarui data catatan minum di database
  Future<DrinkLog> updateLog(DrinkLog log) async {
    return await _databaseService.updateDrinkLog(log);
  }

  // Delete: Menghapus catatan minum dari database berdasarkan ID
  Future<void> deleteLog(String id) async {
    await _databaseService.deleteDrinkLog(id);
  }
}
