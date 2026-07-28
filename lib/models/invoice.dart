import 'package:cloud_firestore/cloud_firestore.dart';
import 'invoice_status.dart';

class Invoice {
  final String id;
  final String organizationId;
  final String buildingId;
  final String unitId;
  final String tenantId;
  final String leaseId;

  final String invoiceNumber;
  final double amount;
  final double amountPaid;
  
  final DateTime dueDate;
  final DateTime periodStart;
  final DateTime periodEnd;
  
  final InvoiceStatus status;
  final DateTime createdAt;

  const Invoice({
    required this.id,
    required this.organizationId,
    required this.buildingId,
    required this.unitId,
    required this.tenantId,
    required this.leaseId,
    required this.invoiceNumber,
    required this.amount,
    required this.amountPaid,
    required this.dueDate,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
    required this.createdAt,
  });

  double get balance => amount - amountPaid;
  bool get isPaid => status == InvoiceStatus.paid;

  factory Invoice.fromMap(String id, Map<String, dynamic> map) {
    return Invoice(
      id: id,
      organizationId: map['organizationId'] ?? '',
      buildingId: map['buildingId'] ?? '',
      unitId: map['unitId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      leaseId: map['leaseId'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      amountPaid: (map['amountPaid'] ?? 0).toDouble(),
      dueDate: _dateTime(map['dueDate']),
      periodStart: _dateTime(map['periodStart']),
      periodEnd: _dateTime(map['periodEnd']),
      status: InvoiceStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => InvoiceStatus.pending,
      ),
      createdAt: _dateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'buildingId': buildingId,
      'unitId': unitId,
      'tenantId': tenantId,
      'leaseId': leaseId,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'amountPaid': amountPaid,
      'dueDate': Timestamp.fromDate(dueDate),
      'periodStart': Timestamp.fromDate(periodStart),
      'periodEnd': Timestamp.fromDate(periodEnd),
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _dateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Invoice copyWith({
    String? id,
    String? organizationId,
    String? buildingId,
    String? unitId,
    String? tenantId,
    String? leaseId,
    String? invoiceNumber,
    double? amount,
    double? amountPaid,
    DateTime? dueDate,
    DateTime? periodStart,
    DateTime? periodEnd,
    InvoiceStatus? status,
    DateTime? createdAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      tenantId: tenantId ?? this.tenantId,
      leaseId: leaseId ?? this.leaseId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      amount: amount ?? this.amount,
      amountPaid: amountPaid ?? this.amountPaid,
      dueDate: dueDate ?? this.dueDate,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
