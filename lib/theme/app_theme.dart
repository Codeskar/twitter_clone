import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallette.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallette.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallette.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallette.blueColor,
    ),
  );
}
