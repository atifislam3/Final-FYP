import 'package:hive/hive.dart';

part 'report_model.g.dart';

@HiveType(typeId: 5)
class ReportModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dateUploaded; // Renamed from 'date' to match schema

  @HiveField(3)
  String category; // 'Prescription', 'Lab_Report', 'Bill', 'Other'

  @HiveField(4)
  String filePath;

  ReportModel({
    required this.id,
    required this.title,
    required this.dateUploaded,
    required this.category,
    required this.filePath,
  });
}
