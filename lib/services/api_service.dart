import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/hydration_tip.dart';

class ApiService {
  static const String _baseUrl = 'https://api.adviceslip.com/advice';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // GET API: Mengambil saran kesehatan & motivasi dari Advice Slip REST API
  Future<HydrationTip> fetchRandomAdvice() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        return HydrationTip.fromJson(data);
      } else {
        throw HttpException('Gagal mengambil data dari server (${response.statusCode})');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      // Return fallback advice jika terjadi kendala jaringan
      return const HydrationTip(
        id: 0,
        advice: 'Pastikan minum minimal 8 gelas air setiap hari untuk menjaga energi dan fokus.',
        category: 'Tips Hidrasi',
        source: 'Sistem Hidrasi Mandiri',
      );
    }
  }

  // GET API: Mengambil kumpulan tips edukasi hidrasi & pola hidup sehat
  Future<List<HydrationTip>> fetchHydrationArticles() async {
    try {
      // Mengambil saran harian dari REST API
      final mainTip = await fetchRandomAdvice();

      // Dikombinasikan dengan tips kesehatan komprehensif
      final List<HydrationTip> curatedTips = [
        mainTip,
        const HydrationTip(
          id: 101,
          advice: 'Minum segelas air putih hangat saat pertama kali bangun tidur membantu merangsang organ dalam dan metabolisme tubuh.',
          category: 'Pagi Hari',
          source: 'Panduan Kesehatan',
        ),
        const HydrationTip(
          id: 102,
          advice: 'Konsumsi air putih 30 menit sebelum makan dapat membantu melancarkan sistem pencernaan makanan.',
          category: 'Pola Makan',
          source: 'Panduan Kesehatan',
        ),
        const HydrationTip(
          id: 103,
          advice: 'Saat berolahraga atau berada di ruangan ber-AC, tingkatkan asupan cairan karena dehidrasi terjadi lebih cepat.',
          category: 'Aktivitas',
          source: 'Panduan Hidrasi',
        ),
        const HydrationTip(
          id: 104,
          advice: 'Perhatikan warna urine Anda. Jika berwarna kuning pekat, segera minum 1-2 gelas air.',
          category: 'Deteksi Dini',
          source: 'Panduan Hidrasi',
        ),
      ];

      return curatedTips;
    } catch (e) {
      rethrow;
    }
  }
}
