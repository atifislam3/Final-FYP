import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/journal_model.dart';
import '../data/models/streak_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import 'medicine_controller.dart';
// import 'analytics_controller.dart';

class WellnessController extends GetxController {
  final MedicineController _medController = Get.find<MedicineController>();
  // final AnalyticsController _analyticsController = Get.put(AnalyticsController());

  // Journal State
  var dailyMood = ''.obs;
  final noteController = ''.obs; // Simple text observable for input
  var journalHistory = <JournalModel>[].obs;

  // Streak State
  var currentStreak = 0.obs;
  var maxStreak = 0.obs;

  // Challenge State
  var dailyChallenge = "Loading challenge...".obs;
  var isChallengeLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadJournal();
    loadStreak();
    calculateStreak();
    generateDailyChallenge();
  }

  // --- JOURNALING ---
  void loadJournal() {
    journalHistory.value = HiveService.getAllJournals();
    // sort by date desc
    journalHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addEntry(String mood, String? note) async {
    final entry = JournalModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      mood: mood,
      note: note,
    );

    await HiveService.addJournal(entry);
    loadJournal();
    dailyMood.value = ''; // Reset
    Get.snackbar("Saved", "Mood logged successfully!");
  }

  Future<void> updateEntry(JournalModel updatedEntry) async {
    // HiveService.addJournal acts as insert or update (it uses box.put(journal.id, journal))
    await HiveService.addJournal(updatedEntry);
    loadJournal();
    Get.snackbar("Updated", "Journal entry updated successfully!");
  }

  Future<void> deleteEntry(String id) async {
    await HiveService.deleteJournal(id);
    loadJournal();
    Get.snackbar("Deleted", "Journal entry removed");
  }

  // --- STREAK CALCULATION (SRS-123/125) ---
  void calculateStreak() {
    // Logic: Consecutive days with 100% adherence.
    // We look at AnalyticsController logs.
    List<DateTime> perfectDays = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check last 365 days
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      if (_wasPerfectDay(date)) {
        perfectDays.add(date);
      } else {
        // Streak broken
        // Exception: If today is not over, don't break streak yet?
        // SRS-125: Reset if user FAILS to log.
        // Simplified: If yesterday was perfect, streak continues.
        // If yesterday was NOT perfect, streak is 0 (or 1 if today is perfect).
      }
    }

    // Simple consecutive count from yesterday backwards
    int streak = 0;

    // Check Today first (if perfect, it counts)
    if (_wasPerfectDay(today)) streak++;

    // Check Yesterday backwards
    DateTime checkDate = today.subtract(const Duration(days: 1));
    while (_wasPerfectDay(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    currentStreak.value = streak;

    // Update max streak if current is higher
    if (streak > maxStreak.value) {
      maxStreak.value = streak;
    }

    // Save to Hive
    _saveStreak();
  }

  void loadStreak() {
    final saved = HiveService.getStreak();
    if (saved != null) {
      currentStreak.value = saved.currentStreak;
      maxStreak.value = saved.maxStreak;
    }
  }

  Future<void> _saveStreak() async {
    final streak = StreakModel(
      currentStreak: currentStreak.value,
      maxStreak: maxStreak.value,
      lastLogDate: DateTime.now(),
    );
    await HiveService.saveStreak(streak);
  }

  bool _wasPerfectDay(DateTime date) {
    // 1. Get all meds scheduled for this date
    final scheduledMeds = _medController.medicines
        .where((m) => _medController.isScheduledForDate(m, date))
        .toList();

    if (scheduledMeds.isEmpty)
      return false; // No meds = No streak logic? Or maintain?
    // Let's say if no meds scheduled, streak is effectively maintained but not incremented?
    // SRS says "Consecutive days where user achieves 100% adherence".
    // If 0 meds, adherence is N/A. Let's return FALSE for strictly "achieving" generic adherence.
    // BUT usually users want streaks to hold on rest days.
    // For now, STRICT implementation: Must have taken meds.

    bool allTaken = true;
    for (var med in scheduledMeds) {
      for (var time in med.reminderTimes) {
        if (!_medController.isTaken(med.medicineId, date, time)) {
          allTaken = false;
          break;
        }
      }
    }
    return allTaken;
  }

  // --- DAILY CHALLENGES (SRS-120) ---
  Future<void> generateDailyChallenge() async {
    isChallengeLoading.value = true;

    final fallbackChallenges = [
      "Drink 8 glasses of water today 💧",
      "Take a 15-minute walk outside 🚶",
      "Eat a colorful fruit or vegetable 🍎",
      "Meditate for 5 minutes 🧘",
      "Sleep 8 hours tonight 😴",
      "Do 10 minutes of stretching 🤸",
      "Call a loved one today 📞",
      "Take all your medicines on time today 💊",
    ];

    try {
      final mood = dailyMood.value.isNotEmpty ? dailyMood.value : "neutral";
      final prompt =
          "Generate ONE short, motivating daily health challenge (max 12 words) for a medicine app user who is feeling $mood today. Make it actionable, positive, and health-focused. Return only the challenge text with a relevant emoji at the end. No extra text.";

      final text = await GeminiService.generateText(prompt);
      if (text != null) {
        dailyChallenge.value = text;
      } else {
        dailyChallenge.value = (fallbackChallenges..shuffle()).first;
      }
    } catch (e) {
      // SRS-121: Fallback when offline or API unreachable
      dailyChallenge.value = (fallbackChallenges..shuffle()).first;
    } finally {
      isChallengeLoading.value = false;
    }
  }
}
