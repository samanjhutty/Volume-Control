class ScenarioModel {
  final String? title;
  final String startTime;
  final String endTime;
  final List<String>? repeat;
  final bool changeVol;
  final String volumeMode;
  final double volume;
  bool isON;

  ScenarioModel(
      {required this.title,
      required this.startTime,
      required this.endTime,
      this.repeat,
      required this.changeVol,
      required this.volumeMode,
      this.volume = 0,
      this.isON = false});

  ScenarioModel copyWith({
    String? title,
    String? startTime,
    String? endTime,
    List<String>? repeat,
    bool? changeVol,
    String? volumeMode,
    double? volume,
    bool? isON,
  }) {
    return ScenarioModel(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeat: repeat ?? this.repeat,
      changeVol: changeVol ?? this.changeVol,
      volumeMode: volumeMode ?? this.volumeMode,
      volume: volume ?? this.volume,
      isON: isON ?? this.isON,
    );
  }

  factory ScenarioModel.fromJson(Map<String, dynamic> json) => ScenarioModel(
      title: json['title'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      repeat: (json['repeat'] as List).cast<String>(),
      changeVol: json['change_volume'],
      volumeMode: json['volume_mode'],
      volume: json['volume'],
      isON: json['is_on']);

  Map<String, dynamic> toJson() => {
        'title': title,
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
