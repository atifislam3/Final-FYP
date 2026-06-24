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
