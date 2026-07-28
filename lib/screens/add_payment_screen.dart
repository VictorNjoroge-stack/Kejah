import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/payment.dart';
import '../models/invoice.dart';
import '../models/invoice_status.dart';
import '../services/payment_service.dart';
import '../services/billing_service.dart';
import '../services/session_service.dart';
import 'package:intl/intl.dart';

class AddPaymentScreen extends StatefulWidget {
  final Invoice? initialInvoice;

  const AddPaymentScreen({super.key, this.initialInvoice});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _paymentService = PaymentService();
  final _billingService = BillingService();

  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String _paymentMethod = 'M-Pesa';
  DateTime _paymentDate = DateTime.now();
  
  Invoice? _selectedInvoice;
  List<Invoice> _unpaidInvoices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedInvoice = widget.initialInvoice;
    if (_selectedInvoice != null) {
      _amountController.text = _selectedInvoice!.balance.toString();
    }
    _loadUnpaidInvoices();
  }

  Future<void> _loadUnpaidInvoices() async {
    _billingService.getInvoices().listen((invoices) {
      if (mounted) {
        setState(() {
          _unpaidInvoices = invoices.where((inv) => !inv.isPaid).toList();
        });
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInvoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an invoice')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final orgId = SessionService.instance.organizationId!;
      final amount = double.parse(_amountController.text);
      
      final payment = Payment(
        id: const Uuid().v4(),
        organizationId: orgId,
        tenantId: _selectedInvoice!.tenantId,
        buildingId: _selectedInvoice!.buildingId,
        unitId: _selectedInvoice!.unitId,
        amount: amount,
        paymentMethod: _paymentMethod,
        reference: _referenceController.text.trim(),
        notes: _notesController.text.trim(),
        paymentDate: _paymentDate,
        createdAt: DateTime.now(),
      );

      await _paymentService.recordPayment(
        payment: payment,
        invoiceId: _selectedInvoice!.id,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<Invoice>(
                    value: _selectedInvoice,
                    decoration: const InputDecoration(labelText: 'Select Invoice / Arrear'),
                    items: _unpaidInvoices.map((inv) {
                      return DropdownMenuItem(
                        value: inv,
                        child: Text('${inv.invoiceNumber} - Bal: KES ${inv.balance.toStringAsFixed(0)}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedInvoice = val;
                        if (val != null) _amountController.text = val.balance.toString();
                      });
                    },
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount Paid (KES)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    decoration: const InputDecoration(labelText: 'Payment Method'),
                    items: ['M-Pesa', 'Cash', 'Bank Transfer', 'Cheque'].map((m) {
                      return DropdownMenuItem(value: m, child: Text(m));
                    }).toList(),
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _referenceController,
                    decoration: const InputDecoration(labelText: 'Reference Number / Transaction ID'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Payment Date'),
                    subtitle: Text(DateFormat('MMM d, yyyy').format(_paymentDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _paymentDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _paymentDate = picked);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Record Payment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
