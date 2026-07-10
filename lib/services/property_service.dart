import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/property.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Property>> getProperties() {
    return _firestore
        .collection('properties')
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Property.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> addProperty(Property property) async {
    await _firestore.collection('properties').add(
      property.toMap(),
    );
  }

  Future<void> updateProperty(Property property) async {
    await _firestore
        .collection('properties')
        .doc(property.id)
        .update(property.toMap());
  }

  Future<void> deleteProperty(String id) async {
    await _firestore
        .collection('properties')
        .doc(id)
        .delete();
  }
}