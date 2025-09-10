// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmModelAdapter extends TypeAdapter<AlarmModel> {
  @override
  final int typeId = 0;

  @override
  AlarmModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmModel(
      id: fields[0] as String,
      title: fields[1] as String,
      dateTime: fields[2] as DateTime,
      isEnabled: fields[3] as bool,
      repeatDays: (fields[4] as List?)?.cast<bool>(),
      soundPath: fields[5] as String,
      volume: fields[6] as double,
      vibrate: fields[7] as bool,
      dismissMode: fields[8] as AlarmDismissMode,
      snoozeCount: fields[9] as int,
      snoozeDuration: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.isEnabled)
      ..writeByte(4)
      ..write(obj.repeatDays)
      ..writeByte(5)
      ..write(obj.soundPath)
      ..writeByte(6)
      ..write(obj.volume)
      ..writeByte(7)
      ..write(obj.vibrate)
      ..writeByte(8)
      ..write(obj.dismissMode)
      ..writeByte(9)
      ..write(obj.snoozeCount)
      ..writeByte(10)
      ..write(obj.snoozeDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlarmDismissModeAdapter extends TypeAdapter<AlarmDismissMode> {
  @override
  final int typeId = 1;

  @override
  AlarmDismissMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlarmDismissMode.button;
      case 1:
        return AlarmDismissMode.math;
      case 2:
        return AlarmDismissMode.qrCode;
      case 3:
        return AlarmDismissMode.photo;
      case 4:
        return AlarmDismissMode.shake;
      default:
        return AlarmDismissMode.button;
    }
  }

  @override
  void write(BinaryWriter writer, AlarmDismissMode obj) {
    switch (obj) {
      case AlarmDismissMode.button:
        writer.writeByte(0);
        break;
      case AlarmDismissMode.math:
        writer.writeByte(1);
        break;
      case AlarmDismissMode.qrCode:
        writer.writeByte(2);
        break;
      case AlarmDismissMode.photo:
        writer.writeByte(3);
        break;
      case AlarmDismissMode.shake:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmDismissModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
