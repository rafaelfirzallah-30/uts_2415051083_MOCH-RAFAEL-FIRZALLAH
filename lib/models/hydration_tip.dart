class HydrationTip {
  final int id;
  final String advice;
  final String category;
  final String source;

  const HydrationTip({
    required this.id,
    required this.advice,
    this.category = 'Hidrasi Sehat',
    this.source = 'Health Advice API',
  });

  // Factory constructor untuk konversi JSON dari REST API
  factory HydrationTip.fromJson(Map<String, dynamic> json) {
    // Menangani respons Advice Slip API standar: {"slip": {"id": 1, "advice": "..."}}
    // atau format custom: {"id": 1, "advice": "...", "category": "..."}
    if (json.containsKey('slip') && json['slip'] is Map<String, dynamic>) {
      final slip = json['slip'] as Map<String, dynamic>;
      return HydrationTip(
        id: slip['id'] as int? ?? 1,
        advice: slip['advice']?.toString() ?? 'Tetap cukupi kebutuhan air minum Anda hari ini.',
        category: 'Saran Kesehatan',
        source: 'Advice Slip API',
      );
    }

    return HydrationTip(
      id: json['id'] as int? ?? 1,
      advice: json['advice']?.toString() ??
          json['tip']?.toString() ??
          'Tetap jaga asupan air minimal 2 liter per hari.',
      category: json['category']?.toString() ?? 'Hidrasi Sehat',
      source: json['source']?.toString() ?? 'Public API',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advice': advice,
      'category': category,
      'source': source,
    };
  }
}
