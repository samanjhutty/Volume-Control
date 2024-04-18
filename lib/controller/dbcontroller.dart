import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:volume_control/model/models/scenario_model.dart';
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

  /// returns Datetime to String without time.
  String dateTimetoString(DateTime date) {
    String day = date.day > 10 ? '0${date.day}' : date.day.toString();
    String month = date.month > 10 ? '0${date.month}' : date.month.toString();
    int year = date.year;
    return '$day$month$year';
  }
}
