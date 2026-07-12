import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/building.dart';

class BuildingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Building>> getBuildings() {
    return _firestore
        .collection(FirestoreCollections.buildings)
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

  Future<void> addBuilding(Building building) async {
    await _firestore
        .collection(FirestoreCollections.buildings)
        .doc(building.id)
        .set(building.toMap());
  }

  Future<void> updateBuilding(Building building) async {
    await _firestore
        .collection(FirestoreCollections.buildings)
        .doc(building.id)
        .update(building.toMap());
  }

  Future<void> deleteBuilding(String id) async {
    await _firestore
        .collection(FirestoreCollections.buildings)
        .doc(id)
        .delete();
  }
}