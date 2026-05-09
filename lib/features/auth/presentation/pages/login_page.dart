import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/auth/presentation/pages/login_page_mobile.dart';
import 'package:habitbot/features/auth/presentation/pages/login_page_web.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: LoginPageMobile(),
      desktopBody: LoginPageWeb(),
    );
  }
}

