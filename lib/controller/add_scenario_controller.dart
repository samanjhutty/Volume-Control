import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:volume_control/controller/dbcontroller.dart';
import 'package:volume_control/model/models/current_system_settings.dart';
import 'package:volume_control/model/util/app_constants.dart';
import '../model/models/scenario_model.dart';
import '../model/util/dimens.dart';

Box box = Hive.box(AppConstants.boxName);

class AddScenarioController extends GetxController {
  DBcontroller dBcontroller = Get.find();

  Rx<TextEditingController> titleController =
      TextEditingController(text: '').obs;
  Rx<TimeOfDay> startTime = const TimeOfDay(hour: 0, minute: 0).obs;
  Rx<TimeOfDay> endTime = const TimeOfDay(hour: 0, minute: 0).obs;
  late RxList<bool> daySelected;
  RxList<Widget> days = <Widget>[].obs;
  RxList<String> repeatDays = <String>[].obs;
  RxString volumeMode = AppConstants.volNormal.obs;
  RxDouble volume = RxDouble(0);

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
  Future myTimePicker({required context}) async {
    return await showTimePicker(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0));
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
  addScenario(BuildContext context, {int? index}) {
    String tag = DateTime.now().toString();

    ScenarioModel data = ScenarioModel(
        title: titleController.value.text,
        tag: tag,
        startTime: startTime.value.format(context),
        endTime: endTime.value.format(context),
        repeat: repeatDays,
        volumeMode: volumeMode.value,
        volume: volume.value.toInt(),
        isON: repeatDays.isEmpty ? false : true);

    if (index != null) {
      dBcontroller.scenarioList.insert(index, data);
      print('data updated..');
    } else {
      dBcontroller.scenarioList.add(data);
      print('data saved..');
    }

    /// write to storage
    box.put(AppConstants.scenarioList, dBcontroller.scenarioList);
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
