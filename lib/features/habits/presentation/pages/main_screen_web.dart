import 'package:flutter/material.dart';
import 'package:habitbot/features/analytics/pages/analytics_page.dart';
import 'package:habitbot/features/habits/presentation/pages/create_habit_page.dart';
import 'package:habitbot/features/habits/presentation/pages/dashboard_page.dart';
import 'package:habitbot/features/profile/presentation/pages/profile_page.dart';

class MainScreenWeb extends StatefulWidget {
  const MainScreenWeb({super.key});

  @override
  State<MainScreenWeb> createState() => _MainScreenWebState();
}

class _MainScreenWebState extends State<MainScreenWeb> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    AnalyticsPage(),
    ProfilePage(),
  ];

  void _onFabPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateHabitPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            labelType: NavigationRailLabelType.all,
            backgroundColor: theme.scaffoldBackgroundColor,
            selectedIconTheme: IconThemeData(color: theme.primaryColor),
            selectedLabelTextStyle: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            unselectedIconTheme: IconThemeData(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
            unselectedLabelTextStyle: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontWeight: FontWeight.w500,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: FloatingActionButton(
                onPressed: _onFabPressed,
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                child: const Icon(Icons.add_rounded),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded),
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: Text('Profile'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1, color: theme.colorScheme.onSurface.withAlpha(20)),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
