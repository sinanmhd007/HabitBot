import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/core/theme/theme_bloc.dart';
import 'package:habitbot/core/theme/theme_event.dart';
import 'package:habitbot/features/profile/presentation/pages/telegram_connect_page.dart' as habitbot_telegram;

class SettingsPageMobile extends StatelessWidget {
  const SettingsPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: BlocBuilder<ThemeBloc, ThemeMode>(
              builder: (context, themeMode) {
                return RadioGroup<ThemeMode>(
                  groupValue: themeMode,
                  onChanged: (mode) {
                    if (mode != null) context.read<ThemeBloc>().add(ThemeChangedEvent(mode));
                  },
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('System Default'),
                        value: ThemeMode.system,
                        activeColor: theme.primaryColor,
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        title: const Text('Light Mode'),
                        value: ThemeMode.light,
                        activeColor: theme.primaryColor,
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark Mode'),
                        value: ThemeMode.dark,
                        activeColor: theme.primaryColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Notifications & Accountability',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.telegram, color: Colors.blue),
                  title: const Text('Connect Telegram'),
                  subtitle: const Text('Receive smart reminders'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const habitbot_telegram.TelegramConnectPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
