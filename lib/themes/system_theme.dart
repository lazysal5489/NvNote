import 'package:flutter/material.dart';

import 'system_theme_colors.dart';

class SystemTheme {
  SystemTheme._();

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Scaffold
    scaffoldBackgroundColor: SystemColorTheme.dark0Hard,

    // Color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      // Primary
      primary: SystemColorTheme.brightYellow,
      onPrimary: SystemColorTheme.dark0Hard,

      // Secondary
      secondary: SystemColorTheme.brightBlue,
      onSecondary: SystemColorTheme.dark0Hard,

      // Tertiary
      tertiary: SystemColorTheme.brightPurple,
      onTertiary: SystemColorTheme.dark0Hard,

      // Error
      error: SystemColorTheme.brightRed,
      onError: SystemColorTheme.dark0Hard,

      // Main surface
      surface: SystemColorTheme.dark0Hard,
      onSurface: SystemColorTheme.light1,

      // Surface containers
      surfaceContainerLowest: SystemColorTheme.dark0Hard,
      surfaceContainerLow: SystemColorTheme.dark0,
      surfaceContainer: SystemColorTheme.dark1,
      surfaceContainerHigh: SystemColorTheme.dark2,
      surfaceContainerHighest: SystemColorTheme.dark3,

      // Borders
      outline: SystemColorTheme.gray,
      outlineVariant: SystemColorTheme.dark1,
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: SystemColorTheme.light1),
      displayMedium: TextStyle(color: SystemColorTheme.light1),
      displaySmall: TextStyle(color: SystemColorTheme.light1),
      headlineLarge: TextStyle(color: SystemColorTheme.light1),
      headlineMedium: TextStyle(color: SystemColorTheme.light1),
      headlineSmall: TextStyle(color: SystemColorTheme.light1),
      titleLarge: TextStyle(color: SystemColorTheme.light1),
      titleMedium: TextStyle(color: SystemColorTheme.light1),
      titleSmall: TextStyle(color: SystemColorTheme.light2),
      bodyLarge: TextStyle(color: SystemColorTheme.light1),
      bodyMedium: TextStyle(color: SystemColorTheme.light1),
      bodySmall: TextStyle(color: SystemColorTheme.light4),
      labelLarge: TextStyle(color: SystemColorTheme.light1),
      labelMedium: TextStyle(color: SystemColorTheme.light2),
      labelSmall: TextStyle(color: SystemColorTheme.light4),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: SystemColorTheme.dark0Soft,
      foregroundColor: SystemColorTheme.light1,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      toolbarHeight: 35,
      titleTextStyle: TextStyle(
        color: SystemColorTheme.light1,
        fontFamily: 'JetbrainMono',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: SystemColorTheme.divider,
      thickness: 1,
    ),

    // Input fields
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: SystemColorTheme.dark0Hard,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      hintStyle: TextStyle(color: SystemColorTheme.gray),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SystemColorTheme.brightYellow,
        foregroundColor: SystemColorTheme.dark0Hard,
      ),
    ),

    // Selection
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: SystemColorTheme.cursor,
      selectionColor: SystemColorTheme.selectionBackground,
      selectionHandleColor: SystemColorTheme.cursor,
    ),
  );
}
