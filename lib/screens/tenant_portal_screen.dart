import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/lease_service.dart';
import '../services/payment_service.dart';
import '../services/receipt_service.dart';
import '../services/tenant_service.dart';
import '../services/building_service.dart';
import '../services/unit_service.dart';
import '../services/mpesa_service.dart';
import '../models/lease.dart';
import '../models/payment.dart';
import '../repositories/organization_repository.dart';
import 'lease/lease_signing_screen.dart';
import 'package:intl/intl.dart';

class TenantPortalScreen extends StatelessWidget {
  const TenantPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaseService = LeaseService();
    final paymentService = PaymentService();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tenant Portal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActiveLeaseSection(context, leaseService, userId),
            const SizedBox(height: 32),
            _buildPayRentButton(context, leaseService, userId),
            const SizedBox(height: 32),
            const Text("Your Payment Receipts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRecentPaymentsList(paymentService, userId),
          ],
        ),
      ),
    );
  }

  Widget _buildPayRentButton(BuildContext context, LeaseService leaseService, String userId) {
    return StreamBuilder<List<Lease>>(
      stream: leaseService.getTenantLeases(userId),
      builder: (context, snapshot) {
        final lease = (snapshot.data ?? []).isNotEmpty ? snapshot.data!.first : null;
        if (lease == null || !lease.isSigned) return const SizedBox();

        return Card(
          color: Colors.green[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green[200]!)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Current Rent Due", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("KES ${lease.monthlyRent.toStringAsFixed(0)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _initiateMpesaPayment(context, lease),
                  icon: const Icon(Icons.phone_android),
                  label: const Text("PAY WITH M-PESA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _initiateMpesaPayment(BuildContext context, Lease lease) async {
    final mpesa = MpesaService();
    // In a real app, you'd show a dialog to confirm the phone number
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sending M-Pesa STK Push...")));
    
    await mpesa.initiateStkPush(
      phone: "2547XXXXXXXX", // Should fetch from user profile
      amount: lease.monthlyRent,
      reference: lease.leaseNumber,
    );
  }

  Widget _buildActiveLeaseSection(BuildContext context, LeaseService leaseService, String userId) {
    return StreamBuilder<List<Lease>>(
      stream: leaseService.getTenantLeases(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox();
        final leases = snapshot.data ?? [];
        if (leases.isEmpty) return const Text("Welcome! Your active lease will appear here.");

        final latestLease = leases.first;
        return Card(
          child: ListTile(
            title: Text(latestLease.leaseNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(latestLease.isSigned ? "Signed & Active" : "Action Required: Sign Lease"),
            trailing: Icon(latestLease.isSigned ? Icons.check_circle : Icons.edit_note, color: latestLease.isSigned ? Colors.green : Colors.orange),
            onTap: () {
              if (!latestLease.isSigned) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => LeaseSigningScreen(lease: latestLease)));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentPaymentsList(PaymentService paymentService, String userId) {
    return StreamBuilder<List<Payment>>(
      stream: paymentService.getTenantPayments(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final payments = snapshot.data ?? [];
        if (payments.isEmpty) return const Text("No payments recorded yet.", style: TextStyle(color: Colors.grey));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final p = payments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.indigo),
                title: Text("KES ${p.amount.toStringAsFixed(0)}"),
                subtitle: Text(DateFormat('MMM d, yyyy').format(p.paymentDate)),
                trailing: const Icon(Icons.download, size: 20),
                onTap: () => _generateReceipt(context, p),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _generateReceipt(BuildContext context, Payment payment) async {
    try {
      final tenant = await TenantService().getTenant(payment.tenantId);
      final org = await OrganizationRepository.instance.findById(tenant!.organizationId);
      final building = await BuildingService().getBuilding(payment.buildingId).first;
      final units = await UnitService().getBuildingUnits(payment.buildingId).first;
      final unit = units.firstWhere((u) => u.id == payment.unitId);

      if (org != null && building != null) {
        await ReceiptService.generateAndShowReceipt(
          payment: payment,
          org: org,
          tenant: tenant,
          building: building,
          unit: unit,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error generating receipt: $e")));
    }
  }
}
