import 'package:flutter/material.dart';

class ScenarioModel {
  ScenarioModel(
      {required this.startTime,
      required this.endTime,
      required this.repeat,
      required this.title,
      required this.volumeMode,
      required this.volume,
      required this.isON});

  TimeOfDay startTime;
  TimeOfDay endTime;
  List<String> repeat;
  String title;
  String volumeMode;
  int volume;
  bool isON;
}

List<ScenarioModel> scenarioList = [];
