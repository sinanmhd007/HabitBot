import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  final SharedPreferences sharedPreferences;
  static const _themeKey = 'theme_mode';

  ThemeBloc({required this.sharedPreferences}) : super(_getInitialTheme(sharedPreferences)) {
    on<ThemeChangedEvent>(_onThemeChanged);
  }

  static ThemeMode _getInitialTheme(SharedPreferences prefs) {
    final themeString = prefs.getString(_themeKey);
    if (themeString == 'light') return ThemeMode.light;
    if (themeString == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> _onThemeChanged(ThemeChangedEvent event, Emitter<ThemeMode> emit) async {
    String modeString = 'system';
    if (event.themeMode == ThemeMode.light) modeString = 'light';
    if (event.themeMode == ThemeMode.dark) modeString = 'dark';
    
    await sharedPreferences.setString(_themeKey, modeString);
    emit(event.themeMode);
  }
}
