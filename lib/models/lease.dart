import 'lease_status.dart';

class Lease {
  final String id;

  // Relationships
  final String organizationId;
  final String buildingId;
  final String unitId;
  final String tenantId;

  // Lease Information
  final String leaseNumber;

  final double monthlyRent;
  final double deposit;

  /// Day of the month rent is due (1-31)
  final int billingDay;

  final DateTime startDate;
  final DateTime endDate;

  final LeaseStatus status;

  // Documents
  final String agreementUrl;

  // Extra Notes
  final String notes;

  final DateTime createdAt;

  const Lease({
    required this.id,
    required this.organizationId,
    required this.buildingId,
    required this.unitId,
    required this.tenantId,
    required this.leaseNumber,
    required this.monthlyRent,
    required this.deposit,
    required this.billingDay,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.agreementUrl,
    required this.notes,
    required this.createdAt,
  });

  factory Lease.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Lease(
      id: id,
      organizationId: map['organizationId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      leaseNumber: map['leaseNumber'] ?? '',
      monthlyRent: (map['monthlyRent'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      billingDay: map['billingDay'] ?? 1,
      startDate:
      DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      endDate:
      DateTime.tryParse(map['endDate'] ?? '') ?? DateTime.now(),
      status: LeaseStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => LeaseStatus.pending,
      ),
      agreementUrl: map['agreementUrl'] ?? '',
      notes: map['notes'] ?? '',
      createdAt:
      DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'buildingId': buildingId,
      'unitId': unitId,
      'tenantId': tenantId,
      'leaseNumber': leaseNumber,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
      'billingDay': billingDay,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'agreementUrl': agreementUrl,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Lease copyWith({
    String? id,
    String? organizationId,
    String? buildingId,
    String? unitId,
    String? tenantId,
    String? leaseNumber,
    double? monthlyRent,
    double? deposit,
    int? billingDay,
    DateTime? startDate,
    DateTime? endDate,
    LeaseStatus? status,
    String? agreementUrl,
    String? notes,
    DateTime? createdAt,
  }) {
    return Lease(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      tenantId: tenantId ?? this.tenantId,
      leaseNumber: leaseNumber ?? this.leaseNumber,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      deposit: deposit ?? this.deposit,
      billingDay: billingDay ?? this.billingDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      agreementUrl: agreementUrl ?? this.agreementUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isActive => status == LeaseStatus.active;

  bool get isExpired => endDate.isBefore(DateTime.now());

  int get daysRemaining =>
      endDate.difference(DateTime.now()).inDays;
}