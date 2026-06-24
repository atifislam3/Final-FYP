import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import '../data/models/report_model.dart';
import '../data/services/hive_service.dart';

class ReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var selectedDate = Rxn<DateTime>();

  final List<String> categories = [
    'All',
    'Prescription',
    'Lab Result',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    reports.value = HiveService.getAllReports();
    filterReports();
  }

  void filterReports() {
    final query = searchQuery.value.toLowerCase().trim();
    final selectedCat = selectedCategory.value;
    final selectedDt = selectedDate.value;

    filteredReports.value = reports.where((r) {
      if (selectedCat != 'All' && r.category != selectedCat) {
        return false;
      }
      if (selectedDt != null) {
        if (r.dateUploaded.year != selectedDt.year ||
            r.dateUploaded.month != selectedDt.month ||
            r.dateUploaded.day != selectedDt.day) {
          return false;
        }
      }

      if (query.isEmpty) return true;

      final dateLabel = DateFormat('dd MMM yyyy').format(r.dateUploaded);
      return r.title.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query) ||
          dateLabel.toLowerCase().contains(query);
    }).toList();

    filteredReports.sort((a, b) => b.dateUploaded.compareTo(a.dateUploaded));
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    filterReports();
  }

  void setCategoryFilter(String category) {
    selectedCategory.value = category;
    filterReports();
  }

  void setDateFilter(DateTime? date) {
    selectedDate.value = date;
    filterReports();
  }

  void clearFilters() {
    selectedCategory.value = 'All';
    selectedDate.value = null;
    filterReports();
  }

  // --- CRUD ---
  Future<void> pickAndAddReport(
      {required String title, required String category}) async {
    // Pick file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;

      final newReport = ReportModel(
        id: const Uuid().v4(),
        title: title,
        dateUploaded: DateTime.now(),
        category: category,
        filePath: filePath,
      );

      await HiveService.addReport(newReport);
      loadReports();
      Get.snackbar("Success", "Report added successfully.");
    } else {
      // User canceled
    }
  }

  Future<void> deleteReport(String id) async {
    await HiveService.deleteReport(id);
    loadReports();
    Get.snackbar("Deleted", "Report removed.");
  }

  // --- ACTIONS ---
  Future<void> openReport(String filePath) async {
    if (filePath.toLowerCase().endsWith('.pdf')) {
      Get.toNamed('/reportPdf', arguments: filePath);
      return;
    }

    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      Get.snackbar("Error", "Could not open file: ${result.message}");
    }
  }
}
