// ignore_for_file: unused_element
import 'package:flutter/material.dart';

class ColorRes {
  static const Color secondaryLight = Color(0xFFD6D6D6);
  static const Color onSucessContainer = Color(0xFF2B722E);
  static const Color sucessContainer = Color(0xFFD1EFCE);
  static const Color onErrorContainer = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color tertiaryContainer = Color(0xFFF1E3BE);
  static const Color onTertiaryContainer = Color(0xFFC68F04);
}

enum MyTheme {
  deepPurple.light(
    title: 'Deep Purple',
    primary: Colors.deepPurple,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCFBAF4),
    onPrimaryContainer: Color(0xFF2C194E),
  ),
  blue.light(
    title: 'Blue Ocean',
    primary: Colors.blueAccent,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFBAC6F4),
    onPrimaryContainer: Color(0xFF192C4E),
  ),
  brown.dark(
    title: 'Dark Brown Oak',
    primary: Colors.brown,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4E2C19),
    onPrimaryContainer: Color(0xFFF4DABA),
  ),
  lightGreeen.light(
    title: 'Parrot Green',
    primary: Colors.lightGreen,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD1F4BA),
    onPrimaryContainer: Color(0xFF294E19),
  );

  final String title;
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color background;
  final Color surface;
  final Color textColor;
  final Color textColorLight;
  final Color disabled;

  const MyTheme.dark({
    required this.title,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  })  : brightness = Brightness.dark,
        background = const Color(0xFF212121),
        surface = const Color(0xFF303030),
        textColor = const Color(0xFFEEEEEE),
        textColorLight = const Color(0xFF757575),
        disabled = Colors.grey;

  const MyTheme.light({
    required this.title,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  })  : brightness = Brightness.light,
        background = const Color(0xFFFAFAFA),
        surface = Colors.white,
        textColor = Colors.black87,
        textColorLight = const Color(0xFFC9C8C8),
        disabled = Colors.grey;
}
