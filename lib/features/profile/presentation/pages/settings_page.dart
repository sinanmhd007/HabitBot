import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/profile/presentation/pages/settings_page_mobile.dart';
import 'package:habitbot/features/profile/presentation/pages/settings_page_web.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: SettingsPageMobile(),
      desktopBody: SettingsPageWeb(),
    );
  }
}

