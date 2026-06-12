// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 1;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      id: fields[0] as String,
      petId: fields[1] as String,
      recordTypeIndex: fields[2] as int,
      date: fields[3] as DateTime,
      title: fields[4] as String,
      notes: fields[5] as String?,
      value: fields[6] as double?,
      unit: fields[7] as String?,
      nextDueDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.recordTypeIndex)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.value)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.nextDueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
