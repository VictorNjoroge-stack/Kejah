import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/building.dart';

class BuildingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Building>> getBuildings() {
    return _firestore
        .collection('buildings')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Building.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> addBuilding(Building building) async {
    await _firestore
        .collection('buildings')
        .doc(building.id)
        .set(building.toMap());
  }

  Future<void> updateBuilding(Building building) async {
    await _firestore
        .collection('buildings')
        .doc(building.id)
        .update(building.toMap());
  }

  Future<void> deleteBuilding(String id) async {
    await _firestore
        .collection('buildings')
        .doc(id)
        .delete();
  }
}