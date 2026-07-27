import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/lease.dart';
import '../models/lease_status.dart';
import 'session_service.dart';

class LeaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _leases =>
      _firestore.collection(FirestoreCollections.leases);

  String get _organizationId {
    final id = SessionService.instance.organizationId;

    if (id == null || id.isEmpty) {
      throw Exception('No organization selected.');
    }

    return id;
  }

  // =====================================================
  // ALL LEASES
  // =====================================================

  Stream<List<Lease>> getLeases() {
    return _leases
        .where('organizationId', isEqualTo: _organizationId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Lease.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // BUILDING LEASES
  // =====================================================

  Stream<List<Lease>> getBuildingLeases(
      String buildingId,
      ) {
    return _leases
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Lease.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // UNIT LEASES
  // =====================================================

  Stream<List<Lease>> getUnitLeases(
      String unitId,
      ) {
    return _leases
        .where('organizationId', isEqualTo: _organizationId)
        .where('unitId', isEqualTo: unitId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Lease.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // TENANT LEASES
  // =====================================================

  Stream<List<Lease>> getTenantLeases(
      String tenantId,
      ) {
    return _leases
        .where('organizationId', isEqualTo: _organizationId)
        .where('tenantId', isEqualTo: tenantId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Lease.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // ACTIVE LEASE
  // =====================================================

  Future<Lease?> getActiveLease(
      String unitId,
      ) async {
    final snapshot = await _leases
        .where('organizationId', isEqualTo: _organizationId)
        .where('unitId', isEqualTo: unitId)
        .where('status', isEqualTo: LeaseStatus.active.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Lease.fromMap(
      snapshot.docs.first.id,
      snapshot.docs.first.data(),
    );
  }

  // =====================================================
  // CRUD
  // =====================================================

  Future<void> addLease(
      Lease lease,
      ) async {
    await _leases.doc(lease.id).set(
      lease.toMap(),
    );
  }

  Future<void> updateLease(
      Lease lease,
      ) async {
    await _leases.doc(lease.id).update(
      lease.toMap(),
    );
  }

  Future<void> deleteLease(
      String id,
      ) async {
    await _leases.doc(id).delete();
  }

  // =====================================================
  // STATUS
  // =====================================================

  Future<void> expireLease(
      String id,
      ) async {
    await _leases.doc(id).update({
      'status': LeaseStatus.expired.name,
    });
  }

  Future<void> terminateLease(
      String id,
      ) async {
    await _leases.doc(id).update({
      'status': LeaseStatus.terminated.name,
    });
  }
}