import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/organization.dart';

class OrganizationRepository {
  OrganizationRepository._();

  static final OrganizationRepository instance =
  OrganizationRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(
        FirestoreCollections.organizations,
      );

  /// Create or overwrite an organization
  Future<void> save(
      Organization organization,
      ) async {
    await _collection.doc(organization.id).set(
      organization.toMap(),
      SetOptions(merge: true),
    );
  }

  /// Find one organization
  Future<Organization?> findById(
      String organizationId,
      ) async {
    final snapshot =
    await _collection.doc(organizationId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return Organization.fromMap(
      snapshot.data()!,
      snapshot.id,
    );
  }

  /// Get all organizations
  Future<List<Organization>> getAll() async {
    final snapshot = await _collection.get();

    return snapshot.docs
        .map(
          (doc) => Organization.fromMap(
        doc.data(),
        doc.id,
      ),
    )
        .toList();
  }

  /// Watch all organizations
  Stream<List<Organization>> watchAll() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Organization.fromMap(
          doc.data(),
          doc.id,
        ),
      )
          .toList(),
    );
  }

  /// Watch a single organization
  Stream<Organization?> watch(
      String organizationId,
      ) {
    return _collection
        .doc(organizationId)
        .snapshots()
        .map(
          (doc) {
        if (!doc.exists || doc.data() == null) {
          return null;
        }

        return Organization.fromMap(
          doc.data()!,
          doc.id,
        );
      },
    );
  }

  /// Update an organization
  Future<void> update(
      Organization organization,
      ) async {
    await _collection.doc(organization.id).update(
      organization.toMap(),
    );
  }

  /// Archive (soft delete)
  Future<void> archive(
      String organizationId,
      ) async {
    await _collection.doc(organizationId).update({
      'isArchived': true,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Permanently delete
  Future<void> delete(
      String organizationId,
      ) async {
    await _collection.doc(organizationId).delete();
  }
}