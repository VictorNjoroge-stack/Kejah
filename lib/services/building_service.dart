import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/building.dart';
import 'session_service.dart';

class BuildingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _buildings =>
      _firestore.collection(FirestoreCollections.buildings);

  String get _organizationId {
    final id = SessionService.instance.organizationId;

    if (id == null || id.isEmpty) {
      throw Exception('No organization is currently selected.');
    }

    return id;
  }

  // =====================================================
  // Buildings
  // =====================================================

  Stream<List<Building>> getBuildings() {
    return _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Building.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Building>> getActiveBuildings() {
    return _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Building.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<Building?> getBuilding(String id) {
    return _buildings.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;

      final building = Building.fromMap(
        doc.id,
        doc.data()!,
      );

      if (building.organizationId != _organizationId) {
        return null;
      }

      return building;
    });
  }

  Future<void> addBuilding(Building building) async {
    await _buildings.doc(building.id).set(
      building.toMap(),
    );
  }

  Future<void> updateBuilding(Building building) async {
    await _buildings.doc(building.id).update(
      building.toMap(),
    );
  }

  Future<void> deleteBuilding(String id) async {
    await _buildings.doc(id).delete();
  }

  Future<void> setBuildingActive(
      String id,
      bool active,
      ) async {
    await _buildings.doc(id).update({
      'active': active,
    });
  }

  Future<List<Building>> searchBuildings(
      String query,
      ) async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    return snapshot.docs
        .map(
          (doc) => Building.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .where(
          (building) => building.name
          .toLowerCase()
          .contains(query.toLowerCase()),
    )
        .toList();
  }

  // =====================================================
  // Statistics
  // =====================================================

  Future<int> totalBuildings() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    return snapshot.docs.length;
  }

  Future<int> totalUnits() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    int total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['totalUnits'] ?? 0) as int;
    }

    return total;
  }

  Future<double> totalMonthlyRevenue() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['monthlyRevenue'] ?? 0).toDouble();
    }

    return total;
  }

  Future<double> totalExpectedRevenue() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['expectedRevenue'] ?? 0).toDouble();
    }

    return total;
  }

  Future<int> totalOccupiedUnits() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    int total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['occupiedUnits'] ?? 0) as int;
    }

    return total;
  }

  Future<int> totalVacantUnits() async {
    final snapshot = await _buildings
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    int total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['vacantUnits'] ?? 0) as int;
    }

    return total;
  }
}