import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/unit.dart';
import '../models/unit_status.dart';

class UnitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _units =>
      _firestore.collection(FirestoreCollections.units);

  // ===============================
  // Add Unit
  // ===============================

  Future<void> addUnit(Unit unit) async {
    await _units.doc(unit.id).set(unit.toMap());
  }

  // ===============================
  // Update Unit
  // ===============================

  Future<void> updateUnit(Unit unit) async {
    await _units.doc(unit.id).update(unit.toMap());
  }

  // ===============================
  // Delete Unit
  // ===============================

  Future<void> deleteUnit(String id) async {
    await _units.doc(id).delete();
  }

  // ===============================
  // All Units
  // ===============================

  Stream<List<Unit>> getUnits() {
    return _units.snapshots().map(
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

  // ===============================
  // Units For One Building
  // ===============================

  Stream<List<Unit>> getBuildingUnits(String buildingId) {
    return _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
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

  // ===============================
  // Vacant Units
  // ===============================

  Stream<List<Unit>> getVacantUnits(String buildingId) {
    return _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .where(
      'status',
      isEqualTo: UnitStatus.vacant.name,
    )
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

  // ===============================
  // Occupied Units
  // ===============================

  Stream<List<Unit>> getOccupiedUnits(String buildingId) {
    return _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .where(
      'status',
      isEqualTo: UnitStatus.occupied.name,
    )
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

  // ===============================
  // Occupancy %
  // ===============================

  Future<double> getOccupancyRate(String buildingId) async {
    final snapshot = await _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final occupied = snapshot.docs.where(
          (doc) => doc.data()['status'] == UnitStatus.occupied.name,
    );

    return (occupied.length / snapshot.docs.length) * 100;
  }

  // ===============================
  // Monthly Revenue
  // ===============================

  Future<double> getMonthlyRevenue(String buildingId) async {
    final snapshot = await _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .get();

    double revenue = 0;

    for (final doc in snapshot.docs) {
      revenue += (doc.data()['monthlyRent'] ?? 0).toDouble();
    }

    return revenue;
  }

  // ===============================
  // Vacant Count
  // ===============================

  Future<int> getVacantCount(String buildingId) async {
    final snapshot = await _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .where(
      'status',
      isEqualTo: UnitStatus.vacant.name,
    )
        .get();

    return snapshot.docs.length;
  }

  // ===============================
  // Occupied Count
  // ===============================

  Future<int> getOccupiedCount(String buildingId) async {
    final snapshot = await _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .where(
      'status',
      isEqualTo: UnitStatus.occupied.name,
    )
        .get();

    return snapshot.docs.length;
  }

  // ===============================
  // Total Units
  // ===============================

  Future<int> getTotalUnits(String buildingId) async {
    final snapshot = await _units
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .get();

    return snapshot.docs.length;
  }
}