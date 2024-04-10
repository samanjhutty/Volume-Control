import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_control/model/scenario_model.dart';

import '../model/days_model.dart';

class DBcontroller extends GetxController {
  /// Returns the days where selected is true.
  List<String> daysRepeat() {
    List<String> list = [];
    for (var day in dayList) {
      list.addIf(day.selected == true, day.day);
    }
    print('list day repeat: $list');
    return list;
  }

  /// Returns the selected type of each day to List.
  List<bool> daysIsSelected() {
    List<bool> list = [];
    for (var day in dayList) {
      list.add(day.selected);
    }
    print('list day isSelected $list');
    return list;
  }

  ///Returns a DateTime picker Widget.
  Future myTimePicker({required context}) async {
    return await showTimePicker(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0));
  }

  /// Adds a new Scenario To scenarioList.
  addScenario(
      {required TimeOfDay startTime,
      required TimeOfDay endTime,
      required List<String> repeat,
      required String title,
      required String volumeMode,
      required int volume,
      bool isON = true}) {
    scenarioList.add(ScenarioModel(
        startTime: startTime,
        endTime: endTime,
        repeat: repeat,
        title: title,
        volumeMode: volumeMode,
        volume: volume,
        isON: isON));
    update();
    print('data added');
  }

  /// Updates an existing scenario to scenarioList.
  updateScenario(
      {required int index,
      required TimeOfDay startTime,
      required TimeOfDay endTime,
      required List<String> repeat,
      required String title,
      required String volumeMode,
      required int volume,
      bool isON = true}) {
    scenarioList.insert(
        index,
        ScenarioModel(
            startTime: startTime,
            endTime: endTime,
            repeat: repeat,
            title: title,
            volumeMode: volumeMode,
            volume: volume,
            isON: isON));
    update();
    print('data updated');
  }
}
