import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/auth/presentation/pages/signup_page_mobile.dart';
import 'package:habitbot/features/auth/presentation/pages/signup_page_web.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: SignupPageMobile(),
      desktopBody: SignupPageWeb(),
    );
  }
}
