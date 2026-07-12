class Tenant {
  final String id;

  final String name;
  final String phone;
  final String email;
  final String nationalId;

  // Relationships
  final String buildingId;
  final String unitId;

  // Financial
  final double rent;
  final double deposit;

  // Status
  final bool active;

  final DateTime createdAt;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.nationalId,
    required this.buildingId,
    required this.unitId,
    required this.rent,
    required this.deposit,
    required this.active,
    required this.createdAt,
  });

  factory Tenant.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Tenant(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      nationalId: map['nationalId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      rent: (map['rent'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      active: map['active'] ?? true,
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'nationalId': nationalId,
      'buildingId': buildingId,
      'unitId': unitId,
      'rent': rent,
      'deposit': deposit,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Tenant copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? nationalId,
    String? buildingId,
    String? unitId,
    double? rent,
    double? deposit,
    bool? active,
    DateTime? createdAt,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}