import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/util/color_resources.dart';
import 'package:volume_control/services/auth_services.dart';

class _Themes extends InheritedWidget {
  final _ThemeServiceState data;
  const _Themes({required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant _Themes oldWidget) {
    bool result = data.primary != oldWidget.data.primary;
    print('[ThemeService] rebuilt: $result');
    return true;
  }
}

class ThemeServices extends StatefulWidget {
  final Widget child;
  const ThemeServices({super.key, required this.child});

  // ignore: library_private_types_in_public_api
  static _ThemeServiceState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_Themes>()?.data;
  }

  // ignore: library_private_types_in_public_api
  static _ThemeServiceState of(BuildContext context) {
    assert(maybeOf(context) != null);
    return maybeOf(context)!;
  }

  @override
  State<ThemeServices> createState() => _ThemeServiceState();
}

class _ThemeServiceState extends State<ThemeServices> {
  final _services = Get.find<AuthServices>();

  late Color _primary;
  late Color _onPrimary;
  late Color _primaryContainer;
  late Color _onPrimaryContainer;
  late Brightness _brightness;
  late Color _background;
  late Color _surface;
  late Color _textColor;
  late Color _textColorLight;
  late Color _disabled;

  Color get primary => _primary;
  Color get onPrimary => _onPrimary;
  Color get primaryContainer => _primaryContainer;
  Color get onPrimaryContainer => _onPrimaryContainer;
  Brightness get brightness => _brightness;
  Color get background => _background;
  Color get surface => _surface;
  Color get textColor => _textColor;
  Color get textColorLight => _textColorLight;
  Color get disabled => _disabled;

  @override
  void initState() {
    var theme = Get.find<AuthServices>().theme;
    _primary = theme.primary;
    _onPrimary = theme.onPrimary;
    _primaryContainer = theme.primaryContainer;
    _onPrimaryContainer = theme.onPrimaryContainer;
    _brightness = theme.brightness;
    _background = theme.background;
    _surface = theme.surface;
    _textColor = theme.textColor;
    _textColorLight = theme.textColorLight;
    _disabled = theme.disabled;

    super.initState();
  }

  void changeTheme(MyTheme theme) {
    _primary = theme.primary;
    _onPrimary = theme.onPrimary;
    _primaryContainer = theme.primaryContainer;
    _onPrimaryContainer = theme.onPrimaryContainer;
    _brightness = theme.brightness;
    _background = theme.background;
    _surface = theme.surface;
    _textColor = theme.textColor;
    _textColorLight = theme.textColorLight;
    _disabled = theme.disabled;
    setState(() {});
    _services.saveTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return _Themes(data: this, child: widget.child);
  }
}
