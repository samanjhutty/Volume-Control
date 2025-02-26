import 'package:get/get.dart';
import 'package:volume_control/view/home_screen/home.dart';
import 'package:volume_control/view_model/bindings.dart';
import 'package:volume_control/view_model/routes/app_routes.dart';
import 'package:volume_control/view/add_scenario_screen/add_scenario.dart';
import '../../view/home_screen/settings.dart';

class AppPages {
  static String get initial => AppRoutes.home;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.addScenario,
      page: () => const AddScenario(),
      binding: InitBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: InitBindings(),
    ),
    GetPage(
        name: AppRoutes.settings,
        page: () => const Settings(),
        binding: InitBindings(),
        transition: Transition.rightToLeft),
  ];
}
