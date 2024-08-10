import 'package:flutter/material.dart';

class Dimens {
  const Dimens();

  /// size of 0
  static const double zero = 0;

  /// size of 32
  static const double borderRadiusLarge = 32;

  /// size of 4
  static const double borderRadiusSmall = 4;

  /// size of 8
  static const double borderRadiusDefault = 8;

  /// size of 16
  static const double borderRadiusMedium = 16;

  /// size of 24
  static const double borderRadiusMediumExtra = 24;

  /// size of 12
  static const double fontSmall = 12;

  /// size of 14
  static const double fontMed = 14;

  /// size of 16
  static const double fontLarge = 16;

  /// size of 18
  static const double fontExtraLarge = 18;

  /// size of 20
  static const double fontExtraLargeDouble = 20;

  /// size of 32
  static const double fontSuperLarge = 32;

  /// size of 40
  static const double fontSuperSuperLarge = 40;

  /// size of 4
  static const double sizeExtraSmall = 4;

  /// size of 8
  static const double sizeSmall = 8;

  /// size of 16
  static const double sizeDefault = 16;

  /// size of 20
  static const double sizeMedium = 20;

  /// size of 24
  static const double sizeMediumLarge = 24;

  /// size of 32
  static const double sizeLarge = 32;

  /// size of 40
  static const double sizeExtraLarge = 40;

  /// size of 46
  static const double sizeExtraDoubleLarge = 46;
}

class MyColoredBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  const MyColoredBox({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: color ?? Colors.amber, child: child);
  }
}
