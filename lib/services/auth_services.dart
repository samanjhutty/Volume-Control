import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:volume_control/model/util/color_resources.dart';
import '../model/util/string_resources.dart';

class AuthServices extends GetxService {
  RxBool is24hrFormat = false.obs;
  final box = GetStorage(StringRes.boxName);
  late MyTheme _theme;
  MyTheme get theme => _theme;

  @override
  onInit() {
    is24hrFormat.value = is24hr();
    _theme = getTheme();
    super.onInit();
  }

  MyTheme getTheme() {
    String? title = box.read(StringRes.appTheme);
    return MyTheme.values.firstWhere(
      (element) => element.title == title,
      orElse: () => MyTheme.deepPurple,
    );
  }

  void saveTheme(MyTheme theme) async {
    await box.write(StringRes.appTheme, theme.title);
  }

  bool is24hr() {
    if (box.hasData(StringRes.is24hr)) {
      return box.read(StringRes.is24hr);
    }
    return false;
  }

  Future<AuthServices> init() async {
    return this;
  }
}
