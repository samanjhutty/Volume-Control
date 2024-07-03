class ScenarioModel {
  ScenarioModel(
      {required this.title,
      required this.tag,
      required this.startTime,
      required this.endTime,
      this.repeat,
      required this.changeVol,
      required this.volumeMode,
      this.volume = 0,
      this.isON = false});

  final String? title;
  final int tag;
  final String startTime;
  final String endTime;
  final List<String>? repeat;
  final bool changeVol;
  final String volumeMode;
  final double volume;
  bool isON;

  factory ScenarioModel.fromJson(Map<String, dynamic> json) => ScenarioModel(
      title: json['title'],
      tag: json['tag'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      repeat: (json['repeat'] as List).cast<String>(),
      changeVol: json['change_volume'],
      volumeMode: json['volume_mode'],
      volume: json['volume'],
      isON: json['is_on']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'tag': tag,
        'start_time': startTime,
        'end_time': endTime,
        'repeat': repeat,
        'change_volume': changeVol,
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
