import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/payment.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _payments =>
      _firestore.collection(FirestoreCollections.payments);

  // ===============================
  // Get All Payments
  // ===============================

  Stream<List<Payment>> getPayments() {
    return _payments.snapshots().map(
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

  // ===============================
  // Payments For One Building
  // ===============================

  Stream<List<Payment>> getBuildingPayments(String buildingId) {
    return _payments
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
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

  // ===============================
  // Payments For One Tenant
  // ===============================

  Stream<List<Payment>> getTenantPayments(String tenantId) {
    return _payments
        .where(
      'tenantId',
      isEqualTo: tenantId,
    )
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

  // ===============================
  // Add Payment
  // ===============================

  Future<void> addPayment(Payment payment) async {
    await _payments.doc(payment.id).set(payment.toMap());
  }

  // ===============================
  // Update Payment
  // ===============================

  Future<void> updatePayment(Payment payment) async {
    await _payments.doc(payment.id).update(payment.toMap());
  }

  // ===============================
  // Delete Payment
  // ===============================

  Future<void> deletePayment(String id) async {
    await _payments.doc(id).delete();
  }

  // ===============================
  // Total Revenue For Building
  // ===============================

  Future<double> getBuildingRevenue(String buildingId) async {
    final snapshot = await _payments
        .where(
      'buildingId',
      isEqualTo: buildingId,
    )
        .get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }

    return total;
  }
}