class CurrentSystemSettings {
  const CurrentSystemSettings({this.volume, this.volMode});

  final int? volume;
  final String? volMode;

  factory CurrentSystemSettings.formJson(Map<String, dynamic> json) =>
      CurrentSystemSettings(
        volume: json['volume'],
        volMode: json['vol_mode'],
      );

  Map<String, dynamic> toJson() => {
        'volume': volume,
        'vol_mode': volMode,
      };
}
