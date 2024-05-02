import 'package:hive_flutter/hive_flutter.dart';
part 'scenario_model.g.dart';

@HiveType(typeId: 1)
class ScenarioModel {
  ScenarioModel(
      {required this.title,
      required this.tag,
      required this.startTime,
      required this.endTime,
      required this.repeat,
      required this.volumeMode,
      required this.volume,
      required this.isON});

  @HiveField(0)
  String title;

  @HiveField(1)
  int tag;

  @HiveField(2)
  String startTime;

  @HiveField(3)
  String endTime;

  @HiveField(4)
  List<String> repeat;

  @HiveField(5)
  String volumeMode;

  @HiveField(6)
  int volume;

  @HiveField(7)
  bool isON;

  factory ScenarioModel.fromJson(Map<String, dynamic> json) => ScenarioModel(
      title: json['title'],
      tag: json['tag'],
      startTime: json['start_date'],
      endTime: json['end_date'],
      repeat: json['repeat'],
      volumeMode: json['volume_mode'],
      volume: json['volume'],
      isON: json['is_on']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'tag': tag,
        'start_time': startTime,
        'end_time': endTime,
        'repeat': repeat,
        'volume_mode': volumeMode,
        'volume': volume,
        'is_on': isON,
      };
}

class ScenarioDay {
  ScenarioDay({required this.day, required this.selected});
  String day;
  bool selected;

  factory ScenarioDay.fromJson(Map<String, dynamic> json) =>
      ScenarioDay(day: json['day'], selected: json['selected']);

  Map<String, dynamic> toJson() => {
        'day': day,
        'selected': selected,
      };
}
