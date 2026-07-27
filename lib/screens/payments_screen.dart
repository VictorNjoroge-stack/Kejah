import 'package:flutter/material.dart';

import '../models/payment.dart';
import '../services/payment_service.dart';

class PaymentsScreen extends StatelessWidget {
PaymentsScreen({super.key});

final PaymentService _service = PaymentService();

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Payments"),
),
body: StreamBuilder<List<Payment>>(
stream: _service.getPayments(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

final payments = snapshot.data ?? [];

if (payments.isEmpty) {
return const Center(
child: Text(
"No payments recorded.",
style: TextStyle(fontSize: 18),
),
);
}

return ListView.separated(
padding: const EdgeInsets.all(16),
separatorBuilder: (_, _) =>
const SizedBox(height: 12),
itemCount: payments.length,
itemBuilder: (context, index) {
final payment = payments[index];

return Card(
elevation: 3,
child: Padding(
padding:
const EdgeInsets.all(16),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
const CircleAvatar(
child: Icon(
Icons.payments,
),
),

const SizedBox(width: 12),

Expanded(
child: Text(
"KES ${payment.amount.toStringAsFixed(0)}",
style:
const TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),
),

Chip(
label: Text(
payment.paymentMethod,
),
),
],
),

const SizedBox(height: 16),

_row(
"Tenant ID",
payment.tenantId,
),

_row(
"Building ID",
payment.buildingId,
),

_row(
"Unit ID",
payment.unitId,
),

_row(
"Reference",
payment.reference.isEmpty
? "-"
: payment.reference,
),

_row(
"Payment Date",
payment.paymentDate
.toLocal()
.toString()
.split(" ")
.first,
),

if (payment.notes.isNotEmpty)
Padding(
padding:
const EdgeInsets.only(
top: 12,
),
child: Text(
payment.notes,
style: const TextStyle(
color: Colors.grey,
),
),
),

const SizedBox(height: 12),
  Row(
    mainAxisAlignment:
    MainAxisAlignment.end,
    children: [
      TextButton.icon(
        onPressed: () async {
          await _service.deletePayment(
            payment.id,
          );
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        label: const Text(
          "Delete",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    ],
  ),
],
),
),
);
},
);
},
),
);
}

Widget _row(
    String title,
    String value,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4,
    ),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    ),
  );
}
}