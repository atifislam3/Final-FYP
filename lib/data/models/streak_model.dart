import 'package:hive/hive.dart';

part 'streak_model.g.dart';

@HiveType(typeId: 6)
class StreakModel {
  @HiveField(0)
  int currentStreak;

  @HiveField(1)
  int maxStreak;

  @HiveField(2)
  DateTime lastLogDate;

  StreakModel({
    required this.currentStreak,
    required this.maxStreak,
    required this.lastLogDate,
  });
}
