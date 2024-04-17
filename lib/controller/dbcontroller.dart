import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volume_control/model/models/scenario_model.dart';
import '../model/models/days_model.dart';
import '../model/util/app_constants.dart';

class DBcontroller extends GetxController {
  RxList<ScenarioModel> scenarioList = <ScenarioModel>[].obs;
  Box box = Hive.box(AppConstants.boxName);

  @override
  onInit() {
    scenarioList.value = _getBoxList();
    super.onInit();
  }

  List<ScenarioModel> _getBoxList() {
    List list = [];
    list = box.get(AppConstants.scenarioList, defaultValue: []);

    return list.cast<ScenarioModel>();
  }

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
  addScenario(BuildContext context,
      {required TimeOfDay startTime,
      required TimeOfDay endTime,
      required List<String> repeat,
      required String title,
      required String volumeMode,
      required int volume,
      bool isON = true}) {
    scenarioList.add(ScenarioModel(
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        repeat: repeat,
        title: title,
        volumeMode: volumeMode,
        volume: volume,
        isON: isON));

    /// write to storage
    box.put(AppConstants.scenarioList, scenarioList);
    print('data saved');
  }

  /// Updates an existing scenario to scenarioList.
  updateScenario(BuildContext context,
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
            startTime: startTime.format(context),
            endTime: endTime.format(context),
            repeat: repeat,
            title: title,
            volumeMode: volumeMode,
            volume: volume,
            isON: isON));

    /// update values in storage
    box.put(AppConstants.scenarioList, scenarioList);
    print('data updated');
  }
}
