class CurrentSystemSettings {
  const CurrentSystemSettings({
    this.title,
    required this.changeVol,
    required this.volume,
    required this.volumeMode,
  });

  final String? title;
  final bool changeVol;
  final double volume;
  final String volumeMode;

  factory CurrentSystemSettings.fromJson(Map<String, dynamic> json) =>
      CurrentSystemSettings(
        title: json['title'],
        changeVol: json['change_volume'],
        volume: json['volume'],
        volumeMode: json['vol_mode'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'change_volume': changeVol,
        'volume': volume,
        'vol_mode': volumeMode,
      };
}
