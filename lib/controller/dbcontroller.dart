import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import '../model/util/app_constants.dart';
import 'add_scenario_controller.dart';

class DBcontroller extends GetxController {
  RxList<ScenarioModel> scenarioList = <ScenarioModel>[].obs;
  Box box = Hive.box(AppConstants.boxName);
  RxBool is24hrFormat = false.obs;
  RxBool darkTheme = false.obs;

  @override
  onInit() {
    scenarioList.value = _getBoxList();
    is24hrFormat.value = box.get(AppConstants.is24hr, defaultValue: false);
    askPermissions(Get.context!);
    super.onInit();
  }

  List<ScenarioModel> _getBoxList() {
    List list = [];
    list = box.get(AppConstants.scenarioList, defaultValue: []);

    return list.cast<ScenarioModel>();
  }

  _showPermissionAlert(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Permission Access'),
            content: const Text(
                'In order to use this application some permision need to be granted'),
            actions: [
              TextButton(
                  onPressed: () async => await openAppSettings(),
                  child: const Text('go to settings'))
            ],
          ));

  Future<void> askPermissions(BuildContext context) async {
    await Permission.scheduleExactAlarm.request();
    Permission.scheduleExactAlarm
        .onDeniedCallback(() => _showPermissionAlert(context))
        .onGrantedCallback(() => logPrint('permission granted'))
        .onLimitedCallback(() => logPrint('permission limited'))
        .onPermanentlyDeniedCallback(() => _showPermissionAlert(context));
  }

  String repeatDaysText(List days) {
    switch (days.length) {
      case 0:
        return AppConstants.dayNever;
      case 7:
        return AppConstants.everyday;
      default:
        return days.toString().replaceAll('[', '').replaceAll(']', '');
    }
  }

  Future<void> saveList(List<ScenarioModel> list) async {
    await box.put(AppConstants.scenarioList, list);
  }

  /// Converts TimeOfDay to DateTime
  DateTime dateTimeFromTimeOfDay(TimeOfDay time) {
    DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Future<bool> bgSchedular(int tag, DateTime startTime) =>
      AndroidAlarmManager.periodic(const Duration(days: 1), tag, bgTask,
          startAt: startTime);
}
