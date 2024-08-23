import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Color? color;
  final Widget child;
  final Widget? navBar;

  const BaseWidget({
    super.key,
    this.appBar,
    this.color,
    required this.child,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: color,
      bottomNavigationBar: navBar,
      body: SafeArea(child: child),
    );
  }
}
