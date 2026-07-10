import 'package:flutter/material.dart';
import '../data/payment_data.dart';
import '../data/tenant_data.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final amountController = TextEditingController();

  String? selectedTenant;

  void savePayment() {
    if (selectedTenant == null || amountController.text.isEmpty) return;

    final payment = {
      "tenantName": selectedTenant,
      "propertyName": "",
      "amount": int.tryParse(amountController.text) ?? 0,
      "date": DateTime.now().toString().split(" ")[0],
    };

    PaymentData.addPayment(payment);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tenants = TenantData.tenants;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: selectedTenant,
              items: tenants.map<DropdownMenuItem<String>>((t) {
                return DropdownMenuItem(
                  value: t['name'],
                  child: Text(t['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTenant = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Tenant',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount Paid',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: savePayment,
                child: const Text('Save Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}