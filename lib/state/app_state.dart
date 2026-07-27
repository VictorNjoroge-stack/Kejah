import 'package:flutter/foundation.dart';

import '../models/building.dart';
import '../models/unit.dart';
import '../models/payment.dart';
import '../models/tenant.dart';
import '../models/vacate_notice.dart';
import '../models/eviction_notice.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  final List<Building> buildings = [];
  final List<Unit> units = [];
  final List<Tenant> tenants = [];
  final List<Payment> payments = [];

  final List<VacateNotice> vacateNotices = [];
  final List<EvictionNotice> evictionNotices = [];

  void initialize() {}

  // =====================================================
  // BUILDINGS
  // =====================================================

  void addBuilding(Building building) {
    buildings.add(building);
    notifyListeners();
  }

  // =====================================================
  // UNITS
  // =====================================================

  void addUnit(Unit unit) {
    units.add(unit);
    notifyListeners();
  }

  List<Unit> unitsByBuilding(String buildingId) {
    return units.where((u) => u.buildingId == buildingId).toList();
  }

  Unit? getUnit(String unitId) {
    try {
      return units.firstWhere((u) => u.id == unitId);
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // TENANTS
  // =====================================================

  void addTenant(Tenant tenant) {
    tenants.add(tenant);
    notifyListeners();
  }

  Tenant? getTenantByUnit(String unitId) {
    try {
      return tenants.firstWhere((t) => t.unitId == unitId);
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // PAYMENTS
  // =====================================================

  void addPayment(Payment payment) {
    payments.add(payment);
    notifyListeners();
  }

  double totalPaid(String unitId) {
    return payments
        .where((p) => p.unitId == unitId)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  // =====================================================
  // VACATE NOTICES
  // =====================================================

  void addVacateNotice(VacateNotice notice) {
    vacateNotices.add(notice);
    notifyListeners();
  }

  void applyVacateNotice(VacateNotice notice) {
    notifyListeners();
  }

  // =====================================================
  // EVICTION NOTICES
  // =====================================================

  void addEvictionNotice(EvictionNotice notice) {
    evictionNotices.add(notice);
    notifyListeners();
  }

  void applyEvictionNotice(EvictionNotice notice) {
    notifyListeners();
  }

  // =====================================================
  // ANALYTICS
  // =====================================================

  double totalCollected() {
    return payments.fold(
      0.0,
          (sum, p) => sum + p.amount,
    );
  }

  double totalRentExpected() {
    return tenants.fold(
      0.0,
          (sum, t) => sum + t.rent,
    );
  }

  double totalArrears() {
    return totalRentExpected() - totalCollected();
  }
}