import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/services/notification_services.dart';
import '../../model/models/current_system_settings.dart';
import '../../model/util/app_constants.dart';

class DBcontroller extends GetxController {
  RxList<ScenarioModel> scenarioList = <ScenarioModel>[].obs;
  Box box = Hive.box(AppConstants.boxName);
  RxBool is24hrFormat = false.obs;
  RxBool darkTheme = RxBool(Get.theme.brightness == Brightness.dark);
  List<Permission> permissions = [
    Permission.scheduleExactAlarm,
    Permission.notification,
    Permission.ignoreBatteryOptimizations,
    Permission.accessNotificationPolicy
  ];
  @override
  onInit() {
    scenarioList.value = _getBoxList();
    is24hrFormat.value = box.get(AppConstants.is24hr, defaultValue: false);

    Future.delayed(const Duration(seconds: 1), () => checkPermissions());
    super.onInit();
  }

  List<ScenarioModel> _getBoxList() {
    List list = [];
    list = box.get(AppConstants.scenarioList, defaultValue: []);

    return List<ScenarioModel>.from(
        list.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  }

  checkPermissions() async {
    for (var element in permissions) {
      if (!await element.isGranted) {
        return _showPermissionDialog(Get.context!);
      } else {
        logPrint('$permissions granted');
      }
    }
  }

  /// shows a dialog at start of app to ask for permissions.
  _showPermissionDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
            title: const Text('Permissions Required'),
            content: const Text(
                'In order for this application to work some permissions need to be granted'),
            actions: [
              TextButton(
                  onPressed: () {
                    navigator?.pop();
                    permissions.request();
                  },
                  child: const Text('Okay'))
            ],
          ));

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
    await box.put(AppConstants.scenarioList,
        list.map((e) => jsonEncode(e.toJson())).toList());
  }

  /// Converts TimeOfDay to DateTime
  DateTime dateTimeFromTimeOfDay(TimeOfDay time) {
    DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
}

Future<void> bgSchedular(int tag, DateTime startTime, DateTime endTime) async {
  /// in case tag is 0, will create same id for both tasks,
  /// i.e. startSchedule id: 0,endSchedule id: 00
  int id = tag + 1;

  await AndroidAlarmManager.oneShotAt(startTime, id, startSchedule,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {'index': tag});

  await AndroidAlarmManager.oneShotAt(
      endTime, int.parse('$id$tag'), endSchedule,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {'index': tag});
}

@pragma('vm:entry-point')
Future<void> startSchedule(int tag, Map<String, dynamic> map) async {
  int index = map['index'];

  await Hive.initFlutter();
  var box = await Hive.openBox(AppConstants.boxName);
  List list = box.get(AppConstants.scenarioList);
  ScenarioModel? data = List<ScenarioModel>.from(
          list.map((json) => ScenarioModel.fromJson(jsonDecode(json))))
      .elementAt(index);

  if (data.changeVol) {
    await FlutterVolumeController.setVolume(data.volume.toDouble());
  }

  switch (data.volumeMode) {
    case AppConstants.volSilent:
      await SoundMode.setSoundMode(RingerModeStatus.silent);
      break;
    case AppConstants.volViberate:
      await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      break;
    default:
      await SoundMode.setSoundMode(RingerModeStatus.normal);
  }

  NotificationServices.showNotification(
      id: tag,
      title: '${data.title ?? 'Scenario'} Running',
      body: 'you current routine will end at ${data.endTime}');
}

@pragma('vm:entry-point')
Future<void> endSchedule(int tag, Map<String, dynamic> map) async {
  await Hive.initFlutter();
  var box = await Hive.openBox(AppConstants.boxName);
  String? json = await box.get(AppConstants.systemSettings);
  CurrentSystemSettings? data =
      CurrentSystemSettings.fromJson(jsonDecode(json ?? ''));

  if (data.changeVol) {
    await FlutterVolumeController.setVolume(data.volume.toDouble());
  }
  switch (data.volumeMode) {
    case AppConstants.volSilent:
      await SoundMode.setSoundMode(RingerModeStatus.silent);
      break;
    case AppConstants.volViberate:
      await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      break;
    default:
      await SoundMode.setSoundMode(RingerModeStatus.normal);
  }
  NotificationServices.showNotification(
      id: int.parse('$tag'), title: '${data.title ?? 'Scenario'} ended');

  int index = map['index'];
  List list = box.get(AppConstants.scenarioList);
  List<ScenarioModel>? modelList = List<ScenarioModel>.from(
      list.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  modelList.elementAt(index).isON = false;
  await box.put(AppConstants.scenarioList,
      modelList.map((e) => jsonEncode(e.toJson())).toList());
}
