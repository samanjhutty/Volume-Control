import 'package:get/get.dart';
import 'package:volume_control/view_model/add_scenario_controller.dart';
import 'package:volume_control/view_model/dbcontroller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DBcontroller>(() => DBcontroller());
    Get.lazyPut<AddScenarioController>(() => AddScenarioController());
  }
}
