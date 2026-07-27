import '../models/dashboard.dart';
import 'building_service.dart';
import 'maintenance_service.dart';
import 'payment_service.dart';
import 'tenant_service.dart';
import 'unit_service.dart';

class DashboardService {
  DashboardService();

  final BuildingService _buildingService = BuildingService();
  final UnitService _unitService = UnitService();
  final TenantService _tenantService = TenantService();
  final PaymentService _paymentService = PaymentService();
  final MaintenanceService _maintenanceService =
  MaintenanceService();

  Future<Dashboard> loadDashboard() async {
    // Buildings
    final int totalBuildings =
    await _buildingService.totalBuildings();

    // Units
    final int totalUnits =
    await _unitService.getTotalUnits();

    final int occupiedUnits =
    await _unitService.getOccupiedCount();

    final int vacantUnits =
    await _unitService.getVacantCount();

    final double occupancyRate =
    await _unitService.getOccupancyRate();

    // Revenue
    final double totalRevenue =
    await _paymentService.getTotalRevenue();

    final double expectedRevenue =
    await _unitService.getMonthlyRevenue();

    // Tenants
    final tenants =
    await _tenantService.getTenants().first;

    // Maintenance
    final int openMaintenance =
    await _maintenanceService.getOpenRequestCount();

    return Dashboard(
      totalBuildings: totalBuildings,
      totalUnits: totalUnits,
      occupiedUnits: occupiedUnits,
      vacantUnits: vacantUnits,
      totalTenants: tenants.length,
      occupancyRate: occupancyRate,
      totalRevenue: totalRevenue,
      expectedRevenue: expectedRevenue,
      openMaintenance: openMaintenance,
    );
  }
}