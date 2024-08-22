import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:volume_control/model/models/current_system_settings.dart';
import 'package:volume_control/view_model/controllers/add_scenario_controller.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import '../model/models/scenario_model.dart';
import '../model/util/string_resources.dart';

extension BoxServices on DBcontroller {
  void saveTimeFormat({required bool? use24Hr}) {
    box.put(StringRes.is24hr, use24Hr ?? false);
  }

  /// save the list of model to json format in box.
  Future<void> saveList(List<ScenarioModel> list) async {
    await box.put(StringRes.scenarioList,
        list.map((e) => jsonEncode(e.toJson())).toList());
  }

  /// save current system volume to box.
  Future<void> saveSystemSettings(CurrentSystemSettings data,
      {required int index}) async {
    await box.put(StringRes.systemSettings(index), jsonEncode(data.toJson()));
  }

  /// load the box list to model list.
  List<ScenarioModel> getBoxList() {
    List list = box.get(StringRes.scenarioList, defaultValue: []);
    return List<ScenarioModel>.from(
        list.map((json) => ScenarioModel.fromJson(jsonDecode(json))));
  }
}

extension MyDateTime on DateTime {
  /// returns Datetime to String without time.
  String get format => _toString(this);

  String _toString(DateTime date) {
    String day = date.day > 10 ? '0${date.day}' : date.day.toString();
    String month = date.month > 10 ? '0${date.month}' : date.month.toString();
    int year = date.year;
    return '$day$month$year';
  }
}

extension MyTimeOfDay on TimeOfDay {
  /// returns TimeOfDay to String in 24hr format.
  String get formatTime24H => _formatTime24H(this);
  DateTime get toDateTime => _toDateTime(this);

  String _formatTime24H(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  DateTime _toDateTime(TimeOfDay time) {
    DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
}

extension MyString on String {
  /// converts TimeOfDay string to DateTime object
  TimeOfDay get toTimeOfDay => _timeofDayFromString(this);
  DateTime get toDateTime => _toDateTime(this);

  TimeOfDay _timeofDayFromString(String timeString) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);

    return timeOfDay;
  }

  DateTime _toDateTime(String timeString) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);

    return timeOfDay.toDateTime;
  }
}

extension Extras on AddScenarioController {}
