import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/tenant.dart';

class TenantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tenants =>
      _firestore.collection(FirestoreCollections.tenants);

  // ===============================
  // Get All Tenants
  // ===============================

  Stream<List<Tenant>> getTenants() {
    return _tenants.snapshots().map(
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

  // ===============================
  // Get Tenants By Building
  // ===============================

  Stream<List<Tenant>> getBuildingTenants(String buildingId) {
    return _tenants
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
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

  // ===============================
  // Get Tenants By Unit
  // ===============================

  Stream<List<Tenant>> getUnitTenants(String unitId) {
    return _tenants
        .where(
      'unitId',
      isEqualTo: unitId,
    )
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

  // ===============================
  // Add Tenant
  // ===============================

  Future<void> addTenant(Tenant tenant) async {
    await _tenants.doc(tenant.id).set(tenant.toMap());
  }

  // ===============================
  // Update Tenant
  // ===============================

  Future<void> updateTenant(Tenant tenant) async {
    await _tenants.doc(tenant.id).update(tenant.toMap());
  }

  // ===============================
  // Delete Tenant
  // ===============================

  Future<void> deleteTenant(String id) async {
    await _tenants.doc(id).delete();
  }
}