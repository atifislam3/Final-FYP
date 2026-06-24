import 'package:hive/hive.dart';

part 'journal_model.g.dart';

@HiveType(typeId: 4)
class JournalModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String mood; // 'Happy', 'Neutral', 'Sad', etc.

  @HiveField(3)
  String? note;

  JournalModel({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
  });
}
