import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/unit.dart';
import '../models/unit_status.dart';
import 'session_service.dart';

class UnitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _units =>
      _firestore.collection(FirestoreCollections.units);

  String get _organizationId {
    final id = SessionService.instance.organizationId;

    if (id == null || id.isEmpty) {
      throw Exception('No organization is currently selected.');
    }

    return id;
  }

  // =====================================================
  // STREAMS
  // =====================================================

  Stream<List<Unit>> getUnits() {
    return _units
        .where('organizationId', isEqualTo: _organizationId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Unit>> getBuildingUnits(String buildingId) {
    return _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // CRUD
  // =====================================================

  Future<void> addUnit(Unit unit) async {
    await _units.doc(unit.id).set(unit.toMap());
  }

  Future<void> updateUnit(Unit unit) async {
    await _units.doc(unit.id).update(unit.toMap());
  }

  Future<void> deleteUnit(String id) async {
    await _units.doc(id).delete();
  }

  // =====================================================
  // TENANT
  // =====================================================

  Future<void> assignTenant({
    required String unitId,
    required String tenantId,
  }) async {
    await _units.doc(unitId).update({
      'tenantId': tenantId,
      'status': UnitStatus.occupied.name,
    });
  }

  Future<void> vacateUnit(String unitId) async {
    await _units.doc(unitId).update({
      'tenantId': '',
      'status': UnitStatus.vacant.name,
    });
  }

  // =====================================================
  // COUNTS
  // =====================================================

  Future<int> getTotalUnits() async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getOccupiedCount() async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('status', isEqualTo: UnitStatus.occupied.name)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getVacantCount() async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('status', isEqualTo: UnitStatus.vacant.name)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getBuildingTotalUnits(String buildingId) async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getBuildingOccupiedUnits(String buildingId) async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .where('status', isEqualTo: UnitStatus.occupied.name)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getBuildingVacantUnits(String buildingId) async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .where('status', isEqualTo: UnitStatus.vacant.name)
        .get();

    return snapshot.docs.length;
  }

  // =====================================================
  // REVENUE
  // =====================================================

  Future<double> getMonthlyRevenue() async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['monthlyRent'] ?? 0).toDouble();
    }

    return total;
  }

  Future<double> getBuildingRevenue(String buildingId) async {
    final snapshot = await _units
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['monthlyRent'] ?? 0).toDouble();
    }

    return total;
  }

  // =====================================================
  // OCCUPANCY
  // =====================================================

  Future<double> getOccupancyRate() async {
    final total = await getTotalUnits();

    if (total == 0) return 0;

    final occupied = await getOccupiedCount();

    return (occupied / total) * 100;
  }

  Future<double> getBuildingOccupancyRate(
      String buildingId,
      ) async {
    final total = await getBuildingTotalUnits(buildingId);

    if (total == 0) return 0;

    final occupied = await getBuildingOccupiedUnits(buildingId);

    return (occupied / total) * 100;
  }
}