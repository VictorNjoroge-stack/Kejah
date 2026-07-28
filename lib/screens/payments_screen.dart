import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../models/invoice.dart';
import '../models/invoice_status.dart';
import '../services/payment_service.dart';
import '../services/billing_service.dart';
import '../services/receipt_service.dart';
import '../services/session_service.dart';
import '../services/tenant_service.dart';
import '../services/building_service.dart';
import '../services/unit_service.dart';
import 'add_payment_screen.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PaymentService _paymentService = PaymentService();
  final BillingService _billingService = BillingService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Center"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Invoices & Arrears"),
            Tab(text: "Payment History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvoicesTab(),
          _buildPaymentsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Record Payment"),
      ),
    );
  }

  Widget _buildInvoicesTab() {
    return StreamBuilder<List<Invoice>>(
      stream: _billingService.getInvoices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final invoices = snapshot.data ?? [];
        if (invoices.isEmpty) {
          return const Center(child: Text("No invoices found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final inv = invoices[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Due: ${DateFormat('MMM d, yyyy').format(inv.dueDate)}"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("KES ${inv.balance.toStringAsFixed(0)}", 
                      style: TextStyle(
                        color: inv.isPaid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _statusChip(inv.status),
                  ],
                ),
                onTap: () {
                  // TODO: View invoice details
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentsTab() {
    return StreamBuilder<List<Payment>>(
      stream: _paymentService.getPayments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final payments = snapshot.data ?? [];
        if (payments.isEmpty) {
          return const Center(child: Text("No payments recorded."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final p = payments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.payments_outlined)),
                title: Text("KES ${p.amount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${p.paymentMethod} - ${DateFormat('MMM d, yyyy').format(p.paymentDate)}"),
                trailing: IconButton(
                  icon: const Icon(Icons.receipt_long_outlined, color: Colors.indigo),
                  onPressed: () => _generateReceipt(p),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _generateReceipt(Payment payment) async {
    try {
      final org = SessionService.instance.organization!;
      final tenant = await TenantService().getTenant(payment.tenantId);
      final building = await BuildingService().getBuilding(payment.buildingId).first;
      final units = await UnitService().getBuildingUnits(payment.buildingId).first;
      final unit = units.firstWhere((u) => u.id == payment.unitId);

      if (tenant != null && building != null) {
        await ReceiptService.generateAndShowReceipt(
          payment: payment,
          org: org,
          tenant: tenant,
          building: building,
          unit: unit,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error generating receipt: $e")));
      }
    }
  }

  Widget _statusChip(InvoiceStatus status) {
    Color color = Colors.grey;
    if (status == InvoiceStatus.paid) color = Colors.green;
    if (status == InvoiceStatus.pending) color = Colors.orange;
    if (status == InvoiceStatus.partiallyPaid) color = Colors.blue;
    if (status == InvoiceStatus.overdue) color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
