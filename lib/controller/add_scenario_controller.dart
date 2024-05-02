import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/models/current_system_settings.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/entension_methods.dart';
import '../model/models/scenario_model.dart';
import '../model/util/dimens.dart';

Box box = Hive.box(AppConstants.boxName);

class AddScenarioController extends GetxController {
  DBcontroller dBcontroller = Get.find();

  Rx<TextEditingController> titleController =
      TextEditingController(text: '').obs;
  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 0, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 0, minute: 0).obs;
  RxList<bool> daySelected = <bool>[].obs;
  RxList<Widget> days = <Widget>[].obs;
  RxList<String> repeatDays = <String>[].obs;
  RxString volumeMode = AppConstants.volNormal.obs;
  RxDouble volume = RxDouble(0);
  int? updateList;

  RxList<ScenarioDay> dayList = [
    ScenarioDay(day: 'Mon', selected: false),
    ScenarioDay(day: 'Tue', selected: false),
    ScenarioDay(day: 'Wed', selected: false),
    ScenarioDay(day: 'Thu', selected: false),
    ScenarioDay(day: 'Fri', selected: false),
    ScenarioDay(day: 'Sat', selected: false),
    ScenarioDay(day: 'Sun', selected: false),
  ].obs;

  @override
  void onInit() {
    days.value = List.generate(
        Dimens.noOfDays.toInt(), (index) => Text(dayList[index].day));
    if (Get.arguments != null) {
      updateList = Get.arguments;
    }
    daySelected.value = daysIsSelected();
    super.onInit();
  }

  @override
  void onClose() {
    for (int i = 0; i < dayList.length; i++) {
      dayList[i].selected = false;
    }
    super.onClose();
  }

  /// Returns a DateTime picker Widget.
  Future<TimeOfDay?> myTimePicker({required context}) async {
    TimeOfDay? time = await showTimePicker(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: dBcontroller.is24hrFormat.value),
            child: child!),
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0));

    return time;
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

  /// Adds a new Scenario To scenarioList.
  addScenario() {
    int tag = dBcontroller.scenarioList.length + 1;
    print('tag $tag');
    ScenarioModel data = ScenarioModel(
        title: titleController.value.text,
        tag: tag,
        startTime: startTime.value.formatTime24H,
        endTime: endTime.value.formatTime24H,
        repeat: repeatDays,
        volumeMode: volumeMode.value,
        volume: volume.value.toInt(),
        isON: repeatDays.isEmpty ? false : true);

    if (updateList != null) {
      dBcontroller.scenarioList.insert(updateList!, data);
      print('data updated..');
    } else {
      dBcontroller.scenarioList.add(data);
      print('data saved..');
    }

    /// write to storage
    dBcontroller.saveList(dBcontroller.scenarioList);

    /// schedule task
    if (repeatDays.isNotEmpty) {
      dBcontroller.bgSchedular(
          tag, Get.find<DBcontroller>().dateTimeFromTimeOfDay(startTime.value));
    }
  }
}

@pragma('vm:entry-point')
Future<void> bgTask() async {
  AddScenarioController db = Get.find();
  await box.put(
      AppConstants.systemSettings,
      CurrentSystemSettings(
          volume: db.volume.value.toInt(), volMode: db.volumeMode.value));
  switch (db.volumeMode.value) {
    case AppConstants.volNormal:
      {
        await FlutterVolumeController.setVolume(db.volume.value);
        await SoundMode.setSoundMode(RingerModeStatus.normal);
      }
      break;
    case AppConstants.volSilent:
      {
        await FlutterVolumeController.setVolume(db.volume.value);
        await SoundMode.setSoundMode(RingerModeStatus.silent);
      }
      break;
    case AppConstants.volViberate:
      {
        await FlutterVolumeController.setVolume(db.volume.value);
        await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      }
      break;
  }
}
