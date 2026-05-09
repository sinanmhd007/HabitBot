import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/analytics/pages/analytics_page_mobile.dart';
import 'package:habitbot/features/analytics/pages/analytics_page_web.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: AnalyticsPageMobile(),
      desktopBody: AnalyticsPageWeb(),
    );
  }
}

