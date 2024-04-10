import 'package:get/get.dart';
import 'package:volume_control/controller/dbcontroller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DBcontroller>(() => DBcontroller());
  }
}
