import 'package:hive_flutter/hive_flutter.dart';
part 'scenario_model.g.dart';

@HiveType(typeId: 1)
class ScenarioModel {
  ScenarioModel(
      {required this.startTime,
      required this.endTime,
      required this.repeat,
      required this.title,
      required this.volumeMode,
      required this.volume,
      required this.isON});
  @HiveField(0)
  String startTime;
  @HiveField(1)
  String endTime;
  @HiveField(2)
  List<String> repeat;
  @HiveField(3)
  String title;
  @HiveField(4)
  String volumeMode;
  @HiveField(5)
  int volume;
  @HiveField(6)
  bool isON;

  Map<String, dynamic> toJson() => {
        'title': title,
        'start_time': startTime,
        'end_time': endTime,
        'repeat': repeat,
        'volume_mode': volumeMode,
        'volume': volume,
        'is_on': isON,
      };
}
