import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_collections.dart';
import '../models/payment.dart';
import 'session_service.dart';
import 'billing_service.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BillingService _billingService = BillingService();

  CollectionReference<Map<String, dynamic>> get _payments =>
      _firestore.collection(FirestoreCollections.payments);

  String get _organizationId {
    final id = SessionService.instance.organizationId;
    if (id == null || id.isEmpty) throw Exception('No organization selected.');
    return id;
  }

  Stream<List<Payment>> getPayments() {
    return _payments
        .where('organizationId', isEqualTo: _organizationId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Payment>> getTenantPayments(String tenantId) {
    return _payments
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Records a payment and updates the corresponding invoice balance.
  /// Rule 1: No duplicated data. Rule 5: Business workflow.
  Future<void> recordPayment({
    required Payment payment,
    String? invoiceId,
  }) async {
    final batch = _firestore.batch();

    // 1. Save the payment
    final paymentDoc = _payments.doc(payment.id);
    batch.set(paymentDoc, payment.toMap());

    // 2. If linked to an invoice, update the invoice
    if (invoiceId != null) {
      final invoiceDoc = _firestore.collection(FirestoreCollections.invoices).doc(invoiceId);
      final invoiceData = await invoiceDoc.get();
      
      if (invoiceData.exists) {
        final currentPaid = (invoiceData.data()?['amountPaid'] ?? 0).toDouble();
        final amount = (invoiceData.data()?['amount'] ?? 0).toDouble();
        final newPaid = currentPaid + payment.amount;
        
        String status = 'partiallyPaid';
        if (newPaid >= amount) {
          status = 'paid';
        }

        batch.update(invoiceDoc, {
          'amountPaid': newPaid,
          'status': status,
        });
      }
    }

    await batch.commit();
  }

  Future<void> deletePayment(String id) async {
    await _payments.doc(id).delete();
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

  Future<List<double>> getMonthlyRevenue({int months = 6}) async {
    final snapshot = await _payments
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    final now = DateTime.now();
    final revenue = List<double>.filled(months, 0);

    for (final doc in snapshot.docs) {
      final payment = Payment.fromMap(doc.id, doc.data());
      final difference = (now.year - payment.paymentDate.year) * 12 +
          (now.month - payment.paymentDate.month);

      if (difference >= 0 && difference < months) {
        final index = months - difference - 1;
        revenue[index] += payment.amount;
      }
    }
    return revenue;
  }
}
