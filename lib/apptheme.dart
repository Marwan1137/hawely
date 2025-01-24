import 'package:flutter/material.dart';

class Apptheme {
  static const Color darkred = Color(0xFF990003);
  static const Color blue = Color(0xFF007AFF);
  static Color blackwithblue = Colors.black.withBlue(28);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static Color? bluecustom = Colors.blue[50];
  static Color? greycustom600 = Colors.grey[600];
  static Color? greycustom300 = Colors.grey[300];

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Apptheme.white,
  );
}
