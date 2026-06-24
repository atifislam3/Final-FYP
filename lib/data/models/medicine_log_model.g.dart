// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineLogModelAdapter extends TypeAdapter<MedicineLogModel> {
  @override
  final int typeId = 2;

  @override
  MedicineLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineLogModel(
      logId: fields[0] as String,
      medicineId: fields[1] as String,
      scheduledTime: fields[2] as DateTime,
      actualTime: fields[3] as DateTime,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineLogModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.logId)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.scheduledTime)
      ..writeByte(3)
      ..write(obj.actualTime)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
