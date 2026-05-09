import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/habits/presentation/pages/main_screen_mobile.dart';
import 'package:habitbot/features/habits/presentation/pages/main_screen_web.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MainScreenMobile(),
      desktopBody: MainScreenWeb(),
    );
  }
}
