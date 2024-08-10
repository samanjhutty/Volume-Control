import 'dart:convert';
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

extension Extras on AddScenarioController {}
