import 'package:get/get.dart';
import '../data/models/medicine_log_model.dart';
import '../data/models/medicine_model.dart';
import '../data/services/hive_service.dart';

class AnalyticsController extends GetxController {
  var logs = <MedicineLogModel>[].obs;
  var medicines = <MedicineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    logs.value = HiveService.getAllLogs();
    medicines.value = HiveService.getAllMedicines();
  }

  // Reload manually (e.g., on pull to refresh)
  void refreshData() {
    loadData();
  }

  // --- FILTERS (SRS-145) ---
  var selectedMedicineId = 'All'.obs;
  var selectedPeriod = 'Monthly'.obs; // 'All', 'Daily', 'Weekly', 'Monthly'

  void setFilterMedicine(String medId) {
    selectedMedicineId.value = medId;
    update(); // Force UI rebuild if needed
  }

  void setFilterPeriod(String period) {
    selectedPeriod.value = period;
    update();
  }

  List<MedicineLogModel> getFilteredLogs() {
    var filtered = logs.toList();

    if (selectedMedicineId.value != 'All') {
      filtered = filtered.where((l) => l.medicineId == selectedMedicineId.value).toList();
    }

    final now = DateTime.now();
    if (selectedPeriod.value == 'Daily') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays == 0 && l.scheduledTime.day == now.day).toList();
    } else if (selectedPeriod.value == 'Weekly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 7).toList();
    } else if (selectedPeriod.value == 'Monthly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 30).toList();
    }

    return filtered;
  }

  // --- CHART DATA: OVERVIEW (Pie Chart) ---
  Map<String, double> getStatusDistribution() {
    final filtered = getFilteredLogs();
    if (filtered.isEmpty) {
      return {'Taken': 0, 'Missed': 0, 'Skipped': 0};
    }

    int taken = filtered.where((l) => l.status == 'Taken').length;
    int skipped = filtered.where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed').length;

    return {
      'Taken': taken.toDouble(),
      'Missed': skipped.toDouble(),
    };
  }

  // --- CHART DATA: MONTHLY TRENDS (Bar Chart) ---
  // Returns list of logs for the last 30 days
  List<MedicineLogModel> getLast30DaysLogs() {
    return getFilteredLogs();
  }

  Map<int, int> getDailyTakenCounts() {
    Map<int, int> dailyCounts = {};
    for (int i = 6; i >= 0; i--) {
      dailyCounts[i] = 0;
    }

    final now = DateTime.now();
    final filtered = getFilteredLogs();

    for (var log in filtered) {
      if (log.status != 'Taken') continue;

      final diff = now.difference(log.scheduledTime).inDays;
      if (diff >= 0 && diff < 7) {
        dailyCounts[diff] = (dailyCounts[diff] ?? 0) + 1;
      }
    }
    return dailyCounts;
  }

  // --- MISSED DOSES REPORT ---
  List<MedicineLogModel> getMissedDoses() {
    return getFilteredLogs()
        .where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed')
        .toList();
  }

  // Helper to get Medicine Name by ID
  String getMedicineName(String medId) {
    final med = medicines.firstWhereOrNull((m) => m.medicineId == medId);
    return med?.name ?? 'Unknown Medicine';
  }

  // --- SRS-150: MONTHLY SUMMARY (last 4 weeks / 28 days, taken vs missed) ---
  // Returns { weekIndex (0=oldest…3=this week) -> {'taken': N, 'missed': N} }
  Map<int, Map<String, int>> getMonthlyWeeklyCounts() {
    final now = DateTime.now();
    final Map<int, Map<String, int>> weekData = {
      0: {'taken': 0, 'missed': 0},
      1: {'taken': 0, 'missed': 0},
      2: {'taken': 0, 'missed': 0},
      3: {'taken': 0, 'missed': 0},
    };

    for (var log in logs) {
      final diff = now.difference(log.scheduledTime).inDays;
      if (diff < 0 || diff >= 28) continue;
      final weekIndex = 3 - (diff ~/ 7); // 3=this week, 0=3 weeks ago
      if (log.status == 'Taken') {
        weekData[weekIndex]!['taken'] =
            (weekData[weekIndex]!['taken'] ?? 0) + 1;
      } else if (log.status == 'Skipped' ||
          log.status == 'Miss' ||
          log.status == 'Missed') {
        weekData[weekIndex]!['missed'] =
            (weekData[weekIndex]!['missed'] ?? 0) + 1;
      }
    }
    return weekData;
  }

  // --- SRS-147: IRREGULAR INTAKE (medicines with >30% missed rate in last 28 days) ---
  List<Map<String, dynamic>> getIrregularMedicines() {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 28));
    final recentLogs =
        logs.where((l) => l.scheduledTime.isAfter(cutoff)).toList();

    final Map<String, List<MedicineLogModel>> logsByMed = {};
    for (var log in recentLogs) {
      logsByMed.putIfAbsent(log.medicineId, () => []).add(log);
    }

    final List<Map<String, dynamic>> irregular = [];
    for (final entry in logsByMed.entries) {
      final medLogs = entry.value;
      final total = medLogs.length;
      if (total < 3) continue; // need at least 3 logs to flag
      final missed = medLogs
          .where((l) =>
              l.status == 'Skipped' ||
              l.status == 'Miss' ||
              l.status == 'Missed')
          .length;
      final missedRate = missed / total;
      if (missedRate > 0.30) {
        irregular.add({
          'name': getMedicineName(entry.key),
          'missedRate': missedRate,
          'missed': missed,
          'total': total,
        });
      }
    }
    irregular.sort((a, b) =>
        (b['missedRate'] as double).compareTo(a['missedRate'] as double));
    return irregular;
  }
}
