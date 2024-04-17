// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScenarioModelAdapter extends TypeAdapter<ScenarioModel> {
  @override
  final int typeId = 1;

  @override
  ScenarioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScenarioModel(
      startTime: fields[0] as String,
      endTime: fields[1] as String,
      repeat: (fields[2] as List).cast<String>(),
      title: fields[3] as String,
      volumeMode: fields[4] as String,
      volume: fields[5] as int,
      isON: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScenarioModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.repeat)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.volumeMode)
      ..writeByte(5)
      ..write(obj.volume)
      ..writeByte(6)
      ..write(obj.isON);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScenarioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
