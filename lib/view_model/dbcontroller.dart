import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import 'package:volume_control/model/notification_services.dart';
import '../model/models/current_system_settings.dart';
import '../model/util/app_constants.dart';
import 'add_scenario_controller.dart';

class DBcontroller extends GetxController {
  RxList<ScenarioModel> scenarioList = <ScenarioModel>[].obs;
  Box box = Hive.box(AppConstants.boxName);
  RxBool is24hrFormat = false.obs;
  RxBool darkTheme = RxBool(Get.theme.brightness == Brightness.dark);
  List<Permission> permissions = [
    Permission.scheduleExactAlarm,
    Permission.notification,
    Permission.ignoreBatteryOptimizations,
    Permission.accessNotificationPolicy,
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

    return list.cast<ScenarioModel>();
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
    await box.put(AppConstants.scenarioList, list);
  }

  /// Converts TimeOfDay to DateTime
  DateTime dateTimeFromTimeOfDay(TimeOfDay time) {
    DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
}

@pragma('vm:entry-point')
Future<bool> bgSchedular(int tag, DateTime startTime) =>
    AndroidAlarmManager.periodic(
      const Duration(minutes: 1),
      tag,
      () {
        logPrint('task scheduled');
        bgTask(tag);
      },
      startAt: startTime,
      exact: true,
      wakeup: true,
    );

@pragma('vm:entry-point')
Future<void> bgTask(int tag) async {
  ScenarioModel? data =
      (box.get(AppConstants.scenarioList) as List<ScenarioModel>)[tag];

  logPrint('bgTask data: ${data.toJson()}');

  double? currentVolume = await FlutterVolumeController.getVolume();
  RingerModeStatus currentVolMode = await SoundMode.ringerModeStatus;
  String? volMode;
  switch (currentVolMode) {
    case RingerModeStatus.silent:
      volMode = AppConstants.volSilent;
      break;
    case RingerModeStatus.vibrate:
      volMode = AppConstants.volViberate;
      break;
    default:
      volMode = AppConstants.volNormal;
      break;
  }

  await box.put(AppConstants.systemSettings,
      CurrentSystemSettings(volume: currentVolume?.toInt(), volMode: volMode));

  logPrint(
      'bgTask currentSettings: ${CurrentSystemSettings(volume: currentVolume?.toInt(), volMode: volMode).toJson()}');

  NotificationServices.showNotification(
      id: tag,
      title: '${data.title ?? 'Scenario'} runnung',
      body: 'you current routine will end at ${data.endTime}',
      payload: '');
  switch (data.volumeMode) {
    case AppConstants.volSilent:
      {
        await FlutterVolumeController.setVolume(data.volume.toDouble());
        await SoundMode.setSoundMode(RingerModeStatus.silent);
      }
      break;
    case AppConstants.volViberate:
      {
        await FlutterVolumeController.setVolume(data.volume.toDouble());
        await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      }
      break;
    default:
      {
        await FlutterVolumeController.setVolume(data.volume.toDouble());
        await SoundMode.setSoundMode(RingerModeStatus.normal);
      }
  }
}
