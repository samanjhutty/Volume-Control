import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/services/auth_services.dart';
import 'package:volume_control/services/extension_methods.dart';
import 'package:volume_control/view_model/controllers/dbcontroller.dart';
import 'package:volume_control/model/util/string_resources.dart';
import '../../model/models/current_system_settings.dart';
import '../../model/models/scenario_model.dart';

class AddScenarioController extends GetxController {
  DBcontroller db = Get.find();

  TextEditingController titleController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  RxList<bool> daySelected = <bool>[].obs;
  RxList<Widget> days = <Widget>[].obs;
  RxList<String> repeatDays = <String>[].obs;
  RxString volumeMode = ''.obs;
  RxDouble volume = RxDouble(0);
  int? updateList;
  RxBool changeVolume = false.obs;

  RxList<ScenarioDay> dayList = List.generate(
      StringRes.dayList.length,
      (index) => ScenarioDay(
            day: StringRes.dayList[index],
            selected: false,
          )).obs;

  @override
  void onInit() {
    days.value = List.generate(7, (index) => Text(dayList[index].day));
    daySelected.value = daysIsSelected();
    if (Get.arguments != null) {
      updateList = Get.arguments;
      _onEdit(updateList!);
    }
    FlutterVolumeController.addListener((value) {
      volume.value = value;
    });
    _getVolumeMode();
    super.onInit();
  }

  @override
  void onClose() {
    for (int i = 0; i < dayList.length; i++) {
      dayList[i].selected = false;
    }
    FlutterVolumeController.removeListener();
    super.onClose();
  }

  _getVolumeMode() async {
    var mode = await SoundMode.ringerModeStatus;
    volumeMode.value = mode.name;
  }

  /// load values from list item to edit page
  _onEdit(int index) {
    ScenarioModel data = db.scenarioList[index];
    startTime = data.startTime.toTimeOfDay;
    endTime = data.endTime.toTimeOfDay;
    repeatDays.value = data.repeat ?? [];
    titleController.text = data.title ?? '';
    volumeMode.value = data.volumeMode;
    volume.value = data.volume;

    _toggleButtons();
  }

  /// toggle the selected days on edit.
  _toggleButtons() {
    for (var rep in repeatDays) {
      int index = listOfDays().indexWhere((element) => element == rep);
      dayList.elementAt(index).selected = true;
    }
    daySelected.value = daysIsSelected();
  }

  /// Returns a DateTime picker Widget.
  Future<TimeOfDay?> myTimePicker({required context}) async {
    TimeOfDay? time = await showTimePicker(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat:
                    Get.find<AuthServices>().is24hrFormat.value),
            child: child!),
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0));

    return time;
  }

  void deleteScenario() async {
    db.scenarioList.removeAt(updateList!);
    Get.back();

    db.saveList(db.scenarioList);
    await AndroidAlarmManager.cancel(updateList! + 1);
  }

  /// Returns the days where selected is true.
  List<String> daysRepeat() {
    List<String> list = [];
    for (var day in dayList) {
      list.addIf(day.selected == true, day.day);
    }
    return list;
  }

  /// Returns the selected type of each day to List.
  List<bool> daysIsSelected() {
    List<bool> list = [];
    for (var day in dayList) {
      list.add(day.selected);
    }
    logPrint('list day isSelected $list');
    return list;
  }

  /// Returns the selected value of each day to List.
  List<String> listOfDays() {
    List<String> list = [];
    for (var day in dayList) {
      list.add(day.day);
    }
    logPrint('list day: $list');
    return list;
  }

  _saveCurrentSettings({required int index}) async {
    double? currentVolume = await FlutterVolumeController.getVolume();
    RingerModeStatus currentVolMode = await SoundMode.ringerModeStatus;
    var data = CurrentSystemSettings(
        volume: currentVolume ?? 1,
        changeVol: changeVolume.value,
        volumeMode: currentVolMode.name,
        title: titleController.text.isEmpty ? null : titleController.text);

    await db.saveSystemSettings(data, index: index);
  }

  /// Adds a new Scenario To scenarioList.
  addScenario() async {
    if (startTime == null || endTime == null) return;
    int tag = updateList ?? db.scenarioList.length;
    ScenarioModel data = ScenarioModel(
        title: titleController.text.isEmpty ? null : titleController.text,
        startTime: startTime!.formatTime24H,
        endTime: endTime!.formatTime24H,
        repeat: repeatDays,
        changeVol: changeVolume.value,
        volumeMode: volumeMode.value,
        volume: volume.value,
        isON: repeatDays.isEmpty ? false : true);

    if (updateList != null) {
      db.scenarioList[updateList!] = data;
    } else {
      db.scenarioList.add(data);
    }
    db.scenarioList.sort((a, b) => a.startTime.compareTo(b.startTime));

    /// write to storage
    await db.saveList(db.scenarioList);

    /// save current settings
    await _saveCurrentSettings(index: tag);

    /// schedule task
    if (repeatDays.isNotEmpty) {
      createScenario(
        tag: tag + 1,
        startTime: startTime!.toDateTime,
        endTime: endTime!.toDateTime,
      );
    }
  }
}
