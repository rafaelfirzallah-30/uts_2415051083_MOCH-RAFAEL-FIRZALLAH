import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'providers/drink_provider.dart';
import 'providers/tip_provider.dart';
import 'screens/main_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi konfigurasi database dari .env
  await DatabaseService.initialize();

  runApp(const HydroTrackApp());
}

class HydroTrackApp extends StatelessWidget {
  const HydroTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrinkProvider()),
        ChangeNotifierProvider(create: (_) => TipProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}
