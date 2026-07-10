import 'package:flutter/material.dart';
import '../data/payment_data.dart';
import 'add_payment_screen.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    final payments = PaymentData.payments;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: payments.isEmpty
          ? const Center(child: Text('No payments yet'))
          : ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.receipt),
              title: Text(payment['tenantName']),
              subtitle: Text(
                'KES ${payment['amount']} • ${payment['date']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  PaymentData.deletePayment(index);
                  setState(() {});
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPaymentScreen(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}