import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/util/string_resources.dart';

class AuthServices extends GetxService {
  RxBool is24hrFormat = false.obs;
  Box box = Hive.box(StringRes.boxName);

  @override
  onInit() {
    is24hrFormat.value = is24hr();

    super.onInit();
  }

  bool is24hr() => box.get(StringRes.is24hr, defaultValue: false);

  Future<AuthServices> init() async {
    return this;
  }
}
