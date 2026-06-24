import 'package:hive/hive.dart';

part 'appointment_model.g.dart'; // Run build_runner to generate this

@HiveType(typeId: 3) // Unique ID 3 (User=0, Med=1, Log=2)
class AppointmentModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String doctorName;
  @HiveField(2)
  String category; // SRS-105 (e.g. General, Dentist)
  @HiveField(3)
  DateTime dateTime; // SRS-105
  @HiveField(4)
  int? reminderMinutes; // SRS-112 (Minutes before apt to remind)
  @HiveField(5)
  String? visitNotes; // SRS-114
  @HiveField(6)
  bool isCompleted; // SRS-109
  @HiveField(7)
  bool isRecurring; // SRS-113 (Recurring reminder toggle)
  @HiveField(8)
  String? recurringFrequency; // SRS-113 ('Weekly' or 'Monthly')

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.category,
    required this.dateTime,
    this.reminderMinutes,
    this.visitNotes,
    this.isCompleted = false,
    this.isRecurring = false,
    this.recurringFrequency,
  });
}
