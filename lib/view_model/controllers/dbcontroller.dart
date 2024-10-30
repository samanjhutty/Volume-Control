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
import 'package:volume_control/services/extension_methods.dart';
import 'package:volume_control/services/notification_services.dart';
import '../../model/models/current_system_settings.dart';
import '../../model/util/string_resources.dart';

class DBcontroller extends GetxController with GetTickerProviderStateMixin {
  RxList<ScenarioModel> scenarioList = RxList();
  Box box = Hive.box(StringRes.boxName);

  late TabController timeFormatController;
  RxBool darkTheme = Get.isDarkMode.obs;
  List<Permission> permissions = [
    Permission.scheduleExactAlarm,
    Permission.notification,
    Permission.ignoreBatteryOptimizations,
    Permission.accessNotificationPolicy
  ];
  @override
  onInit() {
    scenarioList.value = getBoxList();
    // Future.delayed(const Duration(seconds: 1), () => checkPermissions());
    super.onInit();
  }

  /// checks required permissions.
  Future<bool> checkPermissions() async {
    for (var element in permissions) {
      if (!await element.isGranted) {
        return false;
      }
    }
    return true;
  }

  /// get string of selected days, dynamically
  String repeatDaysText(List days) {
    switch (days.length) {
      case 0:
        return StringRes.dayNever;
      case 7:
        return StringRes.everyday;
      default:
        return days.toString().replaceAll('[', '').replaceAll(']', '');
    }
  }
}

/// callback function to create background task.
Future<void> createScenario(
    {required int tag,
    required DateTime startTime,
    required DateTime endTime}) async {
  DateTime startAt = startTime.subtract(const Duration(minutes: 5));
  DateTime now = DateTime.now();
  if (startAt.isBefore(now) && endTime.isAfter(now)) {
    startAt = now.add(const Duration(seconds: 10));
  }
  logPrint(
      'AlarmManager cs:: ${tag + 1}, startAt: $startAt, startDate: $startTime, ranAt:${DateTime.now()}');
  AndroidAlarmManager.periodic(
    const Duration(days: 1),
    tag + 1,
    bgSchedular,
    startAt: startAt,
    exact: true,
    wakeup: true,
    allowWhileIdle: true,
    rescheduleOnReboot: true,
    params: {
      'index': tag,
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
    },
  );
}

@pragma('vm:entry-point')
Future<void> bgSchedular(int tag, Map<String, dynamic> params) async {
  /// in case tag is 0, will create same id for both tasks,
  /// i.e. startSchedule id: 0, endSchedule id: 00
  int id = int.parse('$tag$tag');

  // get data from function params.
  int index = params['index'];
  DateTime startTime = DateTime.parse(params['start_time']);
  DateTime endTime = DateTime.parse(params['end_time']);

  // init Hive to load and read box contents.
  await Hive.initFlutter();
  var box = await Hive.openBox(StringRes.boxName);

  // fetch scenario list.
  List scenarioList = box.get(StringRes.scenarioList);
  List<ScenarioModel>? modelList = List<ScenarioModel>.from(
      scenarioList.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  var scenarioModel = modelList.elementAt(index);
  // fetch volume settings.
  String? systemSettings = box.get(StringRes.systemSettings(index));

  // get current day
  int dayofWeek = DateTime.now().weekday;
  String today = StringRes.dayList[dayofWeek - 1];

  logPrint(
      'AlarmManager bg:: id: $id, tag: $tag, today: $today, startDate: ${startTime.toString()}, ranAt:${DateTime.now()}');
  if (scenarioModel.repeat?.contains(today) ?? false) {
    // schedule scenario
    AndroidAlarmManager.oneShotAt(startTime, id, startSchedule,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'scenario_model': jsonEncode(scenarioModel.toJson()),
        });
    int endId = int.parse('$id$tag');
    // end scenario
    AndroidAlarmManager.oneShotAt(endTime, endId, endSchedule,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'system_settings': systemSettings,
          // 'scenario_list': scenarioList,
          // 'box': box,
        });
  }
}

@pragma('vm:entry-point')
void startSchedule(int tag, Map<String, dynamic> json) {
  String modelJson = json['scenario_model'];
  ScenarioModel data = ScenarioModel.fromJson(jsonDecode(modelJson));
  if (data.changeVol) {
    FlutterVolumeController.setVolume(data.volume.toDouble());
  }
  RingerModeStatus status = RingerModeStatus.values.firstWhere(
      (element) => element.name == data.volumeMode,
      orElse: () => RingerModeStatus.normal);
  SoundMode.setSoundMode(status);

  NotificationServices.showNotification(
      id: tag,
      title: '${data.title ?? 'Scenario'} Running',
      body: 'you current routine will end at ${data.endTime}');
}

@pragma('vm:entry-point')
void endSchedule(int tag, Map<String, dynamic> json) {
  String settingsJson = json['system_settings'];
  // List scenarioList = json['scenario_list'];

  CurrentSystemSettings? data =
      CurrentSystemSettings.fromJson(jsonDecode(settingsJson));
  // List<ScenarioModel> modelList = List<ScenarioModel>.from(
  //     scenarioList.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  // var scenario = modelList.elementAt(tag);

  if (data.changeVol) {
    FlutterVolumeController.setVolume(data.volume.toDouble());
  }
  RingerModeStatus status = RingerModeStatus.values.firstWhere(
      (element) => element.name == data.volumeMode,
      orElse: () => RingerModeStatus.normal);
  SoundMode.setSoundMode(status);

  NotificationServices.showNotification(
      id: int.parse('$tag'),
      title: '${data.title ?? 'Scenario'} Ended',
      body: 'Your current routine has been ended sucessfully');

  // scenario.isON = false;
  // box.put(StringRes.scenarioList,
  //     modelList.map((e) => jsonEncode(e.toJson())).toList());
}
