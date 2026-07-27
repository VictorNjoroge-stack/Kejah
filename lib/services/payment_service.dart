import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/payment.dart';
import 'session_service.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _payments =>
      _firestore.collection(FirestoreCollections.payments);

  String get _organizationId {
    final id = SessionService.instance.organizationId;

    if (id == null || id.isEmpty) {
      throw Exception('No organization selected.');
    }

    return id;
  }

  // =====================================================
  // STREAMS
  // =====================================================

  Stream<List<Payment>> getPayments() {
    return _payments
        .where('organizationId', isEqualTo: _organizationId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Payment.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Payment>> getTenantPayments(
      String tenantId,
      ) {
    return _payments
        .where('organizationId', isEqualTo: _organizationId)
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Payment.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<Payment>> getBuildingPayments(
      String buildingId,
      ) {
    return _payments
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Payment.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // =====================================================
  // CRUD
  // =====================================================

  Future<void> addPayment(
      Payment payment,
      ) async {
    await _payments.doc(payment.id).set(
      payment.toMap(),
    );
  }

  Future<void> updatePayment(
      Payment payment,
      ) async {
    await _payments.doc(payment.id).update(
      payment.toMap(),
    );
  }

  Future<void> deletePayment(
      String id,
      ) async {
    await _payments.doc(id).delete();
  }

  // =====================================================
  // REPORTING
  // =====================================================

  Future<double> getTenantTotalPaid(
      String tenantId,
      ) async {
    final snapshot = await _payments
        .where('organizationId', isEqualTo: _organizationId)
        .where('tenantId', isEqualTo: tenantId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }

    return total;
  }

  Future<double> getBuildingRevenue(
      String buildingId,
      ) async {
    final snapshot = await _payments
        .where('organizationId', isEqualTo: _organizationId)
        .where('buildingId', isEqualTo: buildingId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }

    return total;
  }

  Future<double> getTotalRevenue() async {
    final snapshot = await _payments
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }

    return total;
  }
}