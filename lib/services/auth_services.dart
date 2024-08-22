import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volume_control/model/util/color_resources.dart';

import '../model/util/string_resources.dart';

class AuthServices extends GetxService {
  RxBool is24hrFormat = false.obs;
  Box box = Hive.box(StringRes.boxName);
  late MyTheme _theme;
  MyTheme get theme => _theme;

  @override
  onInit() {
    is24hrFormat.value = is24hr();
    _theme = getTheme();
    super.onInit();
  }

  MyTheme getTheme() {
    String? title = box.get(StringRes.appTheme);
    return MyTheme.values.firstWhere(
      (element) => element.title == title,
      orElse: () => MyTheme.deepPurple,
    );
  }

  void saveTheme(MyTheme theme) async {
    await box.put(StringRes.appTheme, theme.title);
  }

  bool is24hr() => box.get(StringRes.is24hr, defaultValue: false);

  Future<AuthServices> init() async {
    return this;
  }
}
