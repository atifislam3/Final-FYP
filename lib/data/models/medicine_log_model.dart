import 'package:hive/hive.dart';

part 'medicine_log_model.g.dart';

@HiveType(typeId: 2)
class MedicineLogModel {
  @HiveField(0)
  String logId;

  @HiveField(1)
  String medicineId;

  @HiveField(2)
  DateTime scheduledTime;

  @HiveField(3)
  DateTime actualTime;

  @HiveField(4)
  String status; // 'Taken', 'Skipped'

  MedicineLogModel({
    required this.logId,
    required this.medicineId,
    required this.scheduledTime,
    required this.actualTime,
    required this.status,
  });
}
