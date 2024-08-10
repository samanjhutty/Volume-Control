import 'package:flutter/material.dart';

class ColorRes {
  // static const Color secondaryLight = Color(0xFFD6D6D6);
  static const Color secondary = Color(0xFFBDBDBD);
  static const Color onSucessContainer = Color(0xFF2B722E);
  static const Color sucessContainer = Color(0xFFD1EFCE);
  static const Color surface = Colors.white;
  static const Color surfaceInverse = Colors.black;
  static const Color textColor = Colors.black87;
  static const Color textColorVariant = Colors.black54;
  static const Color textColorLight = Color(0xFFC9C8C8);
  static const Color textColorDisabled = Colors.grey;
  static const Color textColorSeondary = Color(0xFF616161);
  static const Color onErrorContainer = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color tertiaryContainer = Color(0xFFF1E3BE);
  static const Color onTertiaryContainer = Color(0xFFC68F04);
}

class MyTheme {
  final String title;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  MyTheme({
    required this.title,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  });
}
