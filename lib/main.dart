import 'package:flutter/material.dart';
import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HydroTrackApp());
}

class HydroTrackApp extends StatelessWidget {
  const HydroTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
