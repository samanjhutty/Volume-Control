import 'package:get/get.dart';
import 'package:volume_control/controller/bindings.dart';
import 'package:volume_control/main.dart';
import 'package:volume_control/model/util/app_routes.dart';
import 'package:volume_control/view/add_scenario.dart';

class AppPages {
  static String get initial => AppRoutes.home;

  static final List<GetPage> pages = [
    GetPage(
        name: AppRoutes.addScenario,
        page: () => const AddScenario(),
        binding: InitBindings()),
    GetPage(
        name: AppRoutes.home,
        page: () => const MainPage(),
        binding: InitBindings()),
  ];
}
