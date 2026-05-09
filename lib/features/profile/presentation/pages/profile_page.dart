import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/profile/presentation/pages/profile_page_mobile.dart';
import 'package:habitbot/features/profile/presentation/pages/profile_page_web.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: ProfilePageMobile(),
      desktopBody: ProfilePageWeb(),
    );
  }
}
