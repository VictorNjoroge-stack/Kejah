class Payment {
  final String id;

  // Relationships
  final String organizationId;
  final String tenantId;
  final String buildingId;
  final String unitId;

  // Payment Details
  final double amount;

  final String paymentMethod;
  final String reference;

  final String notes;

  final DateTime paymentDate;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.organizationId,
    required this.tenantId,
    required this.buildingId,
    required this.unitId,
    required this.amount,
    required this.paymentMethod,
    required this.reference,
    required this.notes,
    required this.paymentDate,
    required this.createdAt,
  });

  factory Payment.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Payment(
      id: id,
      organizationId: map['organizationId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      reference: map['reference'] ?? '',
      notes: map['notes'] ?? '',
      paymentDate:
      DateTime.tryParse(map['paymentDate'] ?? '') ?? DateTime.now(),
      createdAt:
      DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'tenantId': tenantId,
      'buildingId': buildingId,
      'unitId': unitId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'reference': reference,
      'notes': notes,
      'paymentDate': paymentDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? organizationId,
    String? tenantId,
    String? buildingId,
    String? unitId,
    double? amount,
    String? paymentMethod,
    String? reference,
    String? notes,
    DateTime? paymentDate,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      tenantId: tenantId ?? this.tenantId,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      paymentDate: paymentDate ?? this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}