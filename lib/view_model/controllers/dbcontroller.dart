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

  /// load the box list to model list.
  List<ScenarioModel> _getBoxList() {
    List list = [];
    list = box.get(AppConstants.scenarioList, defaultValue: []);

    return List<ScenarioModel>.from(
        list.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  }

  /// checks required permissions.
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

  /// get string of selected days, dynamically
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

  /// save the list of model to json format in box.
  Future<void> saveList(List<ScenarioModel> list) async {
    await box.put(AppConstants.scenarioList,
        list.map((e) => jsonEncode(e.toJson())).toList());
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
    startAt = now.add(const Duration(minutes: 1));
  }
  logPrint(
      'am:: createScenario:: tag: $tag, startAt: $startAt, ranAt:${DateTime.now()}');
  AndroidAlarmManager.periodic(
    const Duration(days: 1),
    tag,
    bgSchedular,
    startAt: startAt,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    params: {
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
    },
  );
}

@pragma('vm:entry-point')
Future<void> bgSchedular(int tag, Map<String, dynamic> params) async {
  /// in case tag is 0, will create same id for both tasks,
  /// i.e. startSchedule id: 0,endSchedule id: 00
  int id = int.parse('${tag + 1}${tag + 1}');

  // get data from function params.
  DateTime startTime = DateTime.parse(params['start_time']);
  DateTime endTime = DateTime.parse(params['end_time']);

  // init Hive to load and read box contents.
  await Hive.initFlutter();
  var box = await Hive.openBox(AppConstants.boxName);

  // fetch scenario list.
  List scenarioList = box.get(AppConstants.scenarioList);
  List<ScenarioModel>? modelList = List<ScenarioModel>.from(
      scenarioList.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  var scenarioModel = modelList.elementAt(tag);
  // fetch volume settings.
  String? systemSettings = box.get(AppConstants.systemSettings(tag));

  // get current day
  int dayofWeek = DateTime.now().weekday;
  String today = AppConstants.dayList[dayofWeek - 1];

  logPrint(
      'am:: bgSchedular:: id: $id, tag: $tag, today: $today, startDate: ${startTime.toString()}, ranAt:${DateTime.now()}');
  if (scenarioModel.repeat?.contains(today) ?? false) {
    // schedule scenario
    await AndroidAlarmManager.oneShotAt(startTime, id, startSchedule,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'scenario_model': jsonEncode(scenarioModel.toJson()),
        });
    int endId = int.parse('$id$tag');
    // end scenario
    await AndroidAlarmManager.oneShotAt(endTime, endId, endSchedule,
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
Future<void> startSchedule(int tag, Map<String, dynamic> json) async {
  String modelJson = json['scenario_model'];
  ScenarioModel data = ScenarioModel.fromJson(jsonDecode(modelJson));

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
Future<void> endSchedule(int tag, Map<String, dynamic> json) async {
  String settingsJson = json['system_settings'];
  // List scenarioList = json['scenario_list'];

  CurrentSystemSettings? data =
      CurrentSystemSettings.fromJson(jsonDecode(settingsJson));
  // List<ScenarioModel> modelList = List<ScenarioModel>.from(
  //     scenarioList.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  // var scenario = modelList.elementAt(tag);

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

  // scenario.isON = false;
  // await box.put(AppConstants.scenarioList,
  //     modelList.map((e) => jsonEncode(e.toJson())).toList());
}
