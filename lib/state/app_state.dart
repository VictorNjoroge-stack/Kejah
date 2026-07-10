import '../models/building.dart';
import '../models/house.dart';
import '../models/house_status.dart';
import '../models/tenant.dart';
import '../models/payment.dart';
import '../models/vacate_notice.dart';
import '../models/eviction_notice.dart';

class AppState {
  AppState._internal();

  static final AppState instance = AppState._internal();

  // =========================
  // CORE DATA
  // =========================
  final List<Building> buildings = [];
  final List<House> houses = [];
  final List<Tenant> tenants = [];
  final List<Payment> payments = [];

  final List<VacateNotice> vacateNotices = [];
  final List<EvictionNotice> evictionNotices = [];

  // =========================
  // BUILDINGS
  // =========================
  void addBuilding(Building b) {
    buildings.add(b);
  }

  // =========================
  // HOUSES
  // =========================
  void addHouse(House h) {
    houses.add(h);
  }

  List<House> housesByBuilding(String buildingId) {
    return houses.where((h) => h.buildingId == buildingId).toList();
  }

  House? getHouse(String id) {
    try {
      return houses.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  void markOccupied(String houseId) {
    final h = getHouse(houseId);
    if (h != null) {
      h.status = HouseStatus.occupied;
    }
  }

  void markVacant(String houseId) {
    final h = getHouse(houseId);
    if (h != null) {
      h.status = HouseStatus.vacant;
    }
  }

  // =========================
  // TENANTS
  // =========================
  void addTenant(Tenant t) {
    tenants.add(t);

    final h = getHouse(t.houseId);
    if (h != null) {
      h.status = HouseStatus.occupied;
    }
  }

  Tenant? getTenantByHouse(String houseId) {
    try {
      return tenants.firstWhere((t) => t.houseId == houseId);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // PAYMENTS
  // =========================
  void addPayment(Payment p) {
    payments.add(p);

    final h = getHouse(p.houseId);
    if (h != null) {
      h.lastPaymentDate = DateTime.now();
      h.status = HouseStatus.occupied;
    }
  }

  double totalPaid(String houseId) {
    return payments
        .where((p) => p.houseId == houseId)
        .fold(0.0, (a, b) => a + b.amount);
  }

  // =========================
  // ANALYTICS
  // =========================
  double totalRentExpected() {
    return houses.fold(0.0, (a, b) => a + b.monthlyRent);
  }

  double totalCollected() {
    return payments.fold(0.0, (a, b) => a + b.amount);
  }

  double totalArrears() {
    return totalRentExpected() - totalCollected();
  }

  // =========================
  // LIFECYCLE ENGINE
  // =========================
  void runLifecycleCheck() {
    final now = DateTime.now();

    for (final h in houses) {
      final paid = totalPaid(h.id);

      if (h.status == HouseStatus.occupied &&
          paid < h.monthlyRent) {
        h.status = HouseStatus.arrears;
      }

      if (h.status == HouseStatus.arrears &&
          h.lastPaymentDate != null &&
          now.difference(h.lastPaymentDate!).inDays > 7) {
        h.status = HouseStatus.vacatingSoon;
      }

      if (h.status == HouseStatus.vacatingSoon &&
          h.vacateNoticeDate != null &&
          now.difference(h.vacateNoticeDate!).inDays > 14) {
        h.status = HouseStatus.evictionPending;
      }
    }
  }

  // =========================
  // NOTICES (FULLY FIXED)
  // =========================

  void addVacateNotice(VacateNotice n) {
    vacateNotices.add(n);
  }

  void applyVacateNotice(VacateNotice n) {
    final h = getHouse(n.houseId);
    if (h != null) {
      h.status = HouseStatus.vacatingSoon;
      h.vacateNoticeDate = n.date;
    }
  }

  void addEvictionNotice(EvictionNotice n) {
    evictionNotices.add(n);
  }

  void applyEvictionNotice(EvictionNotice n) {
    final h = getHouse(n.houseId);
    if (h != null) {
      h.status = HouseStatus.evictionPending;
    }
  }
}