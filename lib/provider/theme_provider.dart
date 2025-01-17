import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode appThemeMode = ThemeMode.light;

  changeAppThemeMode(ThemeMode themeMode) {
    appThemeMode = themeMode;
    notifyListeners();
  }
}
