// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final int typeId = 1;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      medicineId: fields[0] as String,
      name: fields[1] as String,
      dosage: fields[2] as String,
      type: fields[3] as String,
      stock: fields[4] as int,
      reminderTimes: (fields[5] as List).cast<DateTime>(),
      isActive: fields[6] as bool,
      frequencyType: fields[7] as String,
      specificDays: (fields[8] as List?)?.cast<int>(),
      interval: fields[9] as int?,
      cycleOnDays: fields[10] as int?,
      cycleOffDays: fields[11] as int?,
      startDate: fields[12] as DateTime?,
      dateEnded: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.medicineId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dosage)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.reminderTimes)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.frequencyType)
      ..writeByte(8)
      ..write(obj.specificDays)
      ..writeByte(9)
      ..write(obj.interval)
      ..writeByte(10)
      ..write(obj.cycleOnDays)
      ..writeByte(11)
      ..write(obj.cycleOffDays)
      ..writeByte(12)
      ..write(obj.startDate)
      ..writeByte(13)
      ..write(obj.dateEnded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
