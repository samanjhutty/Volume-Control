import 'package:get/get.dart';

class AppConstants {
  /// app constants
  static const String appName = 'Volume Control';
  static const String timeOfDayFormat = 'Hms';
  static const String bgTaskName = 'sc-schedular';
  static String bgTaskID(String? id) => 'sc-schedular:$id';

  /// Hive constants
  static const String boxName = 'volume-conrtol';
  static const String scenarioList = 'scenarioList';

  /// volume mode constants
  static const String vol = 'Volume';
  static const String volMode = 'Mode';
  static const String volNormal = 'Normal';
  static const String volSilent = 'Silent';
  static const String volViberate = 'Viberate';

  /// Time constants
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';

  /// days constants
  static const String repeat = 'Repeat';
  static const String everyday = 'Everyday';
  static const String dayNever = 'Never';

  /// page specific constants
  static const String noScenarioText = 'No Scenario running';
  static const String createScenario = 'Create a Scenario';
  static const String sceName = 'Scenario Name';
  static const String save = 'Save';
  static const String cancel = 'Cancel';

  static String toIcons(String icon) => 'assets/icons/$icon.png';
}

void logPrint(String? message) {
  Get.log('GetX log: ${message ?? 'null'}');
}
