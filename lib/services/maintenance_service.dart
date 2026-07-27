import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/maintenance.dart';
import '../models/maintenance_status.dart';
import 'session_service.dart';

class MaintenanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _maintenance =>
      _firestore.collection(FirestoreCollections.maintenance);

  String get _organizationId {
    final id = SessionService.instance.organizationId;

    if (id == null || id.isEmpty) {
      throw Exception('No organization selected.');
    }

    return id;
  }

  Stream<List<Maintenance>> getRequests() {
    return _maintenance
        .where('organizationId', isEqualTo: _organizationId)
        .orderBy('reportedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Maintenance.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<Maintenance>> getBuildingRequests(
      String buildingId,
      ) {
    return _maintenance
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .orderBy('reportedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Maintenance.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<Maintenance>> getUnitRequests(
      String unitId,
      ) {
    return _maintenance
        .where('organizationId', isEqualTo: _organizationId)
        .where('unitId', isEqualTo: unitId)
        .orderBy('reportedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Maintenance.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<void> addRequest(
      Maintenance request,
      ) async {
    await _maintenance.doc(request.id).set(request.toMap());
  }

  Future<void> updateRequest(
      Maintenance request,
      ) async {
    await _maintenance.doc(request.id).update(request.toMap());
  }

  Future<void> deleteRequest(
      String id,
      ) async {
    await _maintenance.doc(id).delete();
  }

  Future<void> updateStatus(
      String id,
      MaintenanceStatus status,
      ) async {
    final data = {
      'status': status.name,
    };

    if (status == MaintenanceStatus.completed) {
      data['completedAt'] = DateTime.now().toIso8601String();
    }

    await _maintenance.doc(id).update(data);
  }

  Future<int> getOpenRequestCount() async {
    final snapshot = await _maintenance
        .where('organizationId', isEqualTo: _organizationId)
        .where('status',
        isNotEqualTo: MaintenanceStatus.completed.name)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getCompletedRequestCount() async {
    final snapshot = await _maintenance
        .where('organizationId', isEqualTo: _organizationId)
        .where('status',
        isEqualTo: MaintenanceStatus.completed.name)
        .get();

    return snapshot.docs.length;
  }
}