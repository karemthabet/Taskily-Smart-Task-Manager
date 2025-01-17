import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(0, 17, 3, 3),
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: GoogleFonts.poppinsTextTheme( 
      const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        titleMedium: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 21,
        ),
        titleSmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavigationBarColorLightMode,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: AppColors.primaryColor, size: 40),
      unselectedIconTheme:
          IconThemeData(color: AppColors.settingsNavBarLight, size: 40),
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorlightMode,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: AppColors.primaryColor,
      error: Colors.white,
      onError: Colors.black,
      surface: AppColors.scaffoldBackgroundColorlightMode,
      onSurface: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: GoogleFonts.poppinsTextTheme( 
      const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.scaffoldBackgroundColorDarkMode,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
        titleMedium: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 4),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavigationBarColorDarkMode,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: AppColors.primaryColor, size: 40),
      unselectedIconTheme:
          IconThemeData(color: AppColors.settingsNavBarDark, size: 40),
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorDarkMode,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: AppColors.bottomNavigationBarColorDarkMode,
      secondary: Colors.white,
      onSecondary: Color.fromARGB(255, 192, 246, 68),
      error: Colors.white,
      onError: Colors.white,
      surface: AppColors.scaffoldBackgroundColorDarkMode,
      onSurface: AppColors.primaryColor,
    ),
  );
}
