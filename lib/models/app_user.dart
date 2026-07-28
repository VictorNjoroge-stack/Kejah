import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String organizationId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool profileCompleted;
  final bool active;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.organizationId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileCompleted,
    required this.active,
    required this.createdAt,
  });

  factory AppUser.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return AppUser(
      id: id,
      organizationId: map['organizationId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'owner',
      profileCompleted: map['profileCompleted'] ?? false,
      active: map['active'] ?? true,
      createdAt: _dateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'profileCompleted': profileCompleted,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _dateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
