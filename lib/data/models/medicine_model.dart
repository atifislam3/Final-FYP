import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 1)
class MedicineModel {
  @HiveField(0)
  String medicineId;
  @HiveField(1)
  String name;
  @HiveField(2)
  String dosage;
  @HiveField(3)
  String type; // SRS-82 (Category)
  @HiveField(4)
  int stock; // SRS-65 (Initial Stock)
  @HiveField(5)
  List<DateTime> reminderTimes; // SRS-63 (Multiple times)
  @HiveField(6)
  bool isActive; // SRS-79 (Disable Alert)

  // Schedule Logic (SRS-64)
  @HiveField(7)
  String frequencyType; // 'Daily', 'SpecificDays', 'Interval', 'Cyclic'
  @HiveField(8)
  List<int>? specificDays;
  @HiveField(9)
  int? interval;

  // NEW: Cyclic Schedule Fields (SRS-64)
  @HiveField(10)
  int? cycleOnDays; // X days on
  @HiveField(11)
  int? cycleOffDays; // Y days off
  @HiveField(12)
  DateTime? startDate; // Required for Interval/Cyclic calc
  @HiveField(13)
  DateTime? dateEnded; // For Past Medications (SRS-93)

  MedicineModel({
    required this.medicineId,
    required this.name,
    required this.dosage,
    required this.type,
    required this.stock,
    required this.reminderTimes,
    this.isActive = true,
    required this.frequencyType,
    this.specificDays,
    this.interval,
    this.cycleOnDays,
    this.cycleOffDays,
    this.startDate,
    this.dateEnded,
  });
}
