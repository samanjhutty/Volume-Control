import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volume_control/view_model/dbcontroller.dart';
import 'package:volume_control/model/util/app_constants.dart';
import 'package:volume_control/model/util/entension_methods.dart';
import '../model/models/scenario_model.dart';

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
  RxBool changeVolume = false.obs;

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
    days.value = List.generate(7, (index) => Text(dayList[index].day));
    daySelected.value = daysIsSelected();
    if (Get.arguments != null) {
      updateList = Get.arguments;
      _onEdit(updateList!);
    }
    _getCurrentVolume();

    super.onInit();
  }

  @override
  void onClose() {
    for (int i = 0; i < dayList.length; i++) {
      dayList[i].selected = false;
    }
    super.onClose();
  }

  _getCurrentVolume() async {
    double? vol = await FlutterVolumeController.getVolume();

    volume.value = (vol ?? 0) * 100;
  }

  /// load values from list item to edit page
  _onEdit(int index) {
    ScenarioModel data = dBcontroller.scenarioList[index];
    logPrint('model data: onEdit ${data.toJson()}');

    startTime.value = data.startTime.toTimeOfDay;
    endTime.value = data.endTime.toTimeOfDay;
    repeatDays.value = data.repeat ?? [];
    titleController.value.text = data.title ?? '';
    volumeMode.value = data.volumeMode;
    volume.value = (data.volume) / 100;

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

  /// Adds a new Scenario To scenarioList.
  addScenario() {
    int tag = updateList ?? dBcontroller.scenarioList.length;
    ScenarioModel data = ScenarioModel(
        title: titleController.value.text.isEmpty
            ? null
            : titleController.value.text,
        tag: tag,
        startTime: startTime.value.formatTime24H,
        endTime: endTime.value.formatTime24H,
        repeat: repeatDays,
        volumeMode: volumeMode.value,
        volume: (volume.value * 100).ceil(),
        isON: repeatDays.isEmpty ? false : true);

    if (updateList != null) {
      dBcontroller.scenarioList[updateList!] = data;
      logPrint('data updated.. ${data.toJson()}');
    } else {
      dBcontroller.scenarioList.add(data);
      logPrint('data saved..${data.toJson()}');
    }

    /// write to storage
    dBcontroller.saveList(dBcontroller.scenarioList);

    /// schedule task
    if (repeatDays.isNotEmpty) {
      bgSchedular(
          tag, Get.find<DBcontroller>().dateTimeFromTimeOfDay(startTime.value));
    }
  }
}
