# GITHUB Copilot — Complete Code-Focused Project Guide

This guide focuses on the code you will be editing during a practical demo. It explains files, key functions, how data flows, and exactly where to change things.

---

## Quick Run & Setup

1. Install Flutter (stable) and ensure `flutter` is on PATH.
2. From project root run:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

3. To run on an emulator or device:

```bash
flutter run -d <device-id>
```

Notes:
- If Hive adapters are out of date, run the `build_runner` command above.
- If the app uses a `.env` for Gemini, create it from `.env.example` with `GEMINI_API_KEY`.

---

## Entry Point — `lib/main.dart`

What `main()` does (code-level):

- Calls `WidgetsFlutterBinding.ensureInitialized()`.
- Loads `.env` via `dotenv.load()` (try-catch). If missing, AI features are disabled but app continues.
- Calls `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
- Initializes Hive via `HiveService.init()` (opens boxes and registers adapters).
- Reads theme from Hive `settingsBox.get('isDarkMode')`.
- Calls `NotificationService.init()` to request permissions and create channels.
- Sets `SystemChrome.setSystemUIOverlayStyle(...)` and runs `GetMaterialApp`.

Where to change app-level behavior:

- To change initial route, open `lib/main.dart` and modify `GetMaterialApp(initialRoute: ...)`.
- To add a global binding or controller, use `initialBinding` in `GetMaterialApp`.

Key functions/lines to inspect:

- `await HiveService.init();` — opens boxes and registers adapters (see `lib/data/services/hive_service.dart`).
- `final settingsBox = await Hive.openBox('settingsBox');` — read/write persisted settings.

---

## Important Service Files (exact edits here)

1. `lib/data/services/hive_service.dart`
- `init()` registers adapters. If you add a new `@HiveType`, assign a unique `typeId` and run `build_runner`.
- Useful methods: `saveUserSession(String uid)`, `getUserId()`.

2. `lib/data/services/firebase_auth_service.dart`
- Methods: `signUp(email,password,name)`, `login(email,password)`, `sendPasswordResetEmail`, `changePassword`, `signInWithGoogle()`.
- To change error messages, update `_handleException` mapping.

3. `lib/data/services/notification_service.dart`
- Functions: `init()`, `scheduleNotification(...)`, `showNotification(...)`, `consumePendingNotification()`.
- Notifications payloads are JSON containing `medicineId` and `scheduledTime` — search for `payload` in this file.

4. `lib/data/services/realtime_database_service.dart`
- Cloud sync: `saveUser`, `getUser`, `saveMedicine`.
- Ensure paths like `/users/{uid}/medicines/{medicineId}` match your security rules.

5. `lib/data/services/gemini_service.dart`
- Reads `dotenv.env['GEMINI_API_KEY']` and sends HTTP requests to Gemini. If missing, the code throws or returns an error string; handle that in `ChatController`.

---

## Core Models (where to change fields)

Open `lib/data/models/medicine_model.dart`:

- Add a field: add `@HiveField(n)` where `n` is the next unused integer. Example:

```dart
@HiveField(14)
String? sideEffects;
```

- After editing a model, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Important models:
- `UserModel` (profile fields) — `lib/data/models/user_model.dart`
- `MedicineModel` — `lib/data/models/medicine_model.dart` (scheduling logic here)
- `MedicineLogModel` — `lib/data/models/medicine_log_model.dart` (logs/taken/skipped)

Never change a `typeId` on an existing Hive model after data was written — that breaks deserialization.

---

## Core Controllers & Functions to Know

1. `lib/view_models/auth_controller.dart`
- `signUp(...)` validates passwords, calls `FirebaseAuthService.signUp`, sends verification email.
- `login(...)` calls `FirebaseAuthService.login` and saves session via `HiveService.saveUserSession()`.
- `validatePassword(...)` contains the regex and is the place to change strength rules.

2. `lib/view_models/medicine_controller.dart`
- Key responsibilities:
  - Load medicines: `loadMedicines()` → `HiveService.getAllMedicines()`
  - Schedule notifications: `rescheduleAllNotifications()`
  - Mark taken/skipped: `markMedicineTaken(...)`, `markMedicineSkipped(...)`
  - Auto-miss logic: `_autoMarkPreviousDayMissedDoses()`

Look for these functions (open file and search their names). To change scheduling behavior, edit `isScheduledForDate(...)` logic inside the controller or move that logic into `medicine_model.dart` as a helper.

3. `lib/view_models/profile_controller.dart`
- `calculateBMI(weight, height)` must convert `height` from cm to m: `height / 100`.
- `uploadProfilePhoto(File)` calls Firebase Storage and saves URL to Realtime DB/Hive.

4. `lib/view_models/chat_controller.dart`
- `sendMessage(String)` saves a user message to Hive, calls `GeminiService.sendMessage`, then saves the response.
- If Gemini key missing, this controller should display a descriptive error — you can change `GeminiService` to return a specific exception type to catch here.

5. `lib/view_models/schedule_controller.dart` & `appointment_controller.dart`
- `getMedicinesForDate(date)` uses `medicineController.isScheduledForDate` and `medicine.reminderTimes`.

---

## UI Files & Quick Changes (practical edits you may be asked to do)

1. Change button color (example):
- File: `lib/views/tabs/dashboard_view.dart` or `lib/views/widgets/some_button.dart`
- Replace color in `ElevatedButton.styleFrom(backgroundColor: ...)`.

2. Change login background gradient:
- File: `lib/views/login_view.dart` — search for `LinearGradient(` and change the `colors: [...]` list.

3. Add a new tab to `HomeView`:
- File: `lib/views/home_view.dart` — update the `pages` list and the `BottomNavigationBarItem` list. Ensure `selectedIndex` logic still matches bounds.

4. Increase password strength rule:
- File: `lib/view_models/auth_controller.dart` — update regex in `validatePassword`.

5. Add a field to Add/Edit Medicine form:
- Update `lib/views/add_medicine_view.dart` to include a `TextField` and its `controller` in `MedicineController`.
- Update `MedicineController.prepareEdit(...)` to populate the controller when editing.

Code-level example: adding `sideEffects` to the Add form

```dart
// In medicine_controller.dart
final sideEffectsController = TextEditingController();

// In add_medicine_view.dart (inside the form)
TextFormField(
  controller: controller.sideEffectsController,
  decoration: InputDecoration(labelText: 'Side Effects'),
),

// When saving
MedicineModel m = MedicineModel(
  ...,
  sideEffects: controller.sideEffectsController.text,
);
```

Then run the `build_runner` command to regenerate adapters.

---

## Scheduling Logic (exact code you may edit)

Implement or inspect this helper (put in `medicine_model.dart` or `medicine_controller.dart`):

```dart
bool isScheduledForDate(MedicineModel m, DateTime date) {
  final dayOnly = DateTime(date.year, date.month, date.day);
  switch (m.frequencyType) {
    case 'Daily':
      return true;
    case 'SpecificDays':
      int weekdayIndex = dayOnly.weekday - 1; // 0 = Monday
      return m.specificDays?.contains(weekdayIndex) ?? false;
    case 'Interval':
      if (m.startDate == null || m.interval == null) return false;
      final diff = dayOnly.difference(m.startDate!).inDays;
      return diff >= 0 && diff % m.interval! == 0;
    case 'Cyclic':
      if (m.startDate == null || m.cycleOnDays == null || m.cycleOffDays == null) return false;
      final cycleLen = m.cycleOnDays! + m.cycleOffDays!;
      final pos = dayOnly.difference(m.startDate!).inDays % cycleLen;
      return pos < m.cycleOnDays!;
    default:
      return false;
  }
}
```

---

**File: lib/views/add_medicine_view.dart**

Below is the exact `AddMedicineView` widget source (extracted). Use this when explaining the Add/Edit medicine UI and when pointing to which methods populate controllers or invoke `MedicineController`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class AddMedicineView extends StatefulWidget {
  final MedicineModel? editMedicine;
  const AddMedicineView({super.key, this.editMedicine});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView>
    with TickerProviderStateMixin {
  late final MedicineController controller;
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _bgAnim;
  late final Animation<double> _card1;
  late final Animation<double> _card2;
  late final Animation<double> _card3;
  late final Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MedicineController());

    if (widget.editMedicine != null) {
      controller.prepareEdit(widget.editMedicine!);
    } else {
      controller.nameController.clear();
      controller.dosageController.clear();
      controller.stockController.clear();
      controller.customTypeController.clear();
      controller.reminderTimes.clear();
      controller.selectedDays.clear();
      controller.frequency.value = 'Daily';
    }

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();

    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _card1 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic));
    _card2 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.20, 0.75, curve: Curves.easeOutCubic));
    _card3 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.40, 0.95, curve: Curves.easeOutCubic));
    _btnAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────


  BoxDecoration get _glassCard => BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      );

  InputDecoration _glassInput(String label, IconData icon, {String? hint}) => InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppThemeColors.secondaryText(_b), fontSize: 14),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: AppThemeColors.glassBorder(_b))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFC7D2FE), width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1.8)),
        hintText: hint,
        hintStyle:
            TextStyle(color: AppThemeColors.hintText(_b), fontSize: 14),
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: AppThemeColors.secondaryText(_b)),
      );

  Widget _staggered(Animation<double> anim, Widget child) =>
      AnimatedBuilder(
        animation: anim,
        builder: (_, __) => Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child:
              Transform.translate(offset: Offset(0, 28 * (1 - anim.value)), child: child),
        ),
        child: child,
      );

  String _freqLabel(String key) {
    if (key == 'SpecificDays') return 'Specific Days';
    if (key == 'Interval') return 'Interval (Every X Days)';
    if (key == 'Cyclic') return 'Cyclic (On/Off)';
    return 'Every Day';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final isEdit = widget.editMedicine != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? "Update Medicine" : "Add Medicine",
          style: TextStyle(
              color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // gradient background
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // animated orbs
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: _bgAnim.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          // scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                children: [
                  // icon badge
                  _staggered(
                    _card1,
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xFF4F46E5).withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                        child: const Icon(Icons.medication_rounded,
                            color: Colors.white, size: 34),
                      ),
                    ),
                  ),

                  // ── SECTION 1: Basic Info ──────────────────────────────
                  _staggered(_card1, _buildBasicInfoCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 2: Frequency ──────────────────────────────
                  _staggered(_card2, _buildFrequencyCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 3: Reminders ──────────────────────────────
                  _staggered(_card3, _buildRemindersCard()),
                  const SizedBox(height: 28),

                  // ── Save / Update button ──────────────────────────────
                  _staggered(_btnAnim, _buildSaveButton(isEdit)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section cards ──────────────────────────────────────────────────────────

  Widget _buildBasicInfoCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("BASIC INFO"),
          const SizedBox(height: 16),

          // Medicine name
          TextFormField(
            controller: controller.nameController,
            style: TextStyle(color: AppThemeColors.primaryText(_b)),
            decoration:
                _glassInput("Medicine Name", Icons.label_outline),
          ),
          const SizedBox(height: 16),

          // Type chips
          _sectionLabel("TYPE"),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.defaultTypes.map((type) {
                  final selected = controller.selectedType.value == type;
                  return GestureDetector(
                    onTap: () => controller.selectedType.value = type,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [
                                Color(0xFF818CF8),
                                Color(0xFF4F46E5),
                              ])
                            : null,
                        color: selected
                            ? null
                            : AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppThemeColors.secondaryText(_b),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              )),

          Obx(() => controller.selectedType.value == 'Other'
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller.customTypeController,
                    style: TextStyle(color: AppThemeColors.primaryText(_b)),
                    decoration:
                        _glassInput("Specify Type", Icons.edit_note),
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 16),

          // Dosage + Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.dosageController,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Dosage", Icons.scale_outlined, hint: "e.g. 500mg"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Stock", Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


---

**File: lib/views/add_medicine_view.dart**

Below is the exact `AddMedicineView` widget source (extracted). Use this when explaining the Add/Edit medicine UI and when pointing to which methods populate controllers or invoke `MedicineController`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/medicine_controller.dart';
import '../data/models/medicine_model.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class AddMedicineView extends StatefulWidget {
  final MedicineModel? editMedicine;
  const AddMedicineView({super.key, this.editMedicine});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView>
    with TickerProviderStateMixin {
  late final MedicineController controller;
  Brightness _b = Brightness.dark;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _bgAnim;
  late final Animation<double> _card1;
  late final Animation<double> _card2;
  late final Animation<double> _card3;
  late final Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MedicineController());

    if (widget.editMedicine != null) {
      controller.prepareEdit(widget.editMedicine!);
    } else {
      controller.nameController.clear();
      controller.dosageController.clear();
      controller.stockController.clear();
      controller.customTypeController.clear();
      controller.reminderTimes.clear();
      controller.selectedDays.clear();
      controller.frequency.value = 'Daily';
    }

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();

    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _card1 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic));
    _card2 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.20, 0.75, curve: Curves.easeOutCubic));
    _card3 = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.40, 0.95, curve: Curves.easeOutCubic));
    _btnAnim = CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────


  BoxDecoration get _glassCard => BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppThemeColors.glassBorder(_b), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      );

  InputDecoration _glassInput(String label, IconData icon, {String? hint}) => InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppThemeColors.secondaryText(_b), fontSize: 14),
        prefixIcon: Icon(icon, color: AppThemeColors.secondaryText(_b)),
        filled: true,
        fillColor: AppThemeColors.glassBg(_b),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: AppThemeColors.glassBorder(_b))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFC7D2FE), width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1.8)),
        hintText: hint,
        hintStyle:
            TextStyle(color: AppThemeColors.hintText(_b), fontSize: 14),
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: AppThemeColors.secondaryText(_b)),
      );

  Widget _staggered(Animation<double> anim, Widget child) =>
      AnimatedBuilder(
        animation: anim,
        builder: (_, __) => Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child:
              Transform.translate(offset: Offset(0, 28 * (1 - anim.value)), child: child),
        ),
        child: child,
      );

  String _freqLabel(String key) {
    if (key == 'SpecificDays') return 'Specific Days';
    if (key == 'Interval') return 'Interval (Every X Days)';
    if (key == 'Cyclic') return 'Cyclic (On/Off)';
    return 'Every Day';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    final isEdit = widget.editMedicine != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? "Update Medicine" : "Add Medicine",
          style: TextStyle(
              color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // gradient background
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // animated orbs
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                  t: _bgAnim.value, alphaMultiplier: AppThemeColors.orbAlpha(b)),
              size: Size.infinite,
            ),
          ),
          // scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                children: [
                  // icon badge
                  _staggered(
                    _card1,
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xFF4F46E5).withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                        child: const Icon(Icons.medication_rounded,
                            color: Colors.white, size: 34),
                      ),
                    ),
                  ),

                  // ── SECTION 1: Basic Info ──────────────────────────────
                  _staggered(_card1, _buildBasicInfoCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 2: Frequency ──────────────────────────────
                  _staggered(_card2, _buildFrequencyCard()),
                  const SizedBox(height: 20),

                  // ── SECTION 3: Reminders ──────────────────────────────
                  _staggered(_card3, _buildRemindersCard()),
                  const SizedBox(height: 28),

                  // ── Save / Update button ──────────────────────────────
                  _staggered(_btnAnim, _buildSaveButton(isEdit)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section cards ──────────────────────────────────────────────────────────

  Widget _buildBasicInfoCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("BASIC INFO"),
          const SizedBox(height: 16),

          // Medicine name
          TextFormField(
            controller: controller.nameController,
            style: TextStyle(color: AppThemeColors.primaryText(_b)),
            decoration:
                _glassInput("Medicine Name", Icons.label_outline),
          ),
          const SizedBox(height: 16),

          // Type chips
          _sectionLabel("TYPE"),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.defaultTypes.map((type) {
                  final selected = controller.selectedType.value == type;
                  return GestureDetector(
                    onTap: () => controller.selectedType.value = type,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(colors: [
                                Color(0xFF818CF8),
                                Color(0xFF4F46E5),
                              ])
                            : null,
                        color: selected
                            ? null
                            : AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppThemeColors.secondaryText(_b),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              )),

          Obx(() => controller.selectedType.value == 'Other'
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller.customTypeController,
                    style: TextStyle(color: AppThemeColors.primaryText(_b)),
                    decoration:
                        _glassInput("Specify Type", Icons.edit_note),
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 16),

          // Dosage + Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.dosageController,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Dosage", Icons.scale_outlined, hint: "e.g. 500mg"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration:
                      _glassInput("Stock", Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("SCHEDULE & FREQUENCY"),
          const SizedBox(height: 16),

          // Frequency dropdown
          Obx(() => DropdownButtonFormField<String>(
                value: controller.frequency.value,
                dropdownColor: _b == Brightness.light ? Colors.white : const Color(0xFF1E1B4B),
                style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppThemeColors.glassBg(_b),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: AppThemeColors.glassBorder(_b))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFFC7D2FE), width: 1.8)),
                  labelText: "Frequency",
                  labelStyle: TextStyle(
                      color: AppThemeColors.secondaryText(_b)),
                  prefixIcon: Icon(Icons.event_repeat_rounded, color: AppThemeColors.secondaryText(_b)),
                ),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppThemeColors.secondaryText(_b)),
                items: ["Daily", "SpecificDays", "Interval", "Cyclic"]
                    .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text(_freqLabel(val),
                            style: TextStyle(color: AppThemeColors.primaryText(_b)))))
                    .toList(),
                onChanged: (v) => controller.frequency.value = v!,
              )),

          const SizedBox(height: 20),

          // Dynamic frequency UI
          Obx(() => _buildDynamicFreqUI(controller.frequency.value)),
        ],
      ),
    );
  }

  Widget _buildDynamicFreqUI(String freq) {
    if (freq == 'SpecificDays') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("SELECT DAYS"),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List.generate(7, (i) {
                  final day = i + 1;
                  final selected = controller.selectedDays.contains(day);
                  final label = const [
                    "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
                  ][i];
                  return GestureDetector(
                    onTap: () => selected
                        ? controller.selectedDays.remove(day)
                        : controller.selectedDays.add(day),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFF818CF8), Color(0xFF4F46E5)])
                            : null,
                        color: selected
                            ? null
                            : AppThemeColors.glassDivider(_b),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppThemeColors.glassBorder(_b)),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppThemeColors.secondaryText(_b),
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),
                  );
                }),
              )),
        ],
      );
    } else if (freq == 'Interval') {
      return Row(
        children: [
          Text("Every",
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b), fontSize: 15)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => TextFormField(
                  initialValue: controller.interval.value.toString(),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppThemeColors.primaryText(_b)),
                  decoration: _glassInput("", Icons.repeat_rounded),
                  onChanged: (v) =>
                      controller.interval.value = int.tryParse(v) ?? 1,
                )),
          ),
          const SizedBox(width: 12),
          Text("days",
              style: TextStyle(
                  color: AppThemeColors.primaryText(_b), fontSize: 15)),
        ],
      );
    } else if (freq == 'Cyclic') {
      return Row(
        children: [
          Expanded(child: _buildStepper("Days ON", controller.cycleOn)),
          const SizedBox(width: 16),
          Expanded(child: _buildStepper("Days OFF", controller.cycleOff)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStepper(String label, RxInt value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(_b),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: AppThemeColors.glassBorder(_b)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: AppThemeColors.secondaryText(_b),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (value.value > 1) value.value--;
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassBorder(_b),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, color: Colors.white, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Obx(() => Text("${value.value}",
                    style: TextStyle(
                        color: AppThemeColors.primaryText(_b),
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
              ),
              GestureDetector(
                onTap: () => value.value++,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), Color(0xFF4F46E5)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      decoration: _glassCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionLabel("REMINDER TIMES"),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.addTime(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppThemeColors.hintText(_b)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          size: 16,
                          color: AppThemeColors.primaryText(_b)),
                      const SizedBox(width: 4),
                      Text("Add Time",
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() {
            if (controller.reminderTimes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("No reminders set yet",
                      style: TextStyle(
                          color: AppThemeColors.hintText(_b),
                          fontSize: 13)),
                ),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.reminderTimes.map((time) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.glassDivider(_b),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: AppThemeColors.hintText(_b)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_filled_rounded,
                          size: 14, color: Color(0xFFA5B4FC)),
                      const SizedBox(width: 6),
                      Text(time.format(context),
                          style: TextStyle(
                              color: AppThemeColors.primaryText(_b),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => controller.reminderTimes.remove(time),
                        child: Icon(Icons.close_rounded,
                            size: 15,
                            color: AppThemeColors.secondaryText(_b)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSaveButton(bool isEdit) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              controller.saveMedicine(id: widget.editMedicine?.medicineId),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            isEdit ? "Update Medicine" : "Save Medicine",
            style: TextStyle(
                color: AppThemeColors.primaryText(_b),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
```

Notes: `AddMedicineView` binds directly to `MedicineController`. The primary user interactions that trigger logic are `controller.addTime(context)` and `controller.saveMedicine(...)`.

---

**File: lib/views/home_view.dart**

Extract of the `HomeView` and navigation bar (action on startup consumes parked notification payloads):

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'profile_view.dart';
import 'medicine_list_view.dart';
import 'tabs/dashboard_view.dart';
import 'tabs/health_hub_view.dart';
import '../utils/app_theme_colors.dart';
import '../data/services/notification_service.dart';
import 'medicine_action_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final RxInt selectedIndex = 0.obs;
  final RxInt previousIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    // After the first frame, check if a notification tap parked a payload
    // during the splash screen (cold-start) and show the action dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pending = NotificationService.consumePendingNotification();
      if (pending != null) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Get.to(
              () => MedicineActionDialog(
                medicineId: pending.medicineId,
                scheduledTime: pending.scheduledTime,
              ),
              fullscreenDialog: true,
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 300),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardView(),
      HealthHubView(),
      MedicineListView(),
      ProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() {
        final current = selectedIndex.value;
        final previous = previousIndex.value;
        final slideRight = current > previous;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final begin =
                slideRight ? const Offset(0.05, 0) : const Offset(-0.05, 0);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(current),
            child: pages[current],
          ),
        );
      }),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
      ),
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  final RxInt selectedIndex;
  final RxInt previousIndex;

  const _PremiumNavBar({
    required this.selectedIndex,
    required this.previousIndex,
  });

  static const _items = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Today'),
    (icon: Icons.hub_outlined, selectedIcon: Icons.hub_rounded, label: 'Hub'),
    (icon: Icons.medication_outlined, selectedIcon: Icons.medication_rounded, label: 'Medicines'),
    (icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile'),
  ];

  void _onTap(int index) {
    if (selectedIndex.value == index) return;
    HapticFeedback.lightImpact();
    previousIndex.value = selectedIndex.value;
    selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.navBarBg(b),
        border: Border(
          top: BorderSide(
            color: AppThemeColors.navBarBorder(b),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() => Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                return _NavItem(
                  index: i,
                  selectedIndex: selectedIndex.value,
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  label: item.label,
                  onTap: () => _onTap(i),
                );
              }),
            )),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final b = AppThemeColors.brightnessOf(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient pill indicator for selected, transparent for unselected
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppThemeColors.navBarPillGradientStart(b),
                            AppThemeColors.navBarPillGradientEnd(b),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected
                        ? AppThemeColors.navBarSelectedIcon(b)
                        : AppThemeColors.navBarUnselectedIcon(b),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppThemeColors.navBarSelectedLabel(b)
                      : AppThemeColors.navBarUnselectedLabel(b),
                  letterSpacing: isSelected ? 0.2 : 0,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Notes: `HomeView` checks `NotificationService.consumePendingNotification()` on cold start — that is the entry point for showing the `MedicineActionDialog` when a notification was tapped before app initialisation completed.

---

**File: lib/views/tabs/dashboard_view.dart**

Key `DashboardView` extract (calendar, progress ring, and day grouping):

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../view_models/medicine_controller.dart';
import '../../view_models/appointment_controller.dart';
import '../../view_models/profile_controller.dart';
import '../../data/models/medicine_model.dart';
import '../../data/models/appointment_model.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/orb_painter.dart';
import '../../utils/app_theme_colors.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  final MedicineController medController = Get.find<MedicineController>();
  final AppointmentController aptController = Get.find<AppointmentController>();
  final ProfileController profileController = Get.find<ProfileController>();

  late final AnimationController _bgCtrl;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _focusedDay = DateUtils.dateOnly(medController.selectedDate.value);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppThemeColors.scaffoldBg(b),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Gradient background ────────────────────────────────
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // ── 2. Animated orbs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: _bgCtrl.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
            ),
          ),
          // ── 3. Scrollable content ─────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildPremiumHeader(context),
              _buildCalendarSliver(context),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: Obx(() {
                  final todaysMeds = medController.dailyMedicines;
                  final todaysApts = aptController.appointments.where((apt) {
                    return isSameDay(
                        apt.dateTime, medController.selectedDate.value);
                  }).toList();

                  if (todaysMeds.isEmpty && todaysApts.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(b),
                    );
                  }

                  List<Widget> sections = [];
                  final morning = _filterByTime(todaysMeds, todaysApts, 5, 11);
                  final afternoon =
                      _filterByTime(todaysMeds, todaysApts, 11, 17);
                  final evening = _filterByTime(todaysMeds, todaysApts, 17, 24);

                  if (morning.isNotEmpty) {
                    sections.add(
                        _buildSectionHeader('🌅 Morning', '5AM - 11AM', b));
                    sections.addAll(_buildItems(morning, b: b));
                  }
                  if (afternoon.isNotEmpty) {
                    sections.add(
                        _buildSectionHeader('🌞 Afternoon', '11AM - 5PM', b));
                    sections.addAll(
                        _buildItems(afternoon, b: b, offset: morning.length));
                  }
                  if (evening.isNotEmpty) {
                    sections
                        .add(_buildSectionHeader('🌙 Evening', '5PM - 4AM', b));
                    sections.addAll(_buildItems(evening,
                        b: b, offset: morning.length + afternoon.length));
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => sections[index],
                      childCount: sections.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
```

Notes: `DashboardView` groups events by time window and uses `medController.dailyMedicines` which is calculated by `MedicineController` for the selected date.

---

**File: lib/views/login_view.dart**

Login screen extract (UI + background orbs + form bindings to `AuthController`):

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_controller.dart';
import '../view_models/login_view_controller.dart';
import 'signup_view.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _cardCtrl;

  late final Animation<double> _bgFloat;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _bgFloat = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _cardScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutExpo),
    );
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic),
    );

    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _cardCtrl.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final LoginViewController uiCtrl = Get.put(LoginViewController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Animated gradient background ──────────────────
          AnimatedBuilder(
            animation: _bgFloat,
            builder: (_, __) => _AnimatedBg(t: _bgFloat.value, size: size),
          ),

          // ── 2. Scrollable form card ───────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: AnimatedBuilder(
                  animation: _cardCtrl,
                  builder: (_, child) => Opacity(
                    opacity: _cardOpacity.value,
                    child: Transform.scale(
                      scale: _cardScale.value,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: child,
                      ),
                    ),
                  ),
                  child: _buildCard(authController, uiCtrl),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
```

Notes: The `LoginView` wires UI validation to `AuthController.login(...)` and uses `LoginViewController` for UI state like `obscurePassword`.


Place tests around this logic to prove correctness (see next section).

---

## How to Test Small Changes (unit tests)

1. Add `test/medicine_schedule_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_medicine_reminder/data/models/medicine_model.dart';

void main() {
  test('Cyclic schedule works', () {
    final m = MedicineModel(
      medicineId: 'm1',
      name: 'X', dosage: '1', type: 'Tablet', stock: 10,
      reminderTimes: [], isActive: true, frequencyType: 'Cyclic',
      cycleOnDays: 21, cycleOffDays: 7, startDate: DateTime(2024,1,1),
    );
    final jan1 = DateTime(2024,1,1);
    expect(isScheduledForDate(m, jan1), true);
    final jan22 = DateTime(2024,1,22);
    expect(isScheduledForDate(m, jan22), false);
  });
}
```

2. Run tests:

```bash
flutter test test/medicine_schedule_test.dart
```

If you created helper functions in controller, export them so tests can import.

---

## Practical Demo Checklist (code-focused)

- Know where to change `validatePassword()` (`lib/view_models/auth_controller.dart`).
- Know how to add a UI field: edit view + controller + model + run `build_runner`.
- Know scheduling logic: `isScheduledForDate()` in `medicine_controller.dart`/`medicine_model.dart`.
- Know how notification payloads map to `MedicineActionDialog` (`lib/views/medicine_action_dialog.dart`).
- Know how Hive boxes are named and opened: `HiveService.init()`.
- Know how to run the app and run `build_runner`.

---

## Next Steps I can do for you

1. Run `flutter pub run build_runner build` here and report results.
2. Add a unit test file and run `flutter test`.
3. Patch a small UI change (e.g., change "Took It" button color) and run the app.

Tell me which of these you want me to do next, and I will proceed.

---

File created by GitHub Copilot assistant.

---

**File: lib/view_models/medicine_controller.dart**

Full `MedicineController` implementation (copy from source) — used by the app for schedule, logs, stock, notifications, and background action handling:

```dart
// lib/view_models/medicine_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_log_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class MedicineController extends GetxController with WidgetsBindingObserver {
  var medicines = <MedicineModel>[].obs;
  var isLoading = false.obs;

  // UI State for Add Form
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final stockController = TextEditingController();
  final customTypeController = TextEditingController();

  var selectedType = 'Tablet'.obs;
  var frequency = 'Daily'.obs;
  var reminderTimes = <TimeOfDay>[].obs;
  var selectedDays = <int>[].obs;

  // New Cyclic/Interval State
  var interval = 1.obs;
  var cycleOn = 21.obs;
  var cycleOff = 7.obs;
  var startDate = DateTime.now().obs;

  // Dashboard State
  var selectedDate = DateTime.now().obs;
  var logs = <MedicineLogModel>[].obs;

  final List<String> defaultTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Inhaler',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadMedicines();
    loadLogs();
    rescheduleAllNotifications(); // SRS-74: Reschedule on startup
    _autoMarkPreviousDayMissedDoses();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadLogs();
      _autoMarkPreviousDayMissedDoses();
    }
  }

  void loadMedicines() {
    medicines.value = HiveService.getAllMedicines();
  }

  void loadLogs() {
    logs.value = HiveService.getAllLogs();
  }

  Future<void> _autoMarkPreviousDayMissedDoses() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool anyAdded = false;

    for (final med in medicines) {
      for (int daysBack = 1; daysBack <= 7; daysBack++) {
        final pastDay = today.subtract(Duration(days: daysBack));
        if (!isScheduledForDate(med, pastDay)) continue;

        for (final reminderDT in med.reminderTimes) {
          final scheduledDT = DateTime(
            pastDay.year, pastDay.month, pastDay.day,
            reminderDT.hour, reminderDT.minute,
          );

          final alreadyLogged = logs.any((log) =>
              log.medicineId == med.medicineId &&
              log.scheduledTime.year == scheduledDT.year &&
              log.scheduledTime.month == scheduledDT.month &&
              log.scheduledTime.day == scheduledDT.day &&
              log.scheduledTime.hour == scheduledDT.hour &&
              log.scheduledTime.minute == scheduledDT.minute);

          if (alreadyLogged) continue;

          final missedLog = MedicineLogModel(
            logId:
                '${med.medicineId}_${scheduledDT.millisecondsSinceEpoch}_automiss',
            medicineId: med.medicineId,
            scheduledTime: scheduledDT,
            actualTime: scheduledDT,
            status: 'Skipped',
          );
          await HiveService.addLog(missedLog);
          anyAdded = true;
        }
      }

      if (!isScheduledForDate(med, today)) continue;

      for (final reminderDT in med.reminderTimes) {
        final scheduledDT = DateTime(
          today.year, today.month, today.day,
          reminderDT.hour, reminderDT.minute,
        );

        if (now.difference(scheduledDT).inHours < 2) continue;

        final alreadyLogged = logs.any((log) =>
            log.medicineId == med.medicineId &&
            log.scheduledTime.year == scheduledDT.year &&
            log.scheduledTime.month == scheduledDT.month &&
            log.scheduledTime.day == scheduledDT.day &&
            log.scheduledTime.hour == scheduledDT.hour &&
            log.scheduledTime.minute == scheduledDT.minute);

        if (alreadyLogged) continue;

        final missedLog = MedicineLogModel(
          logId:
              '${med.medicineId}_${scheduledDT.millisecondsSinceEpoch}_automiss',
          medicineId: med.medicineId,
          scheduledTime: scheduledDT,
          actualTime: scheduledDT,
          status: 'Skipped',
        );
        await HiveService.addLog(missedLog);
        anyAdded = true;
      }
    }

    if (anyAdded) loadLogs();
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  List<MedicineModel> get dailyMedicines {
    return medicines
        .where((med) => isScheduledForDate(med, selectedDate.value))
        .toList();
  }

  double getDailyProgress() {
    final todaysMeds = dailyMedicines;
    if (todaysMeds.isEmpty) return 0.0;

    int totalDoses = 0;
    int takenDoses = 0;

    for (var med in todaysMeds) {
      for (var time in med.reminderTimes) {
        totalDoses++;
        if (isTaken(med.medicineId, selectedDate.value, time)) {
          takenDoses++;
        }
      }
    }

    return totalDoses > 0 ? takenDoses / totalDoses : 0.0;
  }

  bool isTaken(String medId, DateTime date, DateTime timeSlot) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    return logs.any((log) =>
        log.medicineId == medId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute &&
        log.status == 'Taken');
  }

  String? getDoseStatus(String medId, DateTime date, DateTime timeSlot) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final log = logs.firstWhereOrNull((log) =>
        log.medicineId == medId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute);

    return log?.status;
  }

  Future<void> clearDoseLog(MedicineModel med, DateTime date, DateTime timeSlot) async {
    final dateKey = DateTime(date.year, date.month, date.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final logToRemove = logs.firstWhereOrNull((log) =>
        log.medicineId == med.medicineId &&
        log.scheduledTime.year == timeKey.year &&
        log.scheduledTime.month == timeKey.month &&
        log.scheduledTime.day == timeKey.day &&
        log.scheduledTime.hour == timeKey.hour &&
        log.scheduledTime.minute == timeKey.minute);

    if (logToRemove != null) {
      if (logToRemove.status == 'Taken') {
        med.stock++;
        await HiveService.updateMedicine(med);
        loadMedicines();
      }
      await HiveService.deleteLog(logToRemove.logId);
      loadLogs();
      Get.snackbar(
        "Cleared",
        "${med.name} status cleared",
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> markAsTaken(
      MedicineModel med, DateTime date, DateTime timeSlot) async {
    await clearDoseLog(med, date, timeSlot);

    final dateKey = DateTime(date.year, date.month, date.day);
    final scheduledTime = DateTime(dateKey.year, dateKey.month, dateKey.day,
        timeSlot.hour, timeSlot.minute);

    final log = MedicineLogModel(
      logId: const Uuid().v4(),
      medicineId: med.medicineId,
      scheduledTime: scheduledTime,
      actualTime: DateTime.now(),
      status: 'Taken',
    );

    await HiveService.addLog(log);
    loadLogs();

    if (med.stock > 0) {
      med.stock--;
      await HiveService.updateMedicine(med);
      loadMedicines();
      
      if (med.stock <= 5) {
        NotificationService.showLowStockNotification(med);
      }
    }

    Get.snackbar(
      "✓ Taken",
      "${med.name} marked as taken",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> markAsSkipped(MedicineModel med, DateTime scheduledTime) async {
    await clearDoseLog(med, scheduledTime, scheduledTime);

    final dateKey =
        DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day);
    final timeKey = DateTime(dateKey.year, dateKey.month, dateKey.day,
        scheduledTime.hour, scheduledTime.minute);

    final log = MedicineLogModel(
      logId: const Uuid().v4(),
      medicineId: med.medicineId,
      scheduledTime: timeKey,
      actualTime: DateTime.now(),
      status: 'Skipped',
    );

    await HiveService.addLog(log);
    loadLogs();
  }

  bool isScheduledForDate(MedicineModel med, DateTime date) {
    if (!med.isActive) return false;

    try {
      final target = DateTime(date.year, date.month, date.day);

      if (med.startDate == null) return _stockCoversDate(med, target);

      final start =
          DateTime(med.startDate!.year, med.startDate!.month, med.startDate!.day);
      final diffDays = target.difference(start).inDays;

      if (diffDays < 0) return false;

      final bool onSchedule;
      switch (med.frequencyType) {
        case 'Daily':
          onSchedule = true;
          break;
        case 'SpecificDays':
          onSchedule = med.specificDays?.contains(target.weekday) ?? false;
          break;
        case 'Interval':
          onSchedule = (diffDays % (med.interval ?? 1)) == 0;
          break;
        case 'Cyclic':
          final totalCycle = (med.cycleOnDays ?? 1) + (med.cycleOffDays ?? 0);
          final positionInCycle = diffDays % totalCycle;
          onSchedule = positionInCycle < (med.cycleOnDays ?? 1);
          break;
        default:
          return false;
      }

      if (!onSchedule) return false;

      return _stockCoversDate(med, target);
    } catch (e, st) {
      print('⚠️ isScheduledForDate error for ${med.name} on $date: $e');
      print(st);
      return false;
    }
  }

  bool _stockCoversDate(MedicineModel med, DateTime target) {
    try {
      final now = DateTime.now();
      final todayKey = DateTime(now.year, now.month, now.day);

      if (target.isBefore(todayKey)) return true;

      if (!target.isAfter(todayKey)) return med.stock > 0;

      if (med.stock <= 0) return false;

      final dosesPerDay = med.reminderTimes.length;
      int dosesBeforeTarget = 0;
      DateTime cursor = todayKey;

      while (cursor.isBefore(target)) {
        if (_isOnFrequencySchedule(med, cursor)) {
          dosesBeforeTarget += dosesPerDay;
          if (dosesBeforeTarget >= med.stock) return false;
        }
        cursor = cursor.add(const Duration(days: 1));
      }

      return true;
    } catch (e, st) {
      print('⚠️ _stockCoversDate error for ${med.name} on $target: $e');
      print(st);
      return false;
    }
  }

  bool _isOnFrequencySchedule(MedicineModel med, DateTime date) {
    try {
      if (med.startDate == null) return true;

      final target = DateTime(date.year, date.month, date.day);
      final start = DateTime(
          med.startDate!.year, med.startDate!.month, med.startDate!.day);
      final diffDays = target.difference(start).inDays;
      if (diffDays < 0) return false;

      switch (med.frequencyType) {
        case 'Daily':
          return true;
        case 'SpecificDays':
          return med.specificDays?.contains(target.weekday) ?? false;
        case 'Interval':
          return (diffDays % (med.interval ?? 1)) == 0;
        case 'Cyclic':
          final totalCycle = (med.cycleOnDays ?? 1) + (med.cycleOffDays ?? 0);
          return (diffDays % totalCycle) < (med.cycleOnDays ?? 1);
        default:
          return false;
      }
    } catch (e, st) {
      print('⚠️ _isOnFrequencySchedule error for ${med.name} on $date: $e');
      print(st);
      return false;
    }
  }

  Future<void> saveMedicine({String? id}) async {
    if (!_validate()) return;

    isLoading.value = true;
    try {
      String type = selectedType.value == 'Other'
          ? customTypeController.text.trim()
          : selectedType.value;

      final med = MedicineModel(
        medicineId: id ?? const Uuid().v4(),
        name: nameController.text.trim(),
        dosage: dosageController.text.trim(),
        type: type,
        stock: int.tryParse(stockController.text) ?? 0,
        reminderTimes: _toDateTimeList(reminderTimes),
        frequencyType: frequency.value,
        specificDays:
            frequency.value == 'SpecificDays' ? selectedDays.toList() : null,
        interval: frequency.value == 'Interval' ? interval.value : null,
        cycleOnDays: frequency.value == 'Cyclic' ? cycleOn.value : null,
        cycleOffDays: frequency.value == 'Cyclic' ? cycleOff.value : null,
        startDate: startDate.value,
        isActive: true,
      );

      if (id == null) {
        await HiveService.addMedicine(med);
        Get.back();
        Get.snackbar("Added", "${med.name} added to schedule!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await HiveService.updateMedicine(med);
        Get.back();
        Get.snackbar("Updated", "${med.name} details updated",
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      _rescheduleNotifications(med);
      loadMedicines();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleStatus(MedicineModel med) async {
    med.isActive = !med.isActive;
    await HiveService.updateMedicine(med);

    if (med.isActive) {
      _rescheduleNotifications(med);
      Get.snackbar("Alerts On", "Reminders enabled for ${med.name}",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      int baseId = med.medicineId.hashCode;
      for (int i = 0; i < 10; i++) {
        NotificationService.cancel(baseId + i);
      }
      Get.snackbar("Alerts Off", "Reminders disabled for ${med.name}",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
    medicines.refresh();
  }

  Future<void> updateMedicine(MedicineModel med) async {
    await HiveService.updateMedicine(med);
    medicines.refresh();
  }

  Future<void> completeMedicine(MedicineModel med) async {
    med.isActive = false;
    med.dateEnded = DateTime.now();
    await HiveService.updateMedicine(med);
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    medicines.refresh();
  }

  Future<void> reactivateMedicine(MedicineModel med) async {
    med.isActive = true;
    med.dateEnded = null;
    await HiveService.updateMedicine(med);
    _rescheduleNotifications(med);
    medicines.refresh();
  }

  Future<void> deleteMedicine(MedicineModel med) async {
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    medicines.remove(med);
    await HiveService.deleteMedicine(med.medicineId);
    Get.snackbar("Deleted", "${med.name} has been removed",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  List<MedicineModel> get sortedMedicines {
    List<MedicineModel> sorted = medicines.where((m) => m.isActive).toList();
    sorted.sort((a, b) {
      bool aLow = a.stock <= 5;
      bool bLow = b.stock <= 5;
      if (aLow && !bLow) return -1;
      if (!aLow && bLow) return 1;
      return 0;
    });
    return sorted;
  }

  Future<void> updateStock(MedicineModel med, int newQty) async {
    med.stock = newQty;
    await HiveService.updateMedicine(med);
    medicines.refresh();

    Get.snackbar(
      "Stock Updated",
      "${med.name} stock set to $newQty",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void _rescheduleNotifications(MedicineModel med) {
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }

    if (med.isActive) {
      for (int i = 0; i < med.reminderTimes.length; i++) {
        final timeOfDay = TimeOfDay.fromDateTime(med.reminderTimes[i]);

        if (med.frequencyType == 'Daily') {
          DateTime now = DateTime.now();
          DateTime scheduledDate = DateTime(
              now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
          if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }

          NotificationService.scheduleMedicine(
            id: baseId + i,
            medicineId: med.medicineId,
            name: med.name,
            dosage: med.dosage,
            time: scheduledDate,
            repeat: Repeat.daily,
          );
        } else {
          final nextTime = _getNextValidOccurrence(med, timeOfDay);
          if (nextTime != null) {
            NotificationService.scheduleMedicine(
              id: baseId + i,
              medicineId: med.medicineId,
              name: med.name,
              dosage: med.dosage,
              time: nextTime,
              repeat: Repeat.none,
            );
          }
        }
      }
    }
  }

  DateTime? _getNextValidOccurrence(MedicineModel med, TimeOfDay time) {
    DateTime now = DateTime.now();
    DateTime candidate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (candidate.isBefore(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    for (int i = 0; i < 365; i++) {
      if (isScheduledForDate(med, candidate)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return null;
  }

  Future<void> handleNotificationAction(
      String action, String medId, DateTime scheduledTime) async {
    print('📱 MedicineController.handleNotificationAction called');
    print('  Action: $action');
    print('  Medicine ID: $medId');
    print('  Scheduled Time: $scheduledTime');
    
    loadMedicines();
    loadLogs();

    final med = medicines.firstWhereOrNull((m) => m.medicineId == medId);
    if (med == null) {
      print('❌ Medicine not found!');
      return;
    }

    final now = DateTime.now();
    final normalizedTime = DateTime(
        now.year, now.month, now.day,
        scheduledTime.hour, scheduledTime.minute);

    if (action == 'take') {
      print('  → Executing TAKE action');
      await markAsTaken(med, normalizedTime, normalizedTime);
      _rescheduleNotifications(med);
      Get.snackbar(
        '✓ Taken',
        '${med.name} marked as taken',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      print('  ✅ TAKE action completed');
    } else if (action == 'miss') {
      print('  → Executing MISS action');
      await markAsSkipped(med, normalizedTime);
      Get.snackbar(
        '✗ Missed',
        '${med.name} marked as missed',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      print('  ✅ MISS action completed');
    } else if (action == 'snooze') {
      print('  → Executing SNOOZE action');
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      int id = med.medicineId.hashCode + DateTime.now().millisecondsSinceEpoch;

      await NotificationService.scheduleMedicine(
        id: id,
        medicineId: med.medicineId,
        name: med.name,
        dosage: med.dosage,
        time: snoozeTime,
        repeat: Repeat.none,
      );

      Get.snackbar(
        '⏰ Snoozed',
        'Reminding you in 10 minutes',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade900,
      );
      print('  ✅ SNOOZE action completed - next reminder at $snoozeTime');
    } else {
      print('❌ Unknown action: $action');
    }
  }

  Future<void> rescheduleAllNotifications() async {
    for (var med in medicines) {
      _rescheduleNotifications(med);
    }
  }

  bool _validate() {
    if (nameController.text.isEmpty) {
      Get.snackbar("Missing Info", "Please enter medicine name",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (dosageController.text.trim().isEmpty) {
      Get.snackbar("Missing Info", "Please enter dosage (e.g. 500mg)",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (frequency.value == 'SpecificDays' && selectedDays.isEmpty) {
      Get.snackbar("Missing Info", "Please select at least one day",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (reminderTimes.isEmpty) {
      Get.snackbar("Missing Info", "Set at least one reminder time",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  List<DateTime> _toDateTimeList(List<TimeOfDay> times) {
    final now = DateTime.now();
    return times
        .map((t) => DateTime(now.year, now.month, now.day, t.hour, t.minute))
        .toList();
  }
}
```

---

**File: lib/data/services/notification_service.dart**

Key parts of `NotificationService` including background handlers, scheduling, channel creation, and foreground action handling. (Copied from source.)

```dart
// lib/data/services/notification_service.dart
import 'dart:ui' show Color;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import '../../views/medicine_action_dialog.dart';
import '../models/notification_settings_model.dart';
import '../models/medicine_log_model.dart';
import '../models/medicine_model.dart';
import 'hive_service.dart';
import '../../utils/platform_utils.dart';
import '../../view_models/medicine_controller.dart';

@pragma('vm:entry-point')
Future<void> _onNotificationTappedBackground(
    NotificationResponse response) async {
  print('🔔 BG notification action: ${response.actionId}');

  final payload = response.payload;
  final actionId = response.actionId;
  if (payload == null || actionId == null) return;

  final parts = payload.split('|');
  if (parts.length != 2) return;

  final medicineId = parts[0];
  final DateTime scheduledTime;
  try {
    scheduledTime = DateTime.parse(parts[1]);
  } catch (_) {
    return;
  }

  try {
    final plugin = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(const InitializationSettings(android: androidInit));
    if (response.id != null) {
      await plugin.cancel(response.id!);
      print('🗑️ BG: Notification ${response.id} dismissed');
    }
  } catch (e) {
    print('⚠️ BG: Could not dismiss notification: $e');
  }

  try {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MedicineModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MedicineLogModelAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(NotificationSettingsModelAdapter());
    }

    final logBox = await Hive.openBox<MedicineLogModel>(HiveService.logBoxName);
    final medBox =
        await Hive.openBox<MedicineModel>(HiveService.medicineBoxName);

    switch (actionId) {
      case 'take':
        final now = DateTime.now();
        final normalizedTake = DateTime(
            now.year, now.month, now.day,
            scheduledTime.hour, scheduledTime.minute);

        MedicineLogModel? existingLog;
        for (var l in logBox.values) {
          if (l.medicineId == medicineId &&
              l.scheduledTime.year == normalizedTake.year &&
              l.scheduledTime.month == normalizedTake.month &&
              l.scheduledTime.day == normalizedTake.day &&
              l.scheduledTime.hour == normalizedTake.hour &&
              l.scheduledTime.minute == normalizedTake.minute) {
            existingLog = l;
            break;
          }
        }

        if (existingLog != null) {
          if (existingLog.status == 'Taken') break;
          if (existingLog.status == 'Skipped') {
            await logBox.delete(existingLog.logId);
          }
        }

        final log = MedicineLogModel(
          logId:
              '${medicineId}_${normalizedTake.millisecondsSinceEpoch}_bgtake',
          medicineId: medicineId,
          scheduledTime: normalizedTake,
          actualTime: DateTime.now(),
          status: 'Taken',
        );
        await logBox.put(log.logId, log);

        MedicineModel? medTake;
        for (final m in medBox.values) {
          if (m.medicineId == medicineId) { medTake = m; break; }
        }
        if (medTake != null && medTake.stock > 0) {
          medTake.stock--;
          await medBox.put(medTake.medicineId, medTake);
        }
        print('✅ BG: Dose marked as Taken for $medicineId');
        break;

      case 'miss':
        final nowMiss = DateTime.now();
        final normalizedMiss = DateTime(
            nowMiss.year, nowMiss.month, nowMiss.day,
            scheduledTime.hour, scheduledTime.minute);

        MedicineLogModel? existingLogMiss;
        for (var l in logBox.values) {
          if (l.medicineId == medicineId &&
              l.scheduledTime.year == normalizedMiss.year &&
              l.scheduledTime.month == normalizedMiss.month &&
              l.scheduledTime.day == normalizedMiss.day &&
              l.scheduledTime.hour == normalizedMiss.hour &&
              l.scheduledTime.minute == normalizedMiss.minute) {
            existingLogMiss = l;
            break;
          }
        }

        if (existingLogMiss != null) {
          if (existingLogMiss.status == 'Skipped') break;
          if (existingLogMiss.status == 'Taken') {
            await logBox.delete(existingLogMiss.logId);
            MedicineModel? medMiss;
            for (final m in medBox.values) {
              if (m.medicineId == medicineId) { medMiss = m; break; }
            }
            if (medMiss != null) {
              medMiss.stock++;
              await medBox.put(medMiss.medicineId, medMiss);
            }
          }
        }

        final logMiss = MedicineLogModel(
          logId:
              '${medicineId}_${normalizedMiss.millisecondsSinceEpoch}_bgmiss',
          medicineId: medicineId,
          scheduledTime: normalizedMiss,
          actualTime: DateTime.now(),
          status: 'Skipped',
        );
        await logBox.put(logMiss.logId, logMiss);
        print('❌ BG: Dose marked as Skipped for $medicineId');
        break;

      case 'snooze':
        MedicineModel? med;
        for (final m in medBox.values) {
          if (m.medicineId == medicineId) {
            med = m;
            break;
          }
        }

        final settingsBox = await Hive.openBox<NotificationSettingsModel>(
            HiveService.notificationSettingsBoxName);
        final settings = settingsBox.get('user_notification_settings') ??
            NotificationSettingsModel();

        await _scheduleSnoozeBg(
          medicineId: medicineId,
          originalTime: scheduledTime,
          name: med?.name ?? 'Medicine',
          dosage: med?.dosage ?? '',
          settings: settings,
        );
        print('⏰ BG: Snoozed for $medicineId — reminder in 10 min');
        break;

      default:
        print('⚠️ BG: Unknown action $actionId');
    }
  } catch (e, st) {
    print('❌ BG notification handler error: $e\n$st');
  }
}

// _scheduleSnoozeBg and NotificationService class omitted for brevity in this guide
// (the full source is in lib/data/services/notification_service.dart)
```

---

**File: lib/data/services/hive_service.dart**

Core Hive helpers (open boxes, register adapters, CRUD helpers). Use these methods when you need to persist or read domain objects:

```dart
// lib/data/services/hive_service.dart
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine_model.dart';
import '../models/medicine_log_model.dart';
import '../models/appointment_model.dart';
import '../models/journal_model.dart';
import '../models/report_model.dart';
import '../models/streak_model.dart';
import '../models/chat_message_model.dart';
import '../models/notification_settings_model.dart';

class HiveService {
  static const String _userBoxName = "userBox";
  static const String _medicineBoxName = "medicineBox";
  static const String _logBoxName = "medicineLogBox";
  static const String _keyCurrentUser = "current_user";
  static const String _appointmentBoxName = "appointmentBox";
  static const String _journalBoxName = "journalBox";
  static const String _reportBoxName = "reportBox";
  static const String _streakBoxName =
      "streakBox";
  static const String _chatBoxName = "chatBox";
  static const String _notificationSettingsBoxName =
      "notificationSettingsBox";

  static const String medicineBoxName = _medicineBoxName;
  static const String logBoxName = _logBoxName;
  static const String notificationSettingsBoxName = _notificationSettingsBoxName;

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1))
      Hive.registerAdapter(MedicineModelAdapter());
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(MedicineLogModelAdapter());
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(AppointmentModelAdapter());
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(JournalModelAdapter());
    if (!Hive.isAdapterRegistered(5))
      Hive.registerAdapter(ReportModelAdapter());
    if (!Hive.isAdapterRegistered(6))
      Hive.registerAdapter(StreakModelAdapter());
    if (!Hive.isAdapterRegistered(7))
      Hive.registerAdapter(ChatMessageModelAdapter());
    if (!Hive.isAdapterRegistered(8))
      Hive.registerAdapter(
          NotificationSettingsModelAdapter());

    await Hive.openBox(_userBoxName);
    await Hive.openBox<MedicineModel>(_medicineBoxName);
    await Hive.openBox<MedicineLogModel>(_logBoxName);
    await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    await Hive.openBox<JournalModel>(_journalBoxName);
    await Hive.openBox<ReportModel>(_reportBoxName);
    await Hive.openBox<StreakModel>(_streakBoxName);
    await Hive.openBox<ChatMessageModel>(_chatBoxName);
    await Hive.openBox<NotificationSettingsModel>(_notificationSettingsBoxName);
  }

  static Future<void> addMedicine(MedicineModel medicine) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.put(medicine.medicineId, medicine);
  }

  static List<MedicineModel> getAllMedicines() {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    return box.values.toList();
  }

  static Future<void> updateMedicine(MedicineModel medicine) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.put(medicine.medicineId, medicine);
  }

  static Future<void> deleteMedicine(String id) async {
    var box = Hive.box<MedicineModel>(_medicineBoxName);
    await box.delete(id);
  }

  static Future<void> addLog(MedicineLogModel log) async {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    await box.put(log.logId, log);
  }

  static List<MedicineLogModel> getAllLogs() {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    return box.values.toList();
  }

  static Future<void> deleteLog(String logId) async {
    var box = Hive.box<MedicineLogModel>(_logBoxName);
    await box.delete(logId);
  }

  static Future<void> saveNotificationSettings(
      NotificationSettingsModel settings) async {
    var box = Hive.box<NotificationSettingsModel>(_notificationSettingsBoxName);
    await box.put('user_notification_settings', settings);
  }

  static NotificationSettingsModel? getNotificationSettings() {
    var box = Hive.box<NotificationSettingsModel>(_notificationSettingsBoxName);
    return box.get('user_notification_settings');
  }
}
```

---

**File: lib/data/services/gemini_service.dart**

Gemini wrapper used by chat features (reads API key from `.env`):

```dart
// lib/data/services/gemini_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _modelId = 'gemini-2.5-flash';

  static String get apiKey {
    final key = dotenv.maybeGet('GEMINI_API_KEY') ?? '';
    if (key.isEmpty || key == 'your_gemini_api_key_here') {
      throw StateError(
        'GEMINI_API_KEY is not set. '
        'Copy .env.example to .env and add your Gemini API key.',
      );
    }
    return key;
  }

  static GenerativeModel buildChatModel({
    List<SafetySetting>? safetySettings,
    String? systemInstruction,
    int maxOutputTokens = 300,
    double temperature = 0.7,
  }) {
    return GenerativeModel(
      model: _modelId,
      apiKey: apiKey,
      safetySettings: safetySettings ?? _defaultSafetySettings,
      generationConfig: GenerationConfig(
        maxOutputTokens: maxOutputTokens,
        temperature: temperature,
      ),
      systemInstruction: systemInstruction != null
          ? Content.system(systemInstruction)
          : null,
    );
  }

  static GenerativeModel buildContentModel({
    double temperature = 0.9,
  }) {
    return GenerativeModel(
      model: _modelId,
      apiKey: apiKey,
      safetySettings: _defaultSafetySettings,
      generationConfig: GenerationConfig(temperature: temperature),
    );
  }

  static Future<String?> generateText(String prompt) async {
    try {
      final model = buildContentModel();
      final response =
          await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      return (text != null && text.trim().isNotEmpty) ? text.trim() : null;
    } catch (e) {
      debugPrint('[GeminiService] generateText error: $e');
      return null;
    }
  }

  static final List<SafetySetting> _defaultSafetySettings = [
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
  ];
}
```

---

Progress: appended controller/service extracts. Next I'll include any remaining core controllers (e.g., `auth_controller.dart`) if you want — confirm and I'll continue. 

---

**File: lib/view_models/auth_controller.dart**

Auth handling: sign up, login, Google sign-in, password reset, and password change.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/realtime_database_service.dart';
import '../data/models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  var isLoading = false.obs;
  // FIX 1: Actual Password Validation Logic (SRS-3, SRS-21)
  // This was returning "null" before, effectively disabling validation.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Min 8 characters required";
    // Regex for 1 Uppercase & 1 Number
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must have 1 Uppercase & 1 Number";
    }
    return null;
  }

  // Sign Up Logic
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // SRS-22: Confirm Password Match (Double check in controller)
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(email, password, name);

      if (user != null) {
        // FIX 2: Send Verification Email (SRS-5)
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Note: We DO NOT save the session here because the user must login first.
        // SRS-7: Redirect to Login Screen, NOT Profile
        Get.offAllNamed('/login');

        Get.snackbar(
            "Success", "Account created! Verification link sent to $email",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Login Logic
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        await user.reload();
        if (!user.emailVerified) {
          Get.snackbar("Email Verification Required",
              "Please verify your email first. Check your inbox.",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 5));
          return;
        }

        await HiveService.saveUserSession(user.uid);
        Get.offAllNamed('/home'); // Correct navigation after login
        Get.snackbar("Welcome Back", "Login Successful",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Google Login
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      // 1. Trigger Google Sign In Flow
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // 2. Save Session Locally
        await HiveService.saveUserSession(user.uid);

        // 3. SRS-27: Check if User Profile exists in Database
        final existingUser = await _dbService.getUser(user.uid);

        if (existingUser == null) {
          // PROFILE DOES NOT EXIST -> Create it now (SRS-27)
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            photoUrl: user.photoURL,
            // Initialize other fields as null/empty for now
          );

          // Save to Firebase Realtime DB
          await _dbService.saveUser(newUser);

          // Save to Hive for Offline Access
          await HiveService.saveUserProfile(newUser.toHiveMap());
        } else {
          // PROFILE EXISTS -> Just sync it to Hive
          await HiveService.saveUserProfile(existingUser.toHiveMap());
        }

        // 4. Redirect to Home (SRS-29)
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Google Sign-In Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.back();
      Get.snackbar("Email Sent", "Check your inbox for reset link",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Change Password
  Future<void> updatePassword(
      String currentPass, String newPass, String confirmPass) async {
    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    // Re-use the validation logic
    String? error = validatePassword(newPass);
    if (error != null) {
      Get.snackbar("Weak Password", error,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.changePassword(currentPass, newPass);
      Get.back();
      Get.snackbar("Success", "Password updated successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

**File: lib/view_models/profile_controller.dart**

Profile and health record management: image pick/compression, BMI live update, cloud sync, and local edits.

```dart
// lib/view_models/profile_controller.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/realtime_database_service.dart';
import '../data/services/hive_service.dart';
import '../data/models/user_model.dart';

class ProfileController extends GetxController {
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  var isLoading = false.obs;

  // Edit Fields
  var pickedImage = Rxn<XFile>();
  var removePhoto = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedGender = 'Male'.obs;
  var selectedBloodGroup = 'A+'.obs;

  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // Live BMI
  final RxString liveBMI = '0.0'.obs;

  void _updateBMI() {
    double h = double.tryParse(heightController.text) ?? 0;
    double w = double.tryParse(weightController.text) ?? 0;
    if (h <= 0 || w <= 0) {
      liveBMI.value = '0.0';
    } else {
      liveBMI.value = (w / ((h / 100) * (h / 100))).toStringAsFixed(1);
    }
  }

  @override
  void onInit() {
    super.onInit();
    heightController.addListener(_updateBMI);
    weightController.addListener(_updateBMI);
    loadProfile();
  }

  void loadProfile() async {
    isLoading.value = true;
    String? uid = _auth.currentUser?.uid ?? HiveService.getUserId();

    if (uid == null) {
      isLoading.value = false;
      return;
    }

    // 1. Local Load (Instant)
    var localData = HiveService.getUserProfile();
    if (localData != null) {
      currentUser.value = UserModel.fromMap(localData);
    }

    // 2. Cloud Sync
    if (_auth.currentUser != null) {
      try {
        UserModel? cloudUser = await _dbService.getUser(uid);

        if (cloudUser != null) {
          // User exists, update local
          currentUser.value = cloudUser;
          await HiveService.saveUserProfile(cloudUser.toHiveMap());
        } else {
          // SRS-27: Handle New Google User (Auto-Create Profile)
          // If they don't exist in DB, create a default profile now
          UserModel newUser = UserModel(
            uid: uid,
            email: _auth.currentUser!.email ?? '',
            fullName: _auth.currentUser!.displayName ?? 'New User',
          );

          await _dbService.saveUser(newUser); // Save to Cloud
          await HiveService.saveUserProfile(newUser.toHiveMap()); // Save Local
          currentUser.value = newUser;
        }
      } catch (e) {
        print("Sync error: $e");
      }
    }
    isLoading.value = false;
  }

  void prepareEditData() {
    final user = currentUser.value;
    removePhoto.value = false;
    if (user != null) {
      nameController.text = user.fullName;
      heightController.text = user.height?.toString() ?? '';
      weightController.text = user.weight?.toString() ?? '';
      selectedDate.value = user.dateOfBirth;
      if (user.gender != null) selectedGender.value = user.gender!;
      if (user.bloodGroup != null) selectedBloodGroup.value = user.bloodGroup!;
      _updateBMI();
    }
  }

  Future<void> updateProfile() async {
    if (currentUser.value == null) return;

    isLoading.value = true;
    try {
      UserModel updatedUser = UserModel(
        uid: currentUser.value!.uid,
        email: currentUser.value!.email,
        fullName: nameController.text.trim(),
        photoUrl: removePhoto.value
            ? ''
            : pickedImage.value?.path ?? currentUser.value?.photoUrl,
        gender: selectedGender.value,
        dateOfBirth: selectedDate.value,
        bloodGroup: selectedBloodGroup.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        allergies: currentUser.value!.allergies,
        chronicIllnesses: currentUser.value!.chronicIllnesses,
        restraints: currentUser.value!.restraints,
      );

      await _dbService.saveUser(updatedUser);
      await HiveService.saveUserProfile(updatedUser.toHiveMap());

      currentUser.value = updatedUser;
      Get.back();
      Get.snackbar(
        "Success",
        "Profile updated!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (!_isSupportedImage(image.path)) {
      Get.snackbar(
        'Unsupported Image',
        'Please select a JPG, JPEG, PNG, or WEBP image.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final XFile? compressedImage = await _compressImage(image);
    if (compressedImage != null) {
      pickedImage.value = compressedImage;
      removePhoto.value = false;
    } else {
      Get.snackbar(
        'Image Error',
        'Could not process the selected image. Please try another photo.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _isSupportedImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  Future<XFile?> _compressImage(XFile image) async {
    try {
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      final resized = img.copyResize(decoded, width: 800);
      final encoded = img.encodeJpg(resized, quality: 85);
      final tempFile = File(
          '${Directory.systemTemp.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(encoded);
      return XFile(tempFile.path);
    } catch (e) {
      print('Compress error: $e');
      return null;
    }
  }

  void removeImage() {
    pickedImage.value = null;
    removePhoto.value = true;
  }

  @override
  void onClose() {
    heightController.removeListener(_updateBMI);
    weightController.removeListener(_updateBMI);
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }

  Future<void> logout() async {
    await _auth.signOut();
    await HiveService.clearSession();
    Get.offAllNamed('/login');
  }

  bool get isSocialLogin {
    if (_auth.currentUser == null) return false;
    return _auth.currentUser!.providerData.any(
      (u) => u.providerId == 'google.com',
    );
  }

  // ================= HEALTH RECORDS (HIVE ONLY) =================

  Future<void> addAllergy(String allergy) async {
    if (currentUser.value == null || allergy.trim().isEmpty) return;
    currentUser.update((user) {
      user?.allergies.add(allergy.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeAllergy(String allergy) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.allergies.remove(allergy);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> addIllness(String illness) async {
    if (currentUser.value == null || illness.trim().isEmpty) return;
    currentUser.update((user) {
      user?.chronicIllnesses.add(illness.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeIllness(String illness) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.chronicIllnesses.remove(illness);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> addRestraint(String restraint) async {
    if (currentUser.value == null || restraint.trim().isEmpty) return;
    currentUser.update((user) {
      user?.restraints.add(restraint.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }

  Future<void> removeRestraint(String restraint) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.restraints.remove(restraint);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
}
```

---

**File: lib/view_models/appointment_controller.dart**

Appointment scheduling, filtering, reminders, and recurring appointment handling.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/appointment_model.dart';
import '../data/models/notification_settings_model.dart' as import_models;
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';

class AppointmentController extends GetxController {
  var appointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var filterCategory = 'All'.obs;
  var filterDate = Rxn<DateTime>();

  // Form Input Controllers
  final doctorController = TextEditingController();
  final notesController = TextEditingController();

  // Form State
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var selectedCategory = 'General'.obs;
  var reminderOption = 60.obs; // Default 1 hour before
  var isRecurring = false.obs; // SRS-113
  var recurringFrequency = 'Weekly'.obs; // SRS-113 ('Weekly' or 'Monthly')

  final List<String> categories = [
    'General',
    'Dentist',
    'Cardiology',
    'Dermatology',
    'Therapy',
    'Other'
  ];

  final List<String> recurringFrequencies = ['Weekly', 'Monthly'];

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  void loadAppointments() {
    var all = HiveService.getAllAppointments();
    // SRS-109: Sort by date (Upcoming first)
    all.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    appointments.value = all;
  }

  // SRS-109: UI Helper lists
  List<AppointmentModel> get upcomingAppointments => _applyFilters(appointments
      .where((a) => !a.isCompleted && a.dateTime.isAfter(DateTime.now()))
      .toList(), sortingDesc: false);

  List<AppointmentModel> get historyAppointments => _applyFilters(appointments
      .where((a) => a.isCompleted || a.dateTime.isBefore(DateTime.now()))
      .toList(), sortingDesc: true);

  List<AppointmentModel> _applyFilters(List<AppointmentModel> items,
      {required bool sortingDesc}) {
    final query = searchQuery.value.toLowerCase().trim();
    final selectedCat = filterCategory.value;
    final selectedDt = filterDate.value;

    final filtered = items.where((apt) {
      if (selectedCat != 'All' && apt.category != selectedCat) {
        return false;
      }
      if (selectedDt != null) {
        if (apt.dateTime.year != selectedDt.year ||
            apt.dateTime.month != selectedDt.month ||
            apt.dateTime.day != selectedDt.day) {
          return false;
        }
      }
      if (query.isEmpty) return true;
      final dateLabel =
          '${apt.dateTime.day.toString().padLeft(2, '0')} ${apt.dateTime.month} ${apt.dateTime.year}';
      return apt.doctorName.toLowerCase().contains(query) ||
          apt.category.toLowerCase().contains(query) ||
          dateLabel.contains(query);
    }).toList();

    filtered.sort((a, b) => sortingDesc
        ? b.dateTime.compareTo(a.dateTime)
        : a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void setFilterCategory(String category) {
    filterCategory.value = category;
  }

  void setFilterDate(DateTime? date) {
    filterDate.value = date;
  }

  void clearFilters() {
    searchQuery.value = '';
    filterCategory.value = 'All';
    filterDate.value = null;
  }

  // --- ACTIONS ---

  Future<void> saveAppointment({String? id}) async {
    if (doctorController.text.isEmpty) {
      Get.snackbar("Error", "Doctor name is required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      // Combine Date + Time
      final dt = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          selectedTime.value.hour,
          selectedTime.value.minute);

      final newApt = AppointmentModel(
        id: id ?? const Uuid().v4(),
        doctorName: doctorController.text.trim(),
        category: selectedCategory.value,
        dateTime: dt,
        reminderMinutes: reminderOption.value > 0 ? reminderOption.value : null,
        visitNotes: notesController.text.trim(),
        isCompleted: false,
        isRecurring: reminderOption.value > 0 && isRecurring.value,
        recurringFrequency: (reminderOption.value > 0 && isRecurring.value)
            ? recurringFrequency.value
            : null,
      );

      if (id == null) {
        await HiveService.addAppointment(newApt); // Add
        Get.back();
        Get.snackbar("Success", "Appointment Scheduled!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await HiveService.updateAppointment(newApt); // Update
        Get.back();
        Get.snackbar("Success", "Appointment Updated!",
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      // SRS-112: Schedule Notification
      _scheduleAlert(newApt);

      loadAppointments();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Delete an appointment by ID
  Future<void> deleteAppointment(String id) async {
    // Immediately remove from the observable list so any Obx rebuild
    // triggered during the async Hive delete cannot re-insert the already-
    // dismissed Dismissible widget and cause the brief red error screen.
    appointments.removeWhere((a) => a.id == id);
    NotificationService.cancel(id.hashCode);
    await HiveService.deleteAppointment(id);
    loadAppointments();
  }

  // SRS-111: Manual Complete
  Future<void> markCompleted(AppointmentModel apt) async {
    apt.isCompleted = true;
    await HiveService.updateAppointment(apt);
    NotificationService.cancel(apt.id.hashCode); // Cancel reminder
    loadAppointments();
    Get.snackbar("Completed", "Moved to history");
  }

  void _scheduleAlert(AppointmentModel apt, {bool showError = true}) {
    // 1. Cancel old alert first
    NotificationService.cancel(apt.id.hashCode);

    // 2. Schedule new if enabled
    if (apt.reminderMinutes != null && !apt.isCompleted) {
      final triggerTime =
          apt.dateTime.subtract(Duration(minutes: apt.reminderMinutes!));

      if (triggerTime.isAfter(DateTime.now())) {
        // SRS-113: Determine repeat interval for recurring reminders
        DateTimeComponents? repeatComponents;
        if (apt.isRecurring) {
          if (apt.recurringFrequency == 'Weekly') {
            repeatComponents = DateTimeComponents.dayOfWeekAndTime;
          } else if (apt.recurringFrequency == 'Monthly') {
            repeatComponents = DateTimeComponents.dayOfMonthAndTime;
          }
        }

        final settings = HiveService.getNotificationSettings() ??
            import_models.NotificationSettingsModel();

        NotificationService.scheduleNotification(
          id: apt.id.hashCode,
          title: "Appointment: ${apt.doctorName}",
          body: apt.isRecurring
              ? "${apt.recurringFrequency} visit reminder — ${apt.reminderMinutes} min until your appointment."
              : "Your appointment is in ${apt.reminderMinutes} minutes.",
          scheduledTime: triggerTime,
          useShortSound: settings.useShortForAppointments,
          matchDateTimeComponents: repeatComponents,
        );
      } else if (showError) {
        // UC-31 Extension 4a: Reminder time is already in the past
        Get.snackbar(
          "Invalid Reminder Time",
          "The reminder time has already passed. Please choose a later appointment date or a shorter lead time.",
          backgroundColor: const Color(0xFFF59E0B),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  // --- FORM HELPERS (Pre-fill data for Edit) ---
  void prepareEdit(AppointmentModel apt) {
    doctorController.text = apt.doctorName;
    notesController.text = apt.visitNotes ?? "";
    selectedCategory.value = apt.category;
    selectedDate.value = apt.dateTime;
    selectedTime.value = TimeOfDay.fromDateTime(apt.dateTime);
    reminderOption.value = apt.reminderMinutes ?? 0;
    isRecurring.value = apt.isRecurring;
    recurringFrequency.value = apt.recurringFrequency ?? 'Weekly';
  }

  /// Called when notification sound settings change — cancel & reschedule all
  /// active appointment reminders so they use the new sound channel.
  Future<void> rescheduleAllNotifications() async {
    for (final apt in appointments) {
      if (!apt.isCompleted) {
        _scheduleAlert(apt, showError: false);
      }
    }
  }

  void clearForm() {
    doctorController.clear();
    notesController.clear();
    selectedCategory.value = 'General';
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
    reminderOption.value = 60;
    isRecurring.value = false;
    recurringFrequency.value = 'Weekly';
  }
}
```

---

Appended the three controllers. I'll now update the TODO list to mark these as completed. 

---

**Core Models (click to open)**

- Medicine model: [lib/data/models/medicine_model.dart](lib/data/models/medicine_model.dart#L1-L80)
- Medicine log model: [lib/data/models/medicine_log_model.dart](lib/data/models/medicine_log_model.dart#L1-L80)
- User model: [lib/data/models/user_model.dart](lib/data/models/user_model.dart#L1-L120)
- Appointment model: [lib/data/models/appointment_model.dart](lib/data/models/appointment_model.dart#L1-L120)
- Notification settings: [lib/data/models/notification_settings_model.dart](lib/data/models/notification_settings_model.dart#L1-L160)

Below are the exact model definitions copied from the workspace for quick reference.

```dart
// lib/data/models/medicine_model.dart
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
```

```dart
// lib/data/models/medicine_log_model.dart
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
```

```dart
// lib/data/models/user_model.dart
class UserModel {
  String uid;
  String email;
  String
      fullName; // Matches 'name' in Hive Schema, 'fullName' in Firebase Schema
  String? photoUrl; // Matches 'photoPath' in Hive Schema

  // Personal Details
  String? gender;
  DateTime? dateOfBirth;

  // Health Metrics
  String? bloodGroup;
  double? height; // cm
  double? weight; // kg

  // Local-Only Health Records (SRS-89, SRS-95, SRS-96)
  List<String> allergies;
  List<String> chronicIllnesses;
  List<String> restraints;

  // BMI is calculated, but strictly stored as 'bmi' double in schemas

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.height,
    this.weight,
    this.allergies = const [],
    this.chronicIllnesses = const [],
    this.restraints = const [],
  });

  // Auto-calculate BMI (SRS-34, SRS-52)
  double get bmiValue {
    if (height == null || weight == null || height == 0) return 0.0;
    double heightInMeters = height! / 100;
    return double.parse(
        (weight! / (heightInMeters * heightInMeters)).toStringAsFixed(1));
  }

  // Map for Firebase (Schema Compliance)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch, // Stored as Timestamp
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'bmi': bmiValue, // Explicitly storing BMI as per schema
    };
  }

  // Map for Hive 'userBox' (Schema Compliance + Offline Data)
  Map<String, dynamic> toHiveMap() {
    return {
      'uid': uid,
      'name': fullName, // Hive schema uses 'name'
      'bmi': bmiValue,
      'photoPath': photoUrl,
      // We store extra fields to ensure the "View Profile" works offline
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      // Local Only
      'allergies': allergies,
      'chronicIllnesses': chronicIllnesses,
      'restraints': restraints,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? map['photoPath'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['dateOfBirth']) // From Firebase Timestamp
          : (map['dateOfBirth'] != null
              ? DateTime.tryParse(map['dateOfBirth'].toString())
              : null), // From Hive String
      bloodGroup: map['bloodGroup'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      allergies: List<String>.from(map['allergies'] ?? []),
      chronicIllnesses: List<String>.from(map['chronicIllnesses'] ?? []),
      restraints: List<String>.from(map['restraints'] ?? []),
    );
  }
}
```

```dart
// lib/data/models/appointment_model.dart
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
```

```dart
// lib/data/models/notification_settings_model.dart
import 'package:hive/hive.dart';

part 'notification_settings_model.g.dart';

@HiveType(typeId: 8)
class NotificationSettingsModel {
  @HiveField(0)
  String shortSoundName;

  @HiveField(1)
  String longSoundName;

  @HiveField(2)
  bool useShortForMedicine;

  @HiveField(3)
  bool useShortForAppointments;

  NotificationSettingsModel({
    this.shortSoundName = 'mixkit_bell_notification_933', // User's short sound
    this.longSoundName =
        'mixkit_marimba_waiting_ringtone_1360', // User's long sound
    this.useShortForMedicine = true,
    this.useShortForAppointments = false,
  });

  // Convert to Map for debugging/logging
  Map<String, dynamic> toMap() {
    return {
      'shortSoundName': shortSoundName,
      'longSoundName': longSoundName,
      'useShortForMedicine': useShortForMedicine,
      'useShortForAppointments': useShortForAppointments,
    };
  }

  // Create from Map
  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      shortSoundName: map['shortSoundName'] ?? 'mixkit_bell_notification_933',
      longSoundName: map['longSoundName'] ?? 'mixkit_marimba_waiting_ringtone_1360',
      useShortForMedicine: map['useShortForMedicine'] ?? true,
      useShortForAppointments: map['useShortForAppointments'] ?? false,
    );
  }

  // Copy with method for easy updates
  NotificationSettingsModel copyWith({
    String? shortSoundName,
    String? longSoundName,
    bool? useShortForMedicine,
    bool? useShortForAppointments,
  }) {
    return NotificationSettingsModel(
      shortSoundName: shortSoundName ?? this.shortSoundName,
      longSoundName: longSoundName ?? this.longSoundName,
      useShortForMedicine: useShortForMedicine ?? this.useShortForMedicine,
      useShortForAppointments:
          useShortForAppointments ?? this.useShortForAppointments,
    );
  }
}
```

---

Models appended. Next I'll read the remaining controllers (chat/settings/schedule/report/notification_settings/wellness/login_view_controller/signup_view_controller/analytics) and append them with clickable links; proceeding to gather those files now.

---

**Controllers & Helpers (click to open)**

- Chat: [lib/view_models/chat_controller.dart](lib/view_models/chat_controller.dart)
- Settings: [lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart)
- Schedule: [lib/view_models/schedule_controller.dart](lib/view_models/schedule_controller.dart)
- Report: [lib/view_models/report_controller.dart](lib/view_models/report_controller.dart)
- Notification Settings: [lib/view_models/notification_settings_controller.dart](lib/view_models/notification_settings_controller.dart)
- Wellness: [lib/view_models/wellness_controller.dart](lib/view_models/wellness_controller.dart)
- Login UI controller: [lib/view_models/login_view_controller.dart](lib/view_models/login_view_controller.dart)
- Signup UI controller: [lib/view_models/signup_view_controller.dart](lib/view_models/signup_view_controller.dart)
- Analytics: [lib/view_models/analytics_controller.dart](lib/view_models/analytics_controller.dart)

Below are the exact controller sources extracted from the workspace.

```dart
// lib/view_models/chat_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/safety_rules_service.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isInitialized = false.obs;
  var initError = ''.obs;

  GenerativeModel? _model;
  ChatSession? _chat;

  // UC-41 / SRS-133 / SRS-134: client-side safety pre-filter
  final SafetyRulesService _safetyRules = SafetyRulesService();

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _initGemini();
    // SRS-134: Start listening for backend rule updates so changes take
    // effect on the next message without requiring an app update.
    _safetyRules.startListening();
  }

  @override
  void onClose() {
    _safetyRules.stopListening();
    super.onClose();
  }

  void _loadChatHistory() {
    try {
      final history = HiveService.getAllChatMessages();
      messages.value = history;
    } catch (e) {
      debugPrint('[ChatController] Failed to load chat history: $e');
    }
  }

  void _initGemini() {
    try {
      _model = GeminiService.buildChatModel(
        systemInstruction:
            "You are a friendly, concise health assistant for a personal medicine reminder app called MedCare. "
            "Help users with medication questions, dosage reminders, health tips, and general wellness advice. "
            "Always be empathetic and clear. "
            "IMPORTANT: Never provide emergency medical diagnosis — always advise consulting a doctor for serious concerns. "
            "Keep responses under 120 words unless the user explicitly asks for more detail.",
      );

      _chat = _model!.startChat();
      isInitialized.value = true;
      initError.value = '';

      // Greet only if no existing history
      if (messages.isEmpty) {
        _addBotMessage(
          "👋 Hello! I'm your MedCare health assistant. "
          "Ask me anything about your medicines, health tips, or appointments!",
        );
      }
    } catch (e) {
      debugPrint('[ChatController] Gemini init error: $e');
      isInitialized.value = false;
      initError.value = 'Failed to initialize AI assistant.';
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Ensure Gemini is ready
    if (_chat == null) {
      _initGemini();
      if (_chat == null) {
        _addBotMessage(
            "⚠️ AI assistant is unavailable. Please check your internet connection and try again.");
        return;
      }
    }

    // 1. Add user message immediately
    final userMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _persistMessage(userMsg);
    isLoading.value = true;

    // UC-41 Steps 2-6: Intercept message and check against safety rules
    // before forwarding to the Gemini backend (SRS-133).
    if (_safetyRules.isBlocked(trimmed)) {
      isLoading.value = false;
      _addBotMessage(
        "🚨 I cannot answer this query. "
        "If this is an emergency, please call 911 or your local emergency "
        "services immediately. "
        "For mental health support, please reach out to a qualified "
        "healthcare professional.",
        isBlocked: true,
      );
      return;
    }

    try {
      // 2. Send to Gemini
      final response = await _chat!
          .sendMessage(Content.text(trimmed))
          .timeout(const Duration(seconds: 30));

      final responseText = response.text;
      if (responseText != null && responseText.isNotEmpty) {
        _addBotMessage(responseText);
      } else {
        _addBotMessage(
            "I'm not sure how to respond to that. Could you rephrase?");
      }
    } on GenerativeAIException catch (e) {
      debugPrint('[ChatController] GenerativeAI error: $e');
      final msg = e.message.toLowerCase();
      if (msg.contains('safety') || msg.contains('blocked')) {
        _addBotMessage(
            "⚠️ That topic is outside my safety guidelines. Please ask something health-related.");
      } else if (msg.contains('api key') ||
          msg.contains('401') ||
          msg.contains('403') ||
          msg.contains('permission')) {
        _addBotMessage(
            "⚠️ API authentication error. Please contact the app developer.");
      } else if (msg.contains('quota') || msg.contains('429')) {
        _addBotMessage(
            "⚠️ API quota exceeded. Please try again later.");
      } else {
        _addBotMessage(
            "⚠️ Something went wrong: ${e.message}. Please try again.");
      }
      // Re-create chat session to reset state after error
      _restartChatSession();
    } catch (e) {
      debugPrint('[ChatController] Unexpected error: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('timeout') || errStr.contains('socketexception') ||
          errStr.contains('network') || errStr.contains('connection')) {
        _addBotMessage(
            "⚠️ Network error. Please check your internet connection and try again.");
      } else {
        _addBotMessage(
            "⚠️ Unexpected error. Please try again in a moment.");
      }
      _restartChatSession();
    } finally {
      isLoading.value = false;
    }
  }

  void _restartChatSession() {
    try {
      if (_model != null) {
        _chat = _model!.startChat();
      }
    } catch (e) {
      debugPrint('[ChatController] Failed to restart chat session: $e');
    }
  }

  void _addBotMessage(String text, {bool isBlocked = false}) {
    final botMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      isBlocked: isBlocked,
    );
    messages.add(botMsg);
    _persistMessage(botMsg);
  }

  void _persistMessage(ChatMessageModel msg) {
    HiveService.saveChatMessage(msg).catchError((e) {
      debugPrint('[ChatController] Failed to persist message: $e');
    });
  }

  Future<void> clearHistory() async {
    try {
      await HiveService.clearChatHistory();
    } catch (e) {
      debugPrint('[ChatController] Failed to clear history: $e');
    }
    messages.clear();
    _restartChatSession();
    _addBotMessage(
      "👋 Chat cleared! I'm your MedCare health assistant. How can I help you today?",
    );
  }
}
```

```dart
// lib/view_models/settings_controller.dart
[lib/view_models/settings_controller.dart](lib/view_models/settings_controller.dart)
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/models/notification_settings_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var currentTimeZone = "Unknown".obs;
  var notificationSound = "Default".obs;

  // Notification sound settings
  var selectedShortSound = 'mixkit_bell_notification_933'.obs;
  var selectedLongSound = 'mixkit_marimba_waiting_ringtone_1360'.obs;
  var useShortForMedicine = true.obs;
  var useShortForAppointments = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const String _boxName = "settingsBox";
  static const String _keyTheme = "isDarkMode";

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadNotificationSettings();
    _initTimeZone();
  }

  Future<void> _loadSettings() async {
    var box = await Hive.openBox(_boxName);
    isDarkMode.value = box.get(_keyTheme, defaultValue: false);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _initTimeZone() async {
    try {
      currentTimeZone.value =
          (await FlutterTimezone.getLocalTimezone()) as String;
    } catch (e) {
      currentTimeZone.value = "UTC (Fallback)";
    }
  }

  void toggleTheme(bool isDark) async {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
    var box = await Hive.openBox(_boxName);
    await box.put(_keyTheme, isDark);
  }

  void updateNotificationSound(String sound) {
    notificationSound.value = sound;
  }

  // ================= NOTIFICATION SOUND SETTINGS =================

  Future<void> _loadNotificationSettings() async {
    final settings = HiveService.getNotificationSettings();
    if (settings != null) {
      selectedShortSound.value = settings.shortSoundName;
      selectedLongSound.value = settings.longSoundName;
      useShortForMedicine.value = settings.useShortForMedicine;
      useShortForAppointments.value = settings.useShortForAppointments;
      notificationSound.value =
          '${_formatSoundName(settings.shortSoundName)} | ${_formatSoundName(settings.longSoundName)}';
    }
  }

  String _formatSoundName(String soundName) {
    return soundName
        .replaceAll('mixkit_', '')
        .replaceAll('_', ' ')
        .split(' ')
        .take(2)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> updateShortSound(String soundName) async {
    selectedShortSound.value = soundName;
    await _saveNotificationSettings();
  }

  Future<void> updateLongSound(String soundName) async {
    selectedLongSound.value = soundName;
    await _saveNotificationSettings();
  }

  Future<void> toggleMedicineSound(bool useShort) async {
    useShortForMedicine.value = useShort;
    await _saveNotificationSettings();
  }

  Future<void> toggleAppointmentSound(bool useShort) async {
    useShortForAppointments.value = useShort;
    await _saveNotificationSettings();
  }

  Future<void> _saveNotificationSettings() async {
    final settings = NotificationSettingsModel(
      shortSoundName: selectedShortSound.value,
      longSoundName: selectedLongSound.value,
      useShortForMedicine: useShortForMedicine.value,
      useShortForAppointments: useShortForAppointments.value,
    );
    await HiveService.saveNotificationSettings(settings);
    notificationSound.value =
        '${_formatSoundName(selectedShortSound.value)} | ${_formatSoundName(selectedLongSound.value)}';

    // Recreate notification channels with the new sound
    await NotificationService.init();

    // Cancel ALL pending notifications and reschedule with new sound.
    // Required because Android locks a channel's sound after first creation —
    // NotificationService.init() creates a new channel ID per sound name,
    // so rescheduling puts all alarms on the correct new channel.
    await NotificationService.cancelAll();

    try {
      final medController = Get.find<MedicineController>();
      await medController.rescheduleAllNotifications();
    } catch (_) {}

    try {
      final aptController = Get.find<AppointmentController>();
      await aptController.rescheduleAllNotifications();
    } catch (_) {}

    Get.snackbar(
      '🔔 Settings Saved',
      'Notification sound preferences updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // ================= SOUND PREVIEW =================

  Future<void> previewSound(String soundName, bool isShort) async {
    try {
      // Stored key uses underscores; filename uses dashes
      final fileName = soundName.replaceAll('_', '-');
      final ext = soundName.contains('marimba') ? '.mp3' : '.wav';
      final assetPath = isShort
          ? 'sounds/short/$fileName$ext'
          : 'sounds/long/$fileName$ext';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound preview: $e');
      Get.snackbar(
        'Preview Error',
        'Could not preview sound',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
```
```

```dart
// lib/view_models/schedule_controller.dart
[lib/view_models/schedule_controller.dart](lib/view_models/schedule_controller.dart)
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/models/appointment_model.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ScheduleItemType { medicine, appointment }

enum ScheduleItemStatus { taken, missed, pending, upcoming }

// ─── ScheduleItem ─────────────────────────────────────────────────────────────

class ScheduleItem {
  final String id;
  final ScheduleItemType type;
  final String title;
  final String subtitle;
  final DateTime scheduledTime;
  final ScheduleItemStatus status;
  final Color color;
  final String? category;

  const ScheduleItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.scheduledTime,
    required this.status,
    required this.color,
    this.category,
  });
}

// ─── ScheduleController ───────────────────────────────────────────────────────

class ScheduleController extends GetxController {
  // ── Dependencies ────────────────────────────────────────────────────────────
  late final MedicineController _medCtrl;
  late final AppointmentController _aptCtrl;

  // ── Reactive state ──────────────────────────────────────────────────────────
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // ── Date range (SRS-88: ±15 days) ───────────────────────────────────────────
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get rangeStart => _today.subtract(const Duration(days: 15));
  DateTime get rangeEnd => _today.add(const Duration(days: 15));

  // ── Colors ──────────────────────────────────────────────────────────────────
  static const Color medicineColor = Color(0xFF6C63FF); // purple
  static const Color appointmentColor = Color(0xFF00BFA6); // teal

  @override
  void onInit() {
    super.onInit();
    _medCtrl = Get.find<MedicineController>();
    _aptCtrl = Get.find<AppointmentController>();
  }

  // ── Date selection (SRS-87, SRS-88) ─────────────────────────────────────────
  void onDaySelected(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    if (d.isBefore(rangeStart) || d.isAfter(rangeEnd)) {
      Get.snackbar(
        'Out of Range',
        'Calendar is limited to 15 days past and future',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    selectedDate.value = d;
  }

  // ── Compute schedule items for any date ──────────────────────────────────────
  List<ScheduleItem> scheduleForDate(DateTime date) {
    final items = <ScheduleItem>[];
    final dateKey = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();

    // Medicine doses (SRS-86)
    for (final med in _medCtrl.medicines) {
      if (!_medCtrl.isScheduledForDate(med, dateKey)) continue;
      for (final timeSlot in med.reminderTimes) {
        final scheduled = DateTime(
          dateKey.year,
          dateKey.month,
          dateKey.day,
          timeSlot.hour,
          timeSlot.minute,
        );

        final taken = _medCtrl.isTaken(med.medicineId, dateKey, timeSlot);
        final isPast = scheduled.isBefore(now);

        ScheduleItemStatus status;
        if (taken) {
          status = ScheduleItemStatus.taken;
        } else if (isPast) {
          status = ScheduleItemStatus.missed;
        } else if (isSameDay(dateKey, _today)) {
          status = ScheduleItemStatus.pending;
        } else {
          status = ScheduleItemStatus.upcoming;
        }

        items.add(ScheduleItem(
          id: '${med.medicineId}_${scheduled.millisecondsSinceEpoch}',
          type: ScheduleItemType.medicine,
          title: med.name,
          subtitle: med.dosage,
          scheduledTime: scheduled,
          status: status,
          color: medicineColor,
          category: med.type,
        ));
      }
    }

    // Appointments (SRS-86)
    for (final apt in _aptCtrl.appointments) {
      final aptDate = DateTime(
        apt.dateTime.year,
        apt.dateTime.month,
        apt.dateTime.day,
      );
      if (!isSameDay(aptDate, dateKey)) continue;

      ScheduleItemStatus status;
      if (apt.isCompleted) {
        status = ScheduleItemStatus.taken; // completed → "taken" (done)
      } else if (apt.dateTime.isBefore(now)) {
        status = ScheduleItemStatus.missed;
      } else {
        status = ScheduleItemStatus.upcoming;
      }

      items.add(ScheduleItem(
        id: apt.id,
        type: ScheduleItemType.appointment,
        title: apt.doctorName,
        subtitle: apt.category,
        scheduledTime: apt.dateTime,
        status: status,
        color: appointmentColor,
        category: apt.category,
      ));
    }

    // Sort chronologically (SRS-86)
    items.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return items;
  }

  // ── Reactive items for selected date ────────────────────────────────────────
  List<ScheduleItem> get itemsForSelectedDate =>
      scheduleForDate(selectedDate.value);

  // ── Marked dates (SRS-85: event indicators) ─────────────────────────────────
  Set<DateTime> get markedDates {
    final dates = <DateTime>{};

    for (final med in _medCtrl.medicines) {
      // Check each day in the valid ±15 range
      final rangeLength = rangeEnd.difference(rangeStart).inDays;
      for (int i = 0; i <= rangeLength; i++) {
        final d = rangeStart.add(Duration(days: i));
        if (_medCtrl.isScheduledForDate(med, d)) {
          dates.add(DateTime(d.year, d.month, d.day));
        }
      }
    }

    for (final apt in _aptCtrl.appointments) {
      final d = DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day);
      dates.add(d);
    }

    return dates;
  }

  // ── Helper: appointment for a date ──────────────────────────────────────────
  List<AppointmentModel> appointmentsForDate(DateTime date) {
    return _aptCtrl.appointments.where((a) {
      return a.dateTime.year == date.year &&
          a.dateTime.month == date.month &&
          a.dateTime.day == date.day;
    }).toList();
  }

  // ── Helper: medicine doses for a date ───────────────────────────────────────
  List<MedicineModel> medicinesForDate(DateTime date) {
    return _medCtrl.medicines
        .where((m) => _medCtrl.isScheduledForDate(m, date))
        .toList();
  }

  // ── Mark medicine dose as taken (slide-to-dismiss) ───────────────────────────
  Future<void> markMedicineTaken(MedicineModel med, DateTime scheduledTime) async {
    await _medCtrl.markAsTaken(med, scheduledTime, scheduledTime);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Find medicine by id ──────────────────────────────────────────────────────
  MedicineModel? findMedicine(String id) =>
      _medCtrl.medicines.firstWhereOrNull((m) => m.medicineId == id);

  // ── Find appointment by id ──────────────────────────────────────────────────
  AppointmentModel? findAppointment(String id) =>
      _aptCtrl.appointments.firstWhereOrNull((a) => a.id == id);
}
```
```

```dart
// lib/view_models/report_controller.dart
[lib/view_models/report_controller.dart](lib/view_models/report_controller.dart)
```dart
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
```
```

```dart
// lib/view_models/notification_settings_controller.dart
[lib/view_models/notification_settings_controller.dart](lib/view_models/notification_settings_controller.dart)
```dart
import 'package:get/get.dart';
import '../data/models/notification_settings_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationSettingsController extends GetxController {
  // Non-final so it can be replaced with a fresh instance on each preview.
  AudioPlayer _audioPlayer = AudioPlayer();

  // Available notification sounds
  final List<NotificationSound> shortSounds = [
    NotificationSound(
      name: 'Bell Notification',
      fileName: 'mixkit_bell_notification_933',
      assetPath: 'sounds/short/mixkit-bell-notification-933.wav',
      duration: '2s',
    ),
  ];

  final List<NotificationSound> longSounds = [
    NotificationSound(
      name: 'Marimba Waiting',
      fileName: 'mixkit_marimba_waiting_ringtone_1360',
      assetPath: 'sounds/long/mixkit-marimba-waiting-ringtone-1360.mp3',
      duration: '4s',
    ),
  ];

  // Current settings
  late Rx<NotificationSettingsModel> settings;

  @override
  void onInit() {
    super.onInit();
    // Load current settings from Hive
    final savedSettings =
        HiveService.getNotificationSettings() ?? NotificationSettingsModel();
    settings = savedSettings.obs;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // Preview a sound — creates a fresh AudioPlayer each time to avoid stale
  // MediaPlayer state issues on Android (especially for larger WAV files).
  Future<void> previewSound(String assetPath) async {
    // Stop & dispose the current player before creating a new one.
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (_) {}

    // Replace with a fresh instance.
    _audioPlayer = AudioPlayer();

    try {
      // Set the audio context so Android plays through the notification/ring
      // stream rather than media (avoids some codec rejections on certain devices).
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            audioFocus: AndroidAudioFocus.gain,
            usageType: AndroidUsageType.notification,
            contentType: AndroidContentType.sonification,
          ),
        ),
      );
      // AssetSource expects path relative to the assets/ directory.
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound preview: $e');
      Get.snackbar(
        'Preview Unavailable',
        'Sound will still play correctly in notifications.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Update short sound
  void updateShortSound(String fileName) {
    settings.value = settings.value.copyWith(shortSoundName: fileName);
    _saveSettings();
  }

  // Update long sound
  void updateLongSound(String fileName) {
    settings.value = settings.value.copyWith(longSoundName: fileName);
    _saveSettings();
  }

  // Toggle medicine notification type
  void toggleMedicineNotificationType(bool useShort) {
    settings.value = settings.value.copyWith(useShortForMedicine: useShort);
    _saveSettings();
  }

  // Toggle appointment notification type
  void toggleAppointmentNotificationType(bool useShort) {
    settings.value = settings.value.copyWith(useShortForAppointments: useShort);
    _saveSettings();
  }

  // Save settings to Hive and recreate notification channels
  Future<void> _saveSettings() async {
    await HiveService.saveNotificationSettings(settings.value);

    // Recreate notification channels with new sounds
    // This requires reinitializing the notification service
    await NotificationService.init();

    Get.snackbar(
      'Settings Saved',
      'Notification settings updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}

// Model for notification sound options
class NotificationSound {
  final String name;
  final String fileName;
  final String assetPath;
  final String duration;

  NotificationSound({
    required this.name,
    required this.fileName,
    required this.assetPath,
    required this.duration,
  });
}
```
```

```dart
// lib/view_models/wellness_controller.dart
[lib/view_models/wellness_controller.dart](lib/view_models/wellness_controller.dart)
```dart
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
```
```

```dart
// lib/view_models/login_view_controller.dart
[lib/view_models/login_view_controller.dart](lib/view_models/login_view_controller.dart)
```dart
import 'package:get/get.dart';

/// Lightweight GetX controller that manages local UI state for [LoginView].
/// Registered with Get.put() inside the view so it persists across rebuilds.
class LoginViewController extends GetxController {
  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
```
```

```dart
// lib/view_models/signup_view_controller.dart
[lib/view_models/signup_view_controller.dart](lib/view_models/signup_view_controller.dart)
```dart
import 'package:get/get.dart';

/// Lightweight GetX controller that manages local UI state for [SignUpView].
/// Registered with Get.put() inside the view so it persists across rebuilds.
class SignupViewController extends GetxController {
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirm = true.obs;
  final RxString passwordStrength = ''.obs;

  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _digitRegex = RegExp(r'[0-9]');

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmVisibility() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  void updatePasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = '';
    } else if (password.length < 8) {
      passwordStrength.value = 'weak';
    } else if (!password.contains(_uppercaseRegex) ||
        !password.contains(_digitRegex)) {
      passwordStrength.value = 'medium';
    } else {
      passwordStrength.value = 'strong';
    }
  }
}
```
```

```dart
// lib/view_models/analytics_controller.dart
[lib/view_models/analytics_controller.dart](lib/view_models/analytics_controller.dart)
```dart
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
```
```

---

Notes: I used file links above so you can click each to open in VS Code. If you prefer, I can replace the `<snip: exact source...>` blocks with full verbatim code blocks for each file — say "full" and I'll expand them.

Next: I'll mark the remaining controllers appended in the TODO list and prepare the final report. 
