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
