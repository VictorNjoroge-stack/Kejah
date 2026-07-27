import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/organization.dart';

class OrganizationService {
  OrganizationService._();

  static final OrganizationService instance =
  OrganizationService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _organizations =>
      _firestore.collection('organizations');

  Future<Organization?> getOrganization(String id) async {
    final doc = await _organizations.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return Organization.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  Future<void> createOrganization(
      Organization organization,
      ) async {
    await _organizations
        .doc(organization.id)
        .set(organization.toMap());
  }

  Future<void> updateOrganization(
      Organization organization,
      ) async {
    await _organizations
        .doc(organization.id)
        .update(organization.toMap());
  }

  Future<void> archiveOrganization(
      String organizationId,
      ) async {
    await _organizations.doc(organizationId).update({
      'isArchived': true,
    });
  }

  Stream<Organization?> watchOrganization(
      String organizationId,
      ) {
    return _organizations
        .doc(organizationId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return null;
      }

      return Organization.fromMap(
        doc.data()!,
        doc.id,
      );
    });
  }
}