import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/habits/presentation/pages/dashboard_page_mobile.dart';
import 'package:habitbot/features/habits/presentation/pages/dashboard_page_web.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: DashboardPageMobile(),
      desktopBody: DashboardPageWeb(),
    );
  }
}

