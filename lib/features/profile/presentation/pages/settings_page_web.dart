import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/core/theme/theme_bloc.dart';
import 'package:habitbot/core/theme/theme_event.dart';

class SettingsPageWeb extends StatelessWidget {
  const SettingsPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
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
            ],
          ),
        ),
      ),
    );
  }
}
