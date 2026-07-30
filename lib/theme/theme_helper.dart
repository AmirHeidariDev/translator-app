import 'package:flutter/material.dart';

class ThemeDataHelper {
  //seedColor
  static const Color _seedColor = Color(0xFF1650db);

  //light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    canvasColor: Color(0xFFffffff),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _seedColor,
      //background
      surface: Color(0xFFf5f5f5),
      //card
      surfaceContainerLow: Color(0xFFffffff),
    ),
  );

  //dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    canvasColor: Color(0xFF373639),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _seedColor,
      //background
      surface: Color(0xFF1c1c1e),
      //card
      surfaceContainerLow: Color(0xFF373639),
    ),
  );
}
