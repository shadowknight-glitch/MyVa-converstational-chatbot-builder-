import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  String displayName;
  final String gender;
  final DateTime? lastNameChange;
  final bool darkMode;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.gender,
    this.lastNameChange,
    this.darkMode = false,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      gender: data['gender'] ?? 'other',
      lastNameChange: (data['lastNameChange'] as Timestamp?)?.toDate(),
      darkMode: data['darkMode'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'gender': gender,
      'lastNameChange': lastNameChange,
      'darkMode': darkMode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool canChangeName() {
    if (lastNameChange == null) return true;
    final now = DateTime.now();
    final difference = now.difference(lastNameChange!);
    return difference.inDays >= 30;
  }

  UserModel copyWith({
    String? displayName,
    String? gender,
    DateTime? lastNameChange,
    bool? darkMode,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      lastNameChange: lastNameChange ?? this.lastNameChange,
      darkMode: darkMode ?? this.darkMode,
      createdAt: createdAt,
    );
  }

  int daysUntilNameChange() {
    if (lastNameChange == null) return 0;
    final now = DateTime.now();
    final difference = now.difference(lastNameChange!);
    return 30 - difference.inDays;
  }
}
