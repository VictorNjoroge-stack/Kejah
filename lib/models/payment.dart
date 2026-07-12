class Payment {
  final String id;

  // Relationships
  final String buildingId;
  final String unitId;
  final String tenantId;

  // Display
  final String tenantName;
  final String unitNumber;

  // Financial
  final double amount;
  final String paymentType; // Rent, Deposit, Water, Penalty, etc.
  final String paymentMethod; // Cash, M-Pesa, Bank
  final String transactionCode;

  // Status
  final bool verified;

  final DateTime paymentDate;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.buildingId,
    required this.unitId,
    required this.tenantId,
    required this.tenantName,
    required this.unitNumber,
    required this.amount,
    required this.paymentType,
    required this.paymentMethod,
    required this.transactionCode,
    required this.verified,
    required this.paymentDate,
    required this.createdAt,
  });

  factory Payment.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Payment(
      id: id,
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      tenantName: map['tenantName'] ?? '',
      unitNumber: map['unitNumber'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentType: map['paymentType'] ?? 'Rent',
      paymentMethod: map['paymentMethod'] ?? 'M-Pesa',
      transactionCode: map['transactionCode'] ?? '',
      verified: map['verified'] ?? true,
      paymentDate: DateTime.tryParse(
        map['paymentDate'] ?? '',
      ) ??
          DateTime.now(),
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingId': buildingId,
      'unitId': unitId,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'unitNumber': unitNumber,
      'amount': amount,
      'paymentType': paymentType,
      'paymentMethod': paymentMethod,
      'transactionCode': transactionCode,
      'verified': verified,
      'paymentDate': paymentDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? buildingId,
    String? unitId,
    String? tenantId,
    String? tenantName,
    String? unitNumber,
    double? amount,
    String? paymentType,
    String? paymentMethod,
    String? transactionCode,
    bool? verified,
    DateTime? paymentDate,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      unitNumber: unitNumber ?? this.unitNumber,
      amount: amount ?? this.amount,
      paymentType: paymentType ?? this.paymentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionCode: transactionCode ?? this.transactionCode,
      verified: verified ?? this.verified,
      paymentDate: paymentDate ?? this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}