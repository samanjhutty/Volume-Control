import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class StringRes {
  /// app constants
  static const String appName = 'Volume Control';
  static const String timeOfDayFormat = 'Hms';
  static const String bgTaskName = 'sc-schedular';
  static String bgTaskStartID(String? id) => 'sc-start:$id';
  static String bgTaskEndID(String? id) => 'sc-end:$id';

  /// Hive constants
  static const String boxName = 'volume-conrtol';
  static const String scenarioList = 'scenarioList';
  static String systemSettings(int index) => 'system-settings:$index';
  static const String is24hr = '24hr-format';
  static const String appTheme = 'App-Theme';

  /// notification constants
  static const String channelId = 'sc-notify';
  static const String channelName = 'Routine ';
  static const String channelDesc =
      'Notificatons regarding volume control routines';

  /// volume mode constants
  static const String vol = 'Volume';
  static const String volMode = 'Mode';

  /// Time constants
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';

  /// days constants
  static const String repeat = 'Repeat';
  static const String everyday = 'Everyday';
  static const String dayNever = 'Never';

  /// error
  static const String errorSameTime = 'End time cannot be same as start time!';
  static const String errorSetTime = 'Set time first';

  static const String noScenarioText = 'No Scenario running';
  static const String createScenario = 'Create a new scenario';
  static const String sceName = 'Scenario Name';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String settings = 'Settings';
  static const String changeVol = 'Modify Volume Settings';
  static const String changeTheme = 'Change Theme';
  static const String changeTime = 'Change to 24Hr clock';
  static const String text24hr = 'Use 24hr format';
  static const String personlize = 'Personalization';

  static String toIcons(String icon) => 'assets/icons/$icon.png';
  static const List<String> dayList = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
}

void logPrint(String? message) {
  if (kDebugMode) {
    Get.log(message ?? 'null');
  }
}

void showToast(String? msg) {
  Fluttertoast.showToast(msg: msg ?? 'null');
}
