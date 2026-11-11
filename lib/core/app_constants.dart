class AppConstants {
  static const String appName = 'HydroTrack';
  static const String appSubtitle = 'Pengingat & Pencatat Minum Air';
  
  // Default target harian (ml)
  static const int defaultDailyTargetMl = 2000;
  
  // Kategori minuman
  static const List<String> beverageCategories = [
    'Air Mineral',
    'Teh',
    'Kopi',
    'Jus Buah',
    'Susu',
    'Infused Water',
    'Lainnya',
  ];
  
  // Ukuran gelas standar
  static const List<int> quickIntakePresets = [150, 250, 330, 500, 600];
}
