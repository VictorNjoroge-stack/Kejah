import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/unit.dart';
import '../models/unit_status.dart';

class UnitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collection = "units";

  /// ===============================
  /// Add Unit
  /// ===============================

  Future<void> addUnit(Unit unit) async {
    await _firestore
        .collection(collection)
        .doc(unit.id)
        .set(unit.toMap());
  }

  /// ===============================
  /// Update Unit
  /// ===============================

  Future<void> updateUnit(Unit unit) async {
    await _firestore
        .collection(collection)
        .doc(unit.id)
        .update(unit.toMap());
  }

  /// ===============================
  /// Delete Unit
  /// ===============================

  Future<void> deleteUnit(String id) async {
    await _firestore
        .collection(collection)
        .doc(id)
        .delete();
  }

  /// ===============================
  /// Get All Units
  /// ===============================

  Stream<List<Unit>> getUnits() {
    return _firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    });
  }

  /// ===============================
  /// Units For One Building
  /// ===============================

  Stream<List<Unit>> getBuildingUnits(
      String buildingId,
      ) {
    return _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    });
  }

  /// ===============================
  /// Vacant Units
  /// ===============================

  Stream<List<Unit>> getVacantUnits(
      String buildingId,
      ) {
    return _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .where(
      "status",
      isEqualTo: UnitStatus.vacant.name,
    )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    });
  }

  /// ===============================
  /// Occupied Units
  /// ===============================

  Stream<List<Unit>> getOccupiedUnits(
      String buildingId,
      ) {
    return _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .where(
      "status",
      isEqualTo: UnitStatus.occupied.name,
    )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Unit.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    });
  }

  /// ===============================
  /// Occupancy %
  /// ===============================

  Future<double> getOccupancyRate(
      String buildingId,
      ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    int occupied = snapshot.docs.where((doc) {
      return doc["status"] ==
          UnitStatus.occupied.name;
    }).length;

    return (occupied / snapshot.docs.length) * 100;
  }

  /// ===============================
  /// Monthly Revenue
  /// ===============================

  Future<double> getMonthlyRevenue(
      String buildingId,
      ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .get();

    double revenue = 0;

    for (var doc in snapshot.docs) {
      revenue +=
          (doc["monthlyRent"] ?? 0)
              .toDouble();
    }

    return revenue;
  }

  /// ===============================
  /// Vacant Count
  /// ===============================

  Future<int> getVacantCount(
      String buildingId,
      ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .where(
      "status",
      isEqualTo: UnitStatus.vacant.name,
    )
        .get();

    return snapshot.docs.length;
  }

  /// ===============================
  /// Occupied Count
  /// ===============================

  Future<int> getOccupiedCount(
      String buildingId,
      ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .where(
      "status",
      isEqualTo: UnitStatus.occupied.name,
    )
        .get();

    return snapshot.docs.length;
  }

  /// ===============================
  /// Total Units
  /// ===============================

  Future<int> getTotalUnits(
      String buildingId,
      ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where(
      "buildingId",
      isEqualTo: buildingId,
    )
        .get();

    return snapshot.docs.length;
  }
}