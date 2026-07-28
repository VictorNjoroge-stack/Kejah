import '../models/overdue_rent.dart';

import 'building_service.dart';
import 'lease_service.dart';
import 'payment_service.dart';
import 'tenant_service.dart';
import 'unit_service.dart';

class RentIntelligenceService {
final LeaseService _leaseService = LeaseService();
final PaymentService _paymentService = PaymentService();
final TenantService _tenantService = TenantService();
final BuildingService _buildingService = BuildingService();
final UnitService _unitService = UnitService();

Future<List<OverdueRent>> getOverdueRent() async {
final leases = await _leaseService.getLeases().first;
final payments = await _paymentService.getPayments().first;
final tenants = await _tenantService.getTenants().first;
final buildings = await _buildingService.getBuildings().first;
final units = await _unitService.getUnits().first;

final now = DateTime.now();

final overdue = <OverdueRent>[];

for (final lease in leases) {
if (!lease.isActive) {
continue;
}

final tenant = tenants.firstWhere(
(t) => t.id == lease.tenantId,
orElse: () => throw Exception(
'Tenant not found: ${lease.tenantId}',
),
);

final building = buildings.firstWhere(
(b) => b.id == lease.buildingId,
orElse: () => throw Exception(
'Building not found: ${lease.buildingId}',
),
);

final unit = units.firstWhere(
(u) => u.id == lease.unitId,
orElse: () => throw Exception(
'Unit not found: ${lease.unitId}',
),
);

double amountPaid = 0.0;

for (final payment in payments) {
if (payment.tenantId != lease.tenantId) {
continue;
}

if (payment.paymentDate.year != now.year) {
continue;
}

if (payment.paymentDate.month != now.month) {
continue;
}

amountPaid += payment.amount;
}

final double outstanding =
lease.monthlyRent > amountPaid
? lease.monthlyRent - amountPaid
: 0.0;

final dueDate = DateTime(
now.year,
now.month,
lease.billingDay,
);

final int daysOverdue =
now.isAfter(dueDate)
? now.difference(dueDate).inDays
: 0;

if (outstanding <= 0 || daysOverdue <= 0) {
continue;
}

OverdueSeverity severity;

if (daysOverdue >= 90) {
severity = OverdueSeverity.critical;
} else if (daysOverdue >= 60) {
severity = OverdueSeverity.high;
} else if (daysOverdue >= 30) {
severity = OverdueSeverity.medium;
} else {
severity = OverdueSeverity.low;
}

overdue.add(
OverdueRent(
tenantId: lease.tenantId,
buildingId: lease.buildingId,
unitId: lease.unitId,
tenantName: tenant.name,
buildingName: building.name,
unitName: unit.unitNumber,
monthlyRent: lease.monthlyRent,
  amountPaid: amountPaid,
  outstandingBalance: outstanding,
  daysOverdue: daysOverdue,
  severity: severity,
),
);
}

overdue.sort((a, b) {
  final severityCompare =
  b.severity.index.compareTo(a.severity.index);

  if (severityCompare != 0) {
    return severityCompare;
  }

  return b.daysOverdue.compareTo(a.daysOverdue);
});

return overdue;
}

Future<double> getTotalOutstandingBalance() async {
  final overdue = await getOverdueRent();

  double total = 0.0;

  for (final rent in overdue) {
    total += rent.outstandingBalance;
  }

  return total;
}

Future<int> getOverdueTenantCount() async {
  final overdue = await getOverdueRent();
  return overdue.length;
}

Future<List<OverdueRent>> getCriticalOverdueRent() async {
  final overdue = await getOverdueRent();

  return overdue
      .where(
        (rent) =>
    rent.severity == OverdueSeverity.critical,
  )
      .toList();
}

Future<List<OverdueRent>> getHighPriorityOverdueRent() async {
  final overdue = await getOverdueRent();

  return overdue
      .where(
        (rent) =>
    rent.severity == OverdueSeverity.high ||
        rent.severity == OverdueSeverity.critical,
  )
      .toList();
}

Future<double> getCollectionRate() async {
  final leases = await _leaseService.getLeases().first;

  if (leases.isEmpty) {
    return 100;
  }

  double expected = 0.0;

  for (final lease in leases) {
    if (lease.isActive) {
      expected += lease.monthlyRent;
    }
  }

  if (expected == 0) {
    return 100;
  }

  final collected =
  await _paymentService.getTotalRevenue();

  return (collected / expected) * 100;
}
}