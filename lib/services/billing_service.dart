import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_collections.dart';
import '../models/invoice.dart';
import '../models/invoice_status.dart';
import '../models/lease.dart';
import 'session_service.dart';
import 'lease_service.dart';

class BillingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LeaseService _leaseService = LeaseService();

  CollectionReference<Map<String, dynamic>> get _invoices =>
      _firestore.collection(FirestoreCollections.invoices);

  String get _organizationId {
    final id = SessionService.instance.organizationId;
    if (id == null || id.isEmpty) throw Exception('No organization selected.');
    return id;
  }

  /// Automatically generates invoices for the current month for all active leases.
  /// This follows the principle: "Every feature must remove work from the user".
  Future<void> generateMonthlyInvoices() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // 1. Get all active leases for this organization
    final leases = await _leaseService.getLeases().first;
    final activeLeases = leases.where((l) => l.isActive).toList();

    for (final lease in activeLeases) {
      // 2. Check if an invoice already exists for this lease and month
      final existing = await _invoices
          .where('organizationId', isEqualTo: _organizationId)
          .where('leaseId', isEqualTo: lease.id)
          .where('periodStart', isEqualTo: firstDayOfMonth.toIso8601String())
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        // 3. Create new invoice
        final dueDate = DateTime(now.year, now.month, lease.billingDay);
        final invoiceId = const Uuid().v4();
        
        final invoice = Invoice(
          id: invoiceId,
          organizationId: _organizationId,
          buildingId: lease.buildingId,
          unitId: lease.unitId,
          tenantId: lease.tenantId,
          leaseId: lease.id,
          invoiceNumber: 'INV-${now.year}${now.month.toString().padLeft(2, '0')}-${lease.leaseNumber}',
          amount: lease.monthlyRent,
          amountPaid: 0,
          dueDate: dueDate,
          periodStart: firstDayOfMonth,
          periodEnd: lastDayOfMonth,
          status: InvoiceStatus.pending,
          createdAt: DateTime.now(),
        );

        await _invoices.doc(invoiceId).set(invoice.toMap());
      }
    }
  }

  Stream<List<Invoice>> getInvoices() {
    return _invoices
        .where('organizationId', isEqualTo: _organizationId)
        .orderBy('dueDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Invoice.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> updateInvoicePaidAmount(String invoiceId, double amount) async {
    final doc = await _invoices.doc(invoiceId).get();
    if (!doc.exists) return;

    final invoice = Invoice.fromMap(doc.id, doc.data()!);
    final newAmountPaid = invoice.amountPaid + amount;
    
    InvoiceStatus newStatus = invoice.status;
    if (newAmountPaid >= invoice.amount) {
      newStatus = InvoiceStatus.paid;
    } else if (newAmountPaid > 0) {
      newStatus = InvoiceStatus.partiallyPaid;
    }

    await _invoices.doc(invoiceId).update({
      'amountPaid': newAmountPaid,
      'status': newStatus.name,
    });
  }
}
