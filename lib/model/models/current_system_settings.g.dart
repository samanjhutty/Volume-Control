// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_system_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentSystemSettingsAdapter extends TypeAdapter<CurrentSystemSettings> {
  @override
  final int typeId = 2;

  @override
  CurrentSystemSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentSystemSettings(
      volume: fields[0] as int?,
      volMode: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentSystemSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.volume)
      ..writeByte(1)
      ..write(obj.volMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentSystemSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
