import 'package:flutter/material.dart';
import 'package:habitbot/core/utils/responsive_layout.dart';
import 'package:habitbot/features/profile/presentation/pages/telegram_connect_page_mobile.dart';
import 'package:habitbot/features/profile/presentation/pages/telegram_connect_page_web.dart';

class TelegramConnectPage extends StatelessWidget {
  const TelegramConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: TelegramConnectPageMobile(),
      desktopBody: TelegramConnectPageWeb(),
    );
  }
}
