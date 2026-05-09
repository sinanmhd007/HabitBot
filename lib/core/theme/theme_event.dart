import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ThemeChangedEvent extends ThemeEvent {
  final ThemeMode themeMode;
  ThemeChangedEvent(this.themeMode);
}
