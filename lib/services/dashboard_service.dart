import '../models/dashboard.dart';
import '../models/dashboard_activity.dart';
import '../models/invoice_status.dart';

import 'building_service.dart';
import 'maintenance_service.dart';
import 'payment_service.dart';
import 'tenant_service.dart';
import 'unit_service.dart';
import 'billing_service.dart';
import 'session_service.dart';
import '../core/constants/firestore_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  DashboardService();

  final BuildingService _buildingService = BuildingService();
  final UnitService _unitService = UnitService();
  final TenantService _tenantService = TenantService();
  final PaymentService _paymentService = PaymentService();
  final MaintenanceService _maintenanceService = MaintenanceService();
  final BillingService _billingService = BillingService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _organizationId => SessionService.instance.organizationId ?? '';

  Future<Dashboard> loadDashboard() async {
    // Ensure invoices are up to date (Rule: Remove work from user)
    if (_organizationId.isNotEmpty) {
       await _billingService.generateMonthlyInvoices();
    }

    final totalBuildings = await _buildingService.totalBuildings();
    final totalUnits = await _unitService.getTotalUnits();
    final occupiedUnits = await _unitService.getOccupiedCount();
    final vacantUnits = await _unitService.getVacantCount();
    final occupancyRate = await _unitService.getOccupancyRate();

    final totalRevenue = await _paymentService.getTotalRevenue();
    final monthlyRevenue = await _paymentService.getMonthlyRevenue();
    final openMaintenance = await _maintenanceService.getOpenRequestCount();
    
    // Calculate expected revenue and collection status from Invoices
    final invoicesSnapshot = await _firestore
        .collection(FirestoreCollections.invoices)
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    double expectedRevenue = 0;
    double actualCollected = 0;

    for (var doc in invoicesSnapshot.docs) {
      expectedRevenue += (doc.data()['amount'] ?? 0).toDouble();
      actualCollected += (doc.data()['amountPaid'] ?? 0).toDouble();
    }

    final tenants = await _tenantService.getTenants().first;

    final collectionRate = expectedRevenue > 0
        ? (actualCollected / expectedRevenue) * 100
        : 0.0;

    return Dashboard(
      totalBuildings: totalBuildings,
      totalUnits: totalUnits,
      occupiedUnits: occupiedUnits,
      vacantUnits: vacantUnits,
      totalTenants: tenants.length,
      occupancyRate: occupancyRate,
      totalRevenue: actualCollected, // Revenue from invoices
      expectedRevenue: expectedRevenue,
      collectionRate: collectionRate,
      openMaintenance: openMaintenance,
      monthlyRevenue: monthlyRevenue,
    );
  }

  Future<List<DashboardActivity>> loadRecentActivity() async {
    final tenants = await _tenantService.getTenants().first;
    final activities = <DashboardActivity>[];

    for (final tenant in tenants.take(5)) {
      activities.add(
        DashboardActivity(
          title: 'New Tenant',
          subtitle: tenant.name,
          timestamp: tenant.createdAt,
          type: DashboardActivityType.tenant,
        ),
      );
    }

    return activities;
  }
}
