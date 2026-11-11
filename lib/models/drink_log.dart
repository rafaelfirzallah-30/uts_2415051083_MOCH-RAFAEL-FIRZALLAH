import 'package:intl/intl.dart';

class DrinkLog {
  final String id;
  final String beverageType;
  final int volumeMl;
  final DateTime loggedAt;
  final String note;
  final String? studentId;

  const DrinkLog({
    required this.id,
    required this.beverageType,
    required this.volumeMl,
    required this.loggedAt,
    this.note = '',
    this.studentId,
  });

  // Format waktu untuk tampilan (misal: "07:30")
  String get formattedTime => DateFormat('HH:mm').format(loggedAt);

  // Format tanggal untuk tampilan (misal: "11 Nov 2026")
  String get formattedDate => DateFormat('dd MMM yyyy').format(loggedAt);

  // Konversi dari Map/JSON (Database / API) ke Dart Model
  factory DrinkLog.fromMap(Map<String, dynamic> map) {
    return DrinkLog(
      id: map['id']?.toString() ?? '',
      beverageType: map['beverage_type']?.toString() ?? 'Air Mineral',
      volumeMl: (map['volume_ml'] is num)
          ? (map['volume_ml'] as num).toInt()
          : int.tryParse(map['volume_ml']?.toString() ?? '250') ?? 250,
      loggedAt: map['logged_at'] != null
          ? DateTime.tryParse(map['logged_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      note: map['note']?.toString() ?? '',
      studentId: map['student_id']?.toString(),
    );
  }

  // Konversi dari Dart Model ke Map (untuk Supabase / Database insert / update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'beverage_type': beverageType,
      'volume_ml': volumeMl,
      'logged_at': loggedAt.toIso8601String(),
      'note': note,
      if (studentId != null) 'student_id': studentId,
    };
  }

  // CopyWith untuk memudahkan duplikasi dan perubahan field
  DrinkLog copyWith({
    String? id,
    String? beverageType,
    int? volumeMl,
    DateTime? loggedAt,
    String? note,
    String? studentId,
  }) {
    return DrinkLog(
      id: id ?? this.id,
      beverageType: beverageType ?? this.beverageType,
      volumeMl: volumeMl ?? this.volumeMl,
      loggedAt: loggedAt ?? this.loggedAt,
      note: note ?? this.note,
      studentId: studentId ?? this.studentId,
    );
  }
}
