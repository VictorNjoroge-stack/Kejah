import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_collections.dart';
import 'session_service.dart';
import '../models/payment.dart';
import '../models/maintenance.dart';
import '../models/maintenance_status.dart';

class FinancialReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _organizationId {
    final id = SessionService.instance.organizationId;
    if (id == null || id.isEmpty) throw Exception('No organization selected.');
    return id;
  }

  Future<Map<String, double>> getTaxSummary({required DateTime start, required DateTime end}) async {
    double totalIncome = 0;
    double totalExpenses = 0;

    // 1. Fetch all payments in period (Income)
    final paymentsSnapshot = await _firestore
        .collection(FirestoreCollections.payments)
        .where('organizationId', isEqualTo: _organizationId)
        .where('paymentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('paymentDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    for (var doc in paymentsSnapshot.docs) {
      totalIncome += (doc.data()['amount'] ?? 0).toDouble();
    }

    // 2. Fetch all completed maintenance in period (Expenses)
    final maintenanceSnapshot = await _firestore
        .collection(FirestoreCollections.maintenance)
        .where('organizationId', isEqualTo: _organizationId)
        .where('status', isEqualTo: MaintenanceStatus.completed.name)
        .where('reportedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start)) // Note: ideally we'd use completedAt but let's use reportedAt for now if completedAt is null
        .get();

    for (var doc in maintenanceSnapshot.docs) {
      totalExpenses += (doc.data()['actualCost'] ?? 0).toDouble();
    }

    return {
      'income': totalIncome,
      'expenses': totalExpenses,
      'net': totalIncome - totalExpenses,
    };
  }
}
