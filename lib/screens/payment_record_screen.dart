import 'package:flutter/material.dart';

import '../models/tenant.dart';

class PaymentRecordScreen extends StatefulWidget {
  final Tenant tenant;

  const PaymentRecordScreen({
    super.key,
    required this.tenant,
  });

  @override
  State<PaymentRecordScreen> createState() =>
      _PaymentRecordScreenState();
}

class _PaymentRecordScreenState
    extends State<PaymentRecordScreen> {
final _formKey = GlobalKey<FormState>();

final _amountController =
TextEditingController();

final _referenceController =
TextEditingController();

final _notesController =
TextEditingController();

DateTime _paymentDate = DateTime.now();

String _paymentMethod = "Cash";

final List<String> _methods = [
"Cash",
"M-Pesa",
"Bank Transfer",
"Cheque",
];

@override
void dispose() {
_amountController.dispose();
_referenceController.dispose();
_notesController.dispose();
super.dispose();
}

Future<void> _pickDate() async {
final picked = await showDatePicker(
context: context,
initialDate: _paymentDate,
firstDate: DateTime(2020),
lastDate: DateTime(2100),
);

if (picked != null) {
setState(() {
_paymentDate = picked;
});
}
}

Widget _field(
TextEditingController controller,
String label,
IconData icon, {
TextInputType keyboard =
TextInputType.text,
}) {
return Padding(
padding:
const EdgeInsets.only(bottom: 16),
child: TextFormField(
controller: controller,
keyboardType: keyboard,
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return "Required";
}

return null;
},
decoration: InputDecoration(
labelText: label,
prefixIcon: Icon(icon),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(12),
),
),
),
);
}

Future<void> _savePayment() async {
if (!_formKey.currentState!.validate()) {
return;
}

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(
content: Text(
"Payment module will be connected to Firestore next.",
),
),
);

Navigator.pop(context);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title:
const Text("Record Payment"),
),
body: SingleChildScrollView(
padding:
const EdgeInsets.all(18),
child: Form(
key: _formKey,
child: Column(
children: [
Card(
child: Padding(
padding:
const EdgeInsets.all(16),
child: Column(
children: [
ListTile(
leading: const CircleAvatar(
child:
Icon(Icons.person),
),
title: Text(
widget.tenant.name,
),
subtitle: Text(
widget.tenant.unitId,
),
),

const Divider(),

ListTile(
leading: const Icon(
Icons.payments,
),
title: const Text(
"Monthly Rent",
),
subtitle: Text(
"KES ${widget.tenant.rent.toStringAsFixed(0)}",
),
),
],
),
),
),

const SizedBox(height: 20),

_field(
_amountController,
"Amount Paid",
Icons.payments,
keyboard:
TextInputType.number,
),

  DropdownButtonFormField<String>(
    initialValue: _paymentMethod,
decoration:
const InputDecoration(
labelText:
"Payment Method",
prefixIcon:
Icon(Icons.account_balance_wallet),
border:
OutlineInputBorder(),
),
items: _methods
.map(
(method) =>
DropdownMenuItem(
value: method,
child: Text(method),
),
)
.toList(),
onChanged: (value) {
setState(() {
_paymentMethod =
value!;
});
},
),

const SizedBox(height: 16),              InkWell(
    onTap: _pickDate,
    borderRadius: BorderRadius.circular(12),
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: "Payment Date",
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      child: Text(
        "${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}",
      ),
    ),
  ),

  const SizedBox(height: 16),

  _field(
    _referenceController,
    "Transaction Reference",
    Icons.receipt_long,
  ),

  _field(
    _notesController,
    "Notes",
    Icons.note_alt,
  ),

  const SizedBox(height: 30),

  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed: _savePayment,
      icon: const Icon(Icons.save),
      label: const Text(
        "Record Payment",
        style: TextStyle(fontSize: 16),
      ),
    ),
  ),

  const SizedBox(height: 30),
],
),
),
),
);
}
}