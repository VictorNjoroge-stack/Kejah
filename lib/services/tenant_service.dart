import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/tenant.dart';
import 'session_service.dart';

class TenantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tenants =>
      _firestore.collection(FirestoreCollections.tenants);

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

  Stream<List<Tenant>> getTenants() {
    return _tenants
        .where('organizationId', isEqualTo: _organizationId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Tenant.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Tenant>> getBuildingTenants(String buildingId) {
    return _tenants
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Tenant.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Tenant>> getUnitTenants(String unitId) {
    return _tenants
        .where('organizationId', isEqualTo: _organizationId)
        .where('unitId', isEqualTo: unitId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Tenant.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // SINGLE TENANT
  // =====================================================

  Stream<Tenant?> getTenantByUnit(String unitId) {
    return _tenants
        .where('organizationId', isEqualTo: _organizationId)
        .where('unitId', isEqualTo: unitId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      return Tenant.fromMap(
        snapshot.docs.first.id,
        snapshot.docs.first.data(),
      );
    });
  }

  Future<Tenant?> getTenant(String tenantId) async {
    final doc = await _tenants.doc(tenantId).get();

    if (!doc.exists) {
      return null;
    }

    final tenant = Tenant.fromMap(
      doc.id,
      doc.data()!,
    );

    if (tenant.organizationId != _organizationId) {
      return null;
    }

    return tenant;
  }

  // =====================================================
  // CRUD
  // =====================================================

  Future<void> addTenant(Tenant tenant) async {
    await _tenants.doc(tenant.id).set(
      tenant.toMap(),
    );
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _tenants.doc(tenant.id).update(
      tenant.toMap(),
    );
  }

  Future<void> deleteTenant(String id) async {
    await _tenants.doc(id).delete();
  }
}