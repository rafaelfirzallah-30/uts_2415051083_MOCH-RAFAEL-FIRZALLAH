import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/drink_log.dart';

/// Service untuk menangani komunikasi dengan Database Backend (Supabase / Remote DB).
/// Kredensial URL & Anon Key dimuat secara aman dari file .env (tidak di-commit ke Git).
class DatabaseService {
  static const String tableName = 'drink_logs';
  static bool _isInitialized = false;

  // In-memory local cache sebagai fallback saat offline
  final List<DrinkLog> _localDb = [
    DrinkLog(
      id: 'db-1',
      beverageType: 'Air Mineral',
      volumeMl: 250,
      loggedAt: DateTime.now().subtract(const Duration(hours: 5)),
      note: 'Minum air setelah bangun pagi',
    ),
    DrinkLog(
      id: 'db-2',
      beverageType: 'Teh',
      volumeMl: 200,
      loggedAt: DateTime.now().subtract(const Duration(hours: 3)),
      note: 'Teh chamomile hangat',
    ),
    DrinkLog(
      id: 'db-3',
      beverageType: 'Air Mineral',
      volumeMl: 330,
      loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      note: 'Botol air saat belajar',
    ),
  ];

  // Inisialisasi Supabase menggunakan kredensial dari .env
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (_) {}
    }

    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (url.isNotEmpty &&
        anonKey.isNotEmpty &&
        !url.contains('your-project-id')) {
      try {
        await Supabase.initialize(
          url: url,
          publishableKey: anonKey,
        );
        _isInitialized = true;
      } catch (_) {
        _isInitialized = false;
      }
    }
  }

  bool get _isSupabaseConnected => _isInitialized;

  // READ (Ambil riwayat catatan minum dari Supabase / fallback)
  Future<List<DrinkLog>> fetchDrinkLogs() async {
    if (_isSupabaseConnected) {
      try {
        final response = await Supabase.instance.client
            .from(tableName)
            .select()
            .order('logged_at', ascending: false);

        final items = (response as List<dynamic>)
            .map((item) => DrinkLog.fromMap(item as Map<String, dynamic>))
            .toList();

        if (items.isNotEmpty) {
          _localDb.clear();
          _localDb.addAll(items);
          return items;
        }
      } catch (_) {
        // Fallback ke data lokal jika koneksi Supabase terkendala
      }
    }
    return List<DrinkLog>.from(_localDb);
  }

  // CREATE (Simpan catatan minum baru ke Supabase & cache)
  Future<DrinkLog> insertDrinkLog(DrinkLog log) async {
    if (_isSupabaseConnected) {
      try {
        await Supabase.instance.client.from(tableName).insert(log.toMap());
      } catch (_) {
        // Data tetap tercatat di local fallback
      }
    }
    _localDb.removeWhere((item) => item.id == log.id);
    _localDb.insert(0, log);
    return log;
  }

  // UPDATE (Perbarui catatan minum di Supabase & cache)
  Future<DrinkLog> updateDrinkLog(DrinkLog log) async {
    if (_isSupabaseConnected) {
      try {
        await Supabase.instance.client
            .from(tableName)
            .update(log.toMap())
            .eq('id', log.id);
      } catch (_) {}
    }
    final index = _localDb.indexWhere((item) => item.id == log.id);
    if (index != -1) {
      _localDb[index] = log;
    }
    return log;
  }

  // DELETE (Hapus catatan minum dari Supabase & cache)
  Future<void> deleteDrinkLog(String id) async {
    if (_isSupabaseConnected) {
      try {
        await Supabase.instance.client.from(tableName).delete().eq('id', id);
      } catch (_) {}
    }
    _localDb.removeWhere((item) => item.id == id);
  }
}
