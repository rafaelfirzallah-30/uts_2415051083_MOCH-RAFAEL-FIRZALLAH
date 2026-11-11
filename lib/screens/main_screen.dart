import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import 'home_screen.dart';
import 'drink_list_screen.dart';
import 'tips_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToList: () => _onTabSelected(1)),
      const DrinkListScreen(),
      const TipsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= Responsive.breakpointWide;
          if (isWide) {
            // Tablet/Desktop/Landscape: NavigationRail + Screen Content
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onTabSelected,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.water_drop, color: AppTheme.primaryBlue, size: 28),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon: Icon(Icons.list_alt),
                      label: Text('Riwayat'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.tips_and_updates_outlined),
                      selectedIcon: Icon(Icons.tips_and_updates),
                      label: Text('Tips'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: screens[_currentIndex]),
              ],
            );
          }

          // Compact/Mobile: Direct screen with Bottom NavigationBar
          return screens[_currentIndex];
        },
      ),
      bottomNavigationBar: Responsive.isWide(context)
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabSelected,
              indicatorColor: AppTheme.accentLight,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppTheme.primaryBlue),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt, color: AppTheme.primaryBlue),
                  label: 'Riwayat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.tips_and_updates_outlined),
                  selectedIcon: Icon(Icons.tips_and_updates, color: AppTheme.primaryBlue),
                  label: 'Tips',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: AppTheme.primaryBlue),
                  label: 'Profil',
                ),
              ],
            ),
    );
  }
}
