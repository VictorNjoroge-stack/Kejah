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
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
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
      'createdAt': createdAt.toIso8601String(),
    };
  }
}