import 'package:hive_flutter/hive_flutter.dart';
part 'current_system_settings.g.dart';

@HiveType(typeId: 2)
class CurrentSystemSettings {
  const CurrentSystemSettings({this.volume, this.volMode});
  @HiveField(0)
  final int? volume;

  @HiveField(1)
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
