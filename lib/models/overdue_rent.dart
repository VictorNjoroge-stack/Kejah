enum OverdueSeverity {
  low,
  medium,
  high,
  critical,
}

class OverdueRent {
  final String tenantId;
  final String buildingId;
  final String unitId;

  final String tenantName;
  final String buildingName;
  final String unitName;

  final double monthlyRent;
  final double amountPaid;
  final double outstandingBalance;

  final int daysOverdue;

  final OverdueSeverity severity;

  const OverdueRent({
    required this.tenantId,
    required this.buildingId,
    required this.unitId,
    required this.tenantName,
    required this.buildingName,
    required this.unitName,
    required this.monthlyRent,
    required this.amountPaid,
    required this.outstandingBalance,
    required this.daysOverdue,
    required this.severity,
  });

  bool get isOverdue => outstandingBalance > 0;

  factory OverdueRent.empty() {
    return const OverdueRent(
      tenantId: '',
      buildingId: '',
      unitId: '',
      tenantName: '',
      buildingName: '',
      unitName: '',
      monthlyRent: 0,
      amountPaid: 0,
      outstandingBalance: 0,
      daysOverdue: 0,
      severity: OverdueSeverity.low,
    );
  }
}