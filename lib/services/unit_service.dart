import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/unit.dart';

class UnitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collection = "units";

  /// Stream all units belonging to one building
  Stream<List<Unit>> getUnits(String buildingId) {
    return _firestore
        .collection(collection)
        .where('buildingId', isEqualTo: buildingId)
        .orderBy('unitNumber')
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

  /// Create a unit
  Future<void> addUnit(Unit unit) async {
    await _firestore
        .collection(collection)
        .doc(unit.id)
        .set(unit.toMap());
  }

  /// Update a unit
  Future<void> updateUnit(Unit unit) async {
    await _firestore
        .collection(collection)
        .doc(unit.id)
        .update(unit.toMap());
  }

  /// Delete a unit
  Future<void> deleteUnit(String id) async {
    await _firestore
        .collection(collection)
        .doc(id)
        .delete();
  }

  /// Vacant units
  Stream<int> vacantCount(String buildingId) {
    return _firestore
        .collection(collection)
        .where('buildingId', isEqualTo: buildingId)
        .where('occupied', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// Occupied units
  Stream<int> occupiedCount(String buildingId) {
    return _firestore
        .collection(collection)
        .where('buildingId', isEqualTo: buildingId)
        .where('occupied', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// Total units
  Stream<int> totalUnits(String buildingId) {
    return _firestore
        .collection(collection)
        .where('buildingId', isEqualTo: buildingId)
        .snapshots()
        .map((event) => event.docs.length);
  }
}